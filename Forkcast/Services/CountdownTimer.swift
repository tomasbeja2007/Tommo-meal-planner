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

    @ObservationIgnored private var deadline: ContinuousClock.Instant?
    @ObservationIgnored private var pausedDuration: Duration = .zero
    @ObservationIgnored private var task: Task<Void, Never>? = nil

    var isActive: Bool { totalSeconds > 0 && (isRunning || didFinish || remaining > 0) }

    var progress: Double {
        totalSeconds > 0 ? 1 - Double(remaining) / Double(totalSeconds) : 0
    }

    func start(label: String, seconds: Int) {
        guard seconds > 0 else { return }
        task?.cancel()
        self.label = label
        totalSeconds = seconds
        remaining = seconds
        didFinish = false
        resume(for: .seconds(seconds))
    }

    func togglePause() {
        if let deadline {
            let duration = ContinuousClock().now.duration(to: deadline)
            if duration <= .zero {
                finish()
                return
            }
            pausedDuration = duration
            self.deadline = nil
            isRunning = false
            task?.cancel()
        } else if pausedDuration > .zero {
            resume(for: pausedDuration)
        }
    }

    func reset() {
        start(label: label, seconds: totalSeconds)
    }

    func stop() {
        task?.cancel()
        deadline = nil
        pausedDuration = .zero
        isRunning = false
        didFinish = false
        remaining = 0
        totalSeconds = 0
    }

    private func resume(for duration: Duration) {
        let end = ContinuousClock().now.advanced(by: duration)
        deadline = end
        pausedDuration = .zero
        isRunning = true
        task = Task { @MainActor [weak self] in
            let clock = ContinuousClock()
            while !Task.isCancelled {
                let untilEnd = clock.now.duration(to: end)
                guard untilEnd > .zero else {
                    self?.finish()
                    return
                }
                let components = untilEnd.components
                self?.remaining = Int(components.seconds) + (components.attoseconds > 0 ? 1 : 0)
                guard self != nil else { return }
                let untilNextSecond = components.attoseconds > 0
                    ? Duration(secondsComponent: 0, attosecondsComponent: components.attoseconds)
                    : .seconds(1)
                try? await clock.sleep(for: untilNextSecond)
            }
        }
    }

    private func finish() {
        deadline = nil
        pausedDuration = .zero
        remaining = 0
        isRunning = false
        didFinish = true
        task?.cancel()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
