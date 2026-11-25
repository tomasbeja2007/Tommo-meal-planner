import SwiftUI
import ForkcastCore

/// 16. Before the paywall: Chef Tomato with the bell and a 3-step timeline with real dates.
/// Today (full access) → the reminder (the bell rings) → the trial ends, each with its real date. "Start my free trial" opens
/// the existing paywall plans screen; "Not now" carries on without it.
struct TrialTimelineStep: View {
    let onStartTrial: () -> Void
    let onNotNow: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    /// Must match the intro offer in Forkcast.storekit / App Store Connect (P3D).
    static let trialLengthDays: Int = 3

    /// Days from now until the reminder (trial end minus "remind me N days before").
    private var reminderOffset: Int {
        let before: Int = profileStore.profile?.trialReminderDaysBefore ?? 1
        return max(1, TrialTimelineStep.trialLengthDays - before)
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "we'll ring before you're charged"),
            subtitle: String(localized: "no surprises. Cancel anytime in two taps."),
            buttonTitle: String(localized: "Start my free trial"),
            secondaryTitle: String(localized: "Not now"),
            secondaryAction: onNotNow,
            onContinue: onStartTrial
        ) {
            VStack(spacing: Theme.Spacing.xl) {
                MascotView(size: 150, mood: .bell)
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 0) {
                    TimelineRow(
                        icon: AnyView(Image(systemName: "lock.open.fill")),
                        title: String(localized: "Today"),
                        detail: String(localized: "Full access to every recipe, swap and list."),
                        isLast: false
                    )
                    TimelineRow(
                        icon: AnyView(RingingBell()),
                        title: dateText(afterDays: reminderOffset),
                        detail: String(localized: "We remind you that your trial is ending."),
                        isLast: false
                    )
                    TimelineRow(
                        icon: AnyView(Image(systemName: "star.fill")),
                        title: dateText(afterDays: TrialTimelineStep.trialLengthDays),
                        detail: String(localized: "Your trial ends. Keep going, or cancel before then and pay nothing."),
                        isLast: true
                    )
                }
                .cardStyle()
            }
        }
    }

    /// "Wed 26 Nov"
    private func dateText(afterDays days: Int) -> String {
        let date: Date = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }
}

private struct TimelineRow: View {
    let icon: AnyView
    let title: String
    let detail: String
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            VStack(spacing: 0) {
                icon
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Theme.saffron))
                if !isLast {
                    Rectangle().fill(Theme.saffronSoft).frame(width: 4).frame(minHeight: 28)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, isLast ? 0 : Theme.Spacing.l)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

/// The bell rings every few seconds: quick swings around its top that die down, then a rest.
/// One loop clock; frozen upright with Reduce Motion.
private struct RingingBell: View {
    var body: some View {
        LoopClock(period: 3_200) { t in
            let swing: Double = 16 * sin(t / 1000 * .pi * 2 * 6) * (1 - seg(t, 0, 700, easeOut: false))
            Image(systemName: "bell.fill")
                .rotationEffect(.degrees(t < 700 ? swing : 0), anchor: .top)
        }
    }
}

#Preview { TrialTimelineStep(onStartTrial: {}, onNotNow: {}).previewEnvironment().creamBackground() }
