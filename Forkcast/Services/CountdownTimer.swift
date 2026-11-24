import Foundation
import Observation
import UIKit

/// A simple in-app countdown started from a timer chip ("for 20 minutes").
@MainActor
@Observable
final class CountdownTimer {
    private(set) var label: String = ""
    private(set) var totalSeconds: Int = 0
    private(set) var remaining: Int = 0
    private(set) var isRunning: Bool = false
    private(set) var didFinish: Bool = false

    @ObservationIgnored private var task: Task<Void, Never>? = nil

    var isActive: Bool { totalSeconds > 0 && (isRunning || didFinish || remaining > 0) }

    var progress: Double {
        totalSeconds > 0 ? 1 - Double(remaining) / Double(totalSeconds) : 0
    }

    func start(label: String, seconds: Int) {
        task?.cancel()
        self.label = label
        totalSeconds = seconds
        remaining = seconds
        didFinish = false
        isRunning = true
        run()
    }

    func togglePause() {
        if isRunning {
            isRunning = false
            task?.cancel()
        } else if remaining > 0 {
            isRunning = true
            run()
        }
    }

    func stop() {
        task?.cancel()
        isRunning = false
        didFinish = false
        remaining = 0
        totalSeconds = 0
    }

    private func run() {
        task = Task { @MainActor [weak self] in
            while let self, self.isRunning, self.remaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                self.remaining -= 1
            }
            guard let self, self.remaining <= 0, self.totalSeconds > 0 else { return }
            self.isRunning = false
            self.didFinish = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
