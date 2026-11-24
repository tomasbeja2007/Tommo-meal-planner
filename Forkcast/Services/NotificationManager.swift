import Foundation
import UserNotifications
import Observation
import UIKit

/// Local notifications only: the weekly planning nudge and the trial reminder.
@MainActor
@Observable
final class NotificationManager {
    static let weeklyId: String = "forkcast.weekly-reminder"
    static let trialId: String = "forkcast.trial-reminder"

    private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private var center: UNUserNotificationCenter { UNUserNotificationCenter.current() }

    var isAuthorized: Bool {
        authorizationStatus == .authorized || authorizationStatus == .provisional || authorizationStatus == .ephemeral
    }

    var isDenied: Bool { authorizationStatus == .denied }

    func refreshStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    /// Shows the system prompt (only the first time).
    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted: Bool = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await refreshStatus()
            return granted
        } catch {
            await refreshStatus()
            return false
        }
    }

    /// Repeating reminder. `weekday` is ISO (1 = Monday ... 7 = Sunday).
    func scheduleWeeklyReminder(weekday: Int, hour: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [Self.weeklyId])
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Plan your week")
        content.body = String(localized: "your week's dinners are waiting. 2 minutes to plan, one list to shop.")
        content.sound = .default
        var components = DateComponents()
        components.weekday = (weekday % 7) + 1 // ISO -> Calendar (1 = Sunday)
        components.hour = hour
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        center.add(UNNotificationRequest(identifier: Self.weeklyId, content: content, trigger: trigger))
    }

    func cancelWeeklyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [Self.weeklyId])
    }

    /// One-off reminder `daysBefore` days before the trial ends.
    /// This is a promise made on the reminder screen, so it must be scheduled.
    func scheduleTrialReminder(trialEnd: Date, daysBefore: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [Self.trialId])
        let calendar = Calendar.current
        guard var fireDate = calendar.date(byAdding: .day, value: -max(1, daysBefore), to: trialEnd) else { return }
        if fireDate <= Date() {
            // Very short trial (or sandbox time): remind in a minute rather than never.
            fireDate = Date().addingTimeInterval(60)
        }
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Trial reminder")
        let dateText: String = trialEnd.formatted(date: .abbreviated, time: .omitted)
        content.body = String(localized: "heads-up: your Forkcast trial ends \(dateText). Cancel anytime in Settings.")
        content.sound = .default
        let components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        center.add(UNNotificationRequest(identifier: Self.trialId, content: content, trigger: trigger))
    }

    func cancelTrialReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [Self.trialId])
    }

    func hasPendingTrialReminder() async -> Bool {
        let pending: [UNNotificationRequest] = await center.pendingNotificationRequests()
        return pending.contains { $0.identifier == Self.trialId }
    }

    /// Re-applies the weekly reminder from the profile.
    func apply(profile: UserProfile?) {
        guard let profile, profile.weeklyReminderEnabled else {
            cancelWeeklyReminder()
            return
        }
        scheduleWeeklyReminder(weekday: profile.weeklyReminderWeekday, hour: profile.weeklyReminderHour)
    }

    func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func removeAll() {
        center.removeAllPendingNotificationRequests()
    }
}
