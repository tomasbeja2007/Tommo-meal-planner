import SwiftUI
import MapKit
import ForkcastCore

// MARK: Locating (the globe)

/// "finding shops near you": a real Apple Maps globe turns to the user's country, a tomato pin drops
/// on it, and the supermarkets we price there pop in around the globe. Then it moves on by itself.
/// Uses the country from the device region (changeable on the next screen); no location permission.
/// Timeline (ms): 0 travel starts · 1 900 pin lands · 2 300 shop logos deal in · 3 900 advance.
struct LocatingStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var camera: MapCameraPosition
    @State private var play = false
    @State private var landed = false
    @State private var advanced = false
    private let globe: CGFloat = 250

    private var country: Country { state.country(in: FoodCatalog.bundled) }
    private var stores: [Store] {
        Array(FoodCatalog.bundled.stores(forCountry: state.countryId).filter { !$0.isLocalStore }.prefix(8))
    }

    init(state: OnboardingState, onContinue: @escaping () -> Void) {
        self.state = state
        self.onContinue = onContinue
        let target = CountryCentre.coordinate(for: state.countryId)
        // Start a third of the way round the world, far out, so the globe visibly turns to them.
        let start = CLLocationCoordinate2D(latitude: max(-60, min(60, target.latitude - 12)), longitude: target.longitude - 75)
        _camera = State(initialValue: .camera(MapCamera(centerCoordinate: start, distance: 24_000_000)))
    }

    var body: some View {
        OneShotClock(duration: 3_900, play: play) { t in
            VStack(spacing: Theme.Spacing.xl) {
                Spacer(minLength: 0)
                ZStack {
                    halo(t)
                    Map(position: $camera, interactionModes: []) {}
                        .mapStyle(.imagery(elevation: .realistic))
                        // Keeps Apple's legal label inside the round window instead of clipped off.
                        .safeAreaPadding(.all, globe * 0.2)
                        .frame(width: globe, height: globe)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.7), lineWidth: 3))
                        .shadow(color: Theme.tomato.opacity(0.18), radius: 22, y: 8)
                    pin(t)
                    shopRing(t)
                }
                .frame(width: globe * 1.5, height: globe * 1.5)
                VStack(spacing: Theme.Spacing.s) {
                    Text(caption(t))
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .contentTransition(.opacity)
                        .animation(Theme.Motion.fadeIn, value: caption(t))
                    StepDashes(active: t < 1_900 ? 0 : (t < 2_300 ? 1 : 2))
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture(perform: advance)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Finding supermarkets in \(country.name)"))
        .sensoryFeedback(.impact(weight: .light), trigger: landed)
        .task { await run() }
    }

    private func caption(_ t: Double) -> String {
        if t < 1_000 { return String(localized: "finding shops near you") }
        if t < 2_300 { return String(localized: "pinpointing \(country.name)") }
        return String(localized: "matching shops in \(country.name)")
    }

    private func run() async {
        let target = MapCamera(centerCoordinate: CountryCentre.coordinate(for: state.countryId), distance: 5_500_000)
        if reduceMotion {
            camera = .camera(target)
        } else {
            withAnimation(Animation.travel(1.8)) { camera = .camera(target) }
        }
        play = true
        try? await Task.sleep(for: .milliseconds(1_900))
        landed = true
        try? await Task.sleep(for: .milliseconds(2_000))
        guard !Task.isCancelled else { return }
        advance()
    }

    /// Moves on once, whether by tap or by the timeline.
    private func advance() {
        guard !advanced else { return }
        advanced = true
        onContinue()
    }

    /// A soft tomato glow that breathes behind the globe (2% over 3 s); it brightens as the pin lands.
    private func halo(_ t: Double) -> some View {
        LoopClock(period: 3_000) { l in
            Circle()
                .fill(RadialGradient(colors: [Theme.tomatoSoft, Theme.cream.opacity(0)], center: .center,
                                     startRadius: globe * 0.4, endRadius: globe * 0.78))
                .frame(width: globe * 1.56, height: globe * 1.56)
                .scaleEffect(1 + 0.02 * wave(l, period: 3_000))
                .opacity(0.55 + 0.45 * seg(t, 1_700, 2_300))
        }
    }

    /// The pin falls the last 40 pt onto the centre (gravity), squashes on contact keeping its volume,
    /// settles, and sends out two ripples. Drawn in SwiftUI: a tomato drop with a cream dot.
    private func pin(_ t: Double) -> some View {
        let fall = seg(t, 1_500, 1_900, easeOut: false)
        let squash = flow(t, [(0, 1), (1_880, 1), (1_960, 0.8), (2_100, 1.06), (2_260, 1), (3_900, 1)])
        return ZStack {
            ForEach(0..<2, id: \.self) { ring in
                let p = seg(t, 1_900 + Double(ring) * 260, 2_700 + Double(ring) * 260)
                Circle()
                    .strokeBorder(Theme.tomato, lineWidth: 2)
                    .frame(width: 18 + 70 * p, height: 18 + 70 * p)
                    .opacity(bell(p) * 0.8)
            }
            PinShape()
                .fill(Theme.tomato)
                .overlay(Circle().fill(Theme.cream).frame(width: 10, height: 10).offset(y: -8))
                .frame(width: 28, height: 38)
                .shadow(color: Theme.aubergine.opacity(0.3), radius: 3, y: 2)
                .scaleEffect(x: 1 / pow(squash, 0.6), y: squash, anchor: .bottom)
                .offset(y: -19 - 40 * (1 - fall))
                .opacity(seg(t, 1_500, 1_620))
        }
    }

    /// The country's supermarkets deal in around the globe, 70 ms apart, from 85% scale (never 0),
    /// then bob very gently on seeded phases so the ring stays alive while the caption reads.
    private func shopRing(_ t: Double) -> some View {
        LoopClock(period: 12_000) { l in
            ZStack {
                ForEach(Array(stores.enumerated()), id: \.element.id) { index, store in
                    let angle = 2 * Double.pi * Double(index) / Double(max(1, stores.count)) - .pi / 2
                    let p = seg(t, 2_300 + Double(index) * 70, 2_700 + Double(index) * 70)
                    let bob = 3 * wave(l, period: [3_000, 4_000, 6_000][index % 3], phase: seeded(index))
                    StoreLogo(store: store, height: 26)
                        .frame(width: 70, height: 34)
                        .background(Capsule().fill(Theme.card))
                        .overlay(Capsule().stroke(Theme.line, lineWidth: 1))
                        .shadow(color: Theme.aubergine.opacity(0.1), radius: 5, y: 3)
                        .scaleEffect(0.85 + 0.15 * p)
                        .opacity(p)
                        .offset(x: cos(angle) * Double(globe) * 0.66, y: sin(angle) * Double(globe) * 0.66 + bob)
                }
            }
        }
    }
}

