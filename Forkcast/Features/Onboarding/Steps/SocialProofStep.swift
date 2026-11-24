import SwiftUI

struct SocialProofStep: View {
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "built for busy weeknights"),
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                    BenefitRow(systemImage: "tag.fill", title: String(localized: "costed to your shop"), subtitle: String(localized: "an approximate total before you leave the house"))
                    BenefitRow(systemImage: "checklist", title: String(localized: "one tidy list"), subtitle: String(localized: "every dinner's ingredients, grouped by aisle"))
                    BenefitRow(systemImage: "hand.raised.fill", title: String(localized: "recipes that fit your rules"), subtitle: String(localized: "allergies and diet are never broken"))
                }
                // TODO: real reviews — replace placeholders with genuine App Store reviews before launch.
                TestimonialCarousel(testimonials: Testimonial.placeholders)
            }
        }
    }
}

struct BenefitRow: View {
    let systemImage: String
    let title: String
    var subtitle: String? = nil

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.tomato)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Theme.tomatoSoft))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

struct Testimonial: Identifiable, Hashable {
    let id: Int
    let quote: String
    let author: String
    let stars: Int

    /// Clearly marked placeholders. Never ship invented reviews.
    static let placeholders: [Testimonial] = [
        Testimonial(id: 1, quote: "Placeholder: replace with a real App Store review before launch", author: "Placeholder", stars: 5),
        Testimonial(id: 2, quote: "Placeholder: replace with a real App Store review before launch", author: "Placeholder", stars: 5),
        Testimonial(id: 3, quote: "Placeholder: replace with a real App Store review before launch", author: "Placeholder", stars: 5)
    ]
}

/// Swipeable review cards.
struct TestimonialCarousel: View {
    let testimonials: [Testimonial]

    var body: some View {
        TabView {
            ForEach(testimonials) { item in
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    HStack(spacing: 2) {
                        ForEach(0..<item.stars, id: \.self) { _ in
                            Image(systemName: "star.fill").foregroundStyle(Theme.saffron).font(.caption)
                        }
                    }
                    .accessibilityLabel(Text("\(item.stars) stars"))
                    Text(item.quote)
                        .font(.body)
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(item.author)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.aubergineMuted)
                    Spacer(minLength: 0)
                }
                .cardStyle()
                .padding(.horizontal, 2)
                .padding(.bottom, 36)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 210)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Theme.tomato)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Theme.line)
        }
    }
}

#Preview { SocialProofStep {}.creamBackground() }
