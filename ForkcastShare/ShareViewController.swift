import UIKit
import SwiftUI
import UniformTypeIdentifiers
import ForkcastCore

/// Share Extension: accepts a URL or text, saves it to the App Group as
/// `pending-import.json`, shows a tiny confirmation and tries to open Forkcast.
final class ShareViewController: UIViewController {
    private let state = ShareState()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let host = UIHostingController(rootView: ShareConfirmationView(state: state) { [weak self] in
            self?.finish()
        })
        host.view.backgroundColor = .clear
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
        Task { await handleInput() }
    }

    private func handleInput() async {
        let items: [NSExtensionItem] = (extensionContext?.inputItems as? [NSExtensionItem]) ?? []
        var foundURL: String? = nil
        var foundText: String? = nil
        for item in items {
            if foundText == nil, let content = item.attributedContentText?.string, !content.isEmpty {
                foundText = content
            }
            for provider in item.attachments ?? [] {
                if foundURL == nil, provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    if let url = try? await provider.loadItem(forTypeIdentifier: UTType.url.identifier) as? URL {
                        foundURL = url.absoluteString
                    }
                }
                if foundText == nil, provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    if let text = try? await provider.loadItem(forTypeIdentifier: UTType.plainText.identifier) as? String {
                        foundText = text
                    }
                }
            }
        }
        await MainActor.run {
            if foundURL == nil && foundText == nil {
                state.status = .nothing
                return
            }
            do {
                try PendingImport(url: foundURL, text: foundText).write()
                state.status = .saved
                openMainApp()
            } catch {
                state.status = .nothing
            }
        }
    }

    /// Best effort: extensions can't officially open their host app, so walk
    /// the responder chain. If it doesn't work, the confirmation tells the user to open Forkcast.
    private func openMainApp() {
        guard let url = URL(string: "\(SharedConstants.urlScheme)://import") else { return }
        let selector: Selector = NSSelectorFromString("openURL:")
        var responder: UIResponder? = self
        while let current = responder {
            if current.responds(to: selector), current !== self {
                _ = current.perform(selector, with: url)
                return
            }
            responder = current.next
        }
    }

    private func finish() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

@MainActor
final class ShareState: ObservableObject {
    enum Status {
        case working
        case saved
        case nothing
    }

    @Published var status: Status = .working
}

struct ShareConfirmationView: View {
    @ObservedObject var state: ShareState
    let onDone: () -> Void

    private let cream = Color(red: 251 / 255, green: 246 / 255, blue: 238 / 255)
    private let tomato = Color(red: 232 / 255, green: 85 / 255, blue: 61 / 255)
    private let aubergine = Color(red: 43 / 255, green: 30 / 255, blue: 46 / 255)

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(tomato)
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(aubergine)
                    .multilineTextAlignment(.center)
                Button(action: onDone) {
                    Text("Done")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(tomato))
                }
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(cream))
            .padding(20)
        }
        .task(id: state.status) {
            guard state.status == .saved else { return }
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            onDone()
        }
    }

    private var icon: String {
        switch state.status {
        case .working: return "hourglass"
        case .saved: return "checkmark.circle.fill"
        case .nothing: return "exclamationmark.circle"
        }
    }

    private var title: String {
        switch state.status {
        case .working: return "Sending to Forkcast…"
        case .saved: return "sent to Forkcast, open the app to finish"
        case .nothing: return "Nothing to import here. Try sharing a link or the caption text."
        }
    }
}