/// Three short dashes; the active one is longer and darker (which phase of the search we're in).
struct StepDashes: View {
    let active: Int
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == active ? Theme.aubergine : Theme.aubergineFaint.opacity(0.5))
                    .frame(width: index == active ? 22 : 10, height: 4)
            }
        }
        .animation(Theme.spring, value: active)
        .accessibilityHidden(true)
    }
}

/// A map pin: a circle head tapering to a point at the bottom centre.
private struct PinShape: Shape {
    func path(in rect: CGRect) -> Path {
        let r = rect.width / 2
        let centre = CGPoint(x: rect.midX, y: rect.minY + r)
        var p = Path()
        p.addArc(center: centre, radius: r, startAngle: .degrees(150), endAngle: .degrees(30), clockwise: false)
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX - r * 0.35, y: rect.minY + r * 1.9))
        p.addQuadCurve(to: CGPoint(x: centre.x - r * cos(.pi / 6), y: centre.y + r * sin(.pi / 6)),
                       control: CGPoint(x: rect.minX + r * 0.35, y: rect.minY + r * 1.9))
        p.closeSubpath()
        return p
    }
}

/// Where to point the globe for each supported country (a central point on land).
enum CountryCentre {
    static func coordinate(for countryId: String) -> CLLocationCoordinate2D {
        switch countryId {
        case "us": return .init(latitude: 39.5, longitude: -98.4)
        case "gb": return .init(latitude: 53.5, longitude: -1.9)
        case "ie": return .init(latitude: 53.3, longitude: -7.9)
        case "pt": return .init(latitude: 39.6, longitude: -8.1)
        case "es": return .init(latitude: 40.3, longitude: -3.7)
        case "fr": return .init(latitude: 46.6, longitude: 2.4)
        case "de": return .init(latitude: 51.1, longitude: 10.4)
        case "nl": return .init(latitude: 52.2, longitude: 5.3)
        case "it": return .init(latitude: 42.8, longitude: 12.6)
        case "be": return .init(latitude: 50.6, longitude: 4.6)
        case "at": return .init(latitude: 47.6, longitude: 14.1)
        case "ca": return .init(latitude: 50.0, longitude: -97.0)
        case "au": return .init(latitude: -25.3, longitude: 134.0)
        default: return .init(latitude: 30, longitude: 0)
        }
    }
}

// MARK: Shops (logos instead of reviews)

/// "Built for the shops you already use": every supermarket we price in their country, as a logo wall
/// that deals in, with their main shop lifted and labelled. No reviews, no invented numbers.
struct ShopsStep: View {
    let state: OnboardingState
    let onContinue: () -> Void
    @State private var play = false

    private var country: Country { state.country(in: FoodCatalog.bundled) }
    private var stores: [Store] { FoodCatalog.bundled.stores(forCountry: state.countryId).filter { !$0.isLocalStore } }
    private var main: Store? { FoodCatalog.bundled.store(id: state.mainStoreId) }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "built for the shops in \(country.name)"),
            subtitle: String(localized: "estimated prices for \(stores.count) supermarkets, so your plan fits the shop you actually use"),
            onContinue: onContinue
        ) {
            OneShotClock(duration: 1_400, play: play) { t in
                VStack(spacing: Theme.Spacing.l) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.s), count: 3), spacing: Theme.Spacing.s) {
                        ForEach(Array(stores.enumerated()), id: \.element.id) { index, store in
                            let isMain = store.id == main?.id
                            let p = seg(t, Double(index) * 55, 380 + Double(index) * 55)
                            StoreLogo(store: store, height: 34)
                                .padding(.horizontal, 6)
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                                    .fill(isMain ? Theme.tomatoSoft : Theme.card))
                                .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                                    .stroke(isMain ? Theme.tomato : Theme.line, lineWidth: isMain ? 2 : 1))
                                .scaleEffect(0.88 + 0.12 * p)
                                .opacity(p)
                                .accessibilityLabel(Text(store.name))
                        }
                    }
                    if let main {
                        Label {
                            Text("your week is priced at \(main.name)")
                        } icon: {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.herb)
                        }
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .frame(maxWidth: .infinity)
                        .opacity(seg(t, 900, 1_300))
                    }
                }
            }
            .onAppear { play = true }
        }
    }
}
