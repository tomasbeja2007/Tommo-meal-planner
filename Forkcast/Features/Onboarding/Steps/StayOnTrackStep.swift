import SwiftUI
import ForkcastCore

/// 15. Our own pre-permission screen; the system prompt only appears if they tap
/// "Turn on reminders". "Not now" is fine.
///
/// Layout: question header at the top, then a centred phone with Chef Tomato standing at its
/// lower-left corner presenting it, then the buttons. The phone shows today's date and the two
/// reminders we actually send (tonight's real dinner, and the trial heads-up). They slide down
/// once with ease-out, 250 ms apart; with Reduce Motion they're simply there.
struct StayOnTrackStep: View {
    let onContinue: () -> Void

    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @State private var isAsking: Bool = false
    @State private var showsNotifications: Bool = false

    /// "Smoky black bean tacos with lime slaw · 20 min"
    private var dinnerMessage: String {
        guard let first = planStore.meals.first(where: { $0.mealType == .dinner }) ?? planStore.meals.first,
              let recipe = repository.recipe(id: first.recipeId) else {
            return String(localized: "Your first dinner is ready to cook.")
        }
        let minutes: Int = recipe.prepMinutes + recipe.cookMinutes
        return String(localized: "\(recipe.title) · \(minutes) min")
    }

    var body: some View {
        VStack(spacing: 0) {
            QuestionHeader(
                title: String(localized: "stay on track"),
                subtitle: String(localized: "two kinds of reminder, nothing else. Turn them off anytime.")
            )
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.top, Theme.Spacing.m)

            Spacer(minLength: Theme.Spacing.l)

            ZStack(alignment: .bottomLeading) {
                PhoneMock(showsNotifications: showsNotifications, dinnerMessage: dinnerMessage)
                    .frame(maxWidth: .infinity)
                MascotView(size: 132, mood: .idle)
                    .offset(x: -6, y: 18)
            }
            .padding(.horizontal, Theme.Spacing.gutter)

            Spacer(minLength: Theme.Spacing.xl)

            VStack(spacing: Theme.Spacing.xs) {
                PrimaryButton(String(localized: "Turn on reminders"), action: ask)
                    .disabled(isAsking)
                Button(String(localized: "Not now"), action: onContinue)
                    .buttonStyle(QuietButtonStyle())
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.s)
        }
        .onAppear { showsNotifications = true }
    }

    private func ask() {
        isAsking = true
        Task {
            _ = await notifications.requestAuthorization()
            isAsking = false
            onContinue()
        }
    }
}

/// A simple lock screen: date, clock, and the two notifications stacked under it.
private struct PhoneMock: View {
    let showsNotifications: Bool
    let dinnerMessage: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    /// 5:30 pm today, in the phone's own time format.
    static var dinnerTime: String {
        let date: Date = Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: Date()) ?? Date()
        return date.formatted(.dateTime.hour().minute())
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            Capsule()
                .fill(Theme.aubergine)
                .frame(width: 64, height: 18)
                .padding(.top, Theme.Spacing.m)
            VStack(spacing: 0) {
                Text(Date().formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                Text(Date().formatted(.dateTime.hour().minute()))
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergine)
            }
            .padding(.bottom, Theme.Spacing.s)
            VStack(spacing: Theme.Spacing.s) {
                NotificationBanner(
                    systemImage: "fork.knife",
                    title: String(localized: "Tonight"),
                    time: PhoneMock.dinnerTime,
                    message: dinnerMessage
                )
                .slideIn(showsNotifications, delay: 0.15, reduceMotion: reduceMotion)
                NotificationBanner(
                    systemImage: "bell.fill",
                    title: String(localized: "Trial ends soon"),
                    time: String(localized: "in 2 days"),
                    message: String(localized: "A heads-up before you're charged. No surprises.")
                )
                .slideIn(showsNotifications, delay: 0.4, reduceMotion: reduceMotion)
            }
            .padding(.horizontal, Theme.Spacing.m)
            Spacer(minLength: Theme.Spacing.xl)
        }
        .frame(width: 232, height: 340)
        .background(
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(LinearGradient(colors: [Theme.saffronSoft, Theme.tomatoSoft], startPoint: .top, endPoint: .bottom))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .stroke(Theme.aubergine, lineWidth: 6)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Example reminders: \(dinnerMessage). And a heads-up before your trial ends."))
    }
}

private struct NotificationBanner: View {
    let systemImage: String
    let title: String
    let time: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.s) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(width: 30, height: 30)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Theme.tomato))
            VStack(alignment: .leading, spacing: 1) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                    Spacer(minLength: 4)
                    Text(time)
                        .font(.caption2)
                        .foregroundStyle(Theme.aubergineFaint)
                }
                Text(message)
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineMuted)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Theme.Spacing.s)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.card.opacity(0.92)))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

private extension View {
    /// Drops in from 16 pt above with ease-out, once. Final frame straight away with Reduce Motion.
    func slideIn(_ shown: Bool, delay: Double, reduceMotion: Bool) -> some View {
        self
            .opacity(shown ? 1 : 0)
            .offset(y: shown || reduceMotion ? 0 : -16)
            .animation(reduceMotion ? nil : Animation.open(0.35).delay(delay), value: shown)
    }
}

#Preview { StayOnTrackStep {}.previewEnvironment().creamBackground() }
