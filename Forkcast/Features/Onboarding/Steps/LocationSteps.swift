import SwiftUI
import CoreLocation
import ForkcastCore

// MARK: Locating (the globe)

/// "finding shops near you": an illustrated globe rises in already turning, spins and glides to a stop
/// on the user's country, a tomato pin falls onto it (the globe gives a little under the impact), flat
/// ripples spread across the surface, and the supermarkets we price there deal in around it. Then it
/// moves on by itself (or on a tap). Uses the country from the device region; no permissions.
/// One one-shot clock for the scene plus one idle loop. Every time and size is in `GlobeMotion`.
struct LocatingStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    @State private var play = false
    @State private var landed = false
    @State private var shopsShown = false
    @State private var advanced = false
    private let globe: CGFloat = 236

    private var country: Country { state.country(in: FoodCatalog.bundled) }
    private var target: (lon: Double, lat: Double) {
        let c = CountryCentre.coordinate(for: state.countryId)
        return (c.longitude, c.latitude)
    }
    private var stores: [Store] {
        Array(FoodCatalog.bundled.stores(forCountry: state.countryId).filter { !$0.isLocalStore }.prefix(8))
    }
    private var captions: [String] {
        [String(localized: "finding shops near you"),
         String(localized: "pinpointing \(country.name)"),
         String(localized: "matching shops in \(country.name)")]
    }

    var body: some View {
        OneShotClock(duration: GlobeMotion.duration, play: play) { t in
            LoopClock(period: GlobeMotion.idlePeriod) { l in
                let view = camera(t, l)
                let stage = globe * 1.6
                VStack(spacing: Theme.Spacing.xl) {
                    Spacer(minLength: 0)
                    ZStack {
                        atmosphere(t, l)
                        GlobeView(lon0: view.lon, lat0: view.lat)
                            .frame(width: globe, height: globe)
                            .scaleEffect(globeScale(t))
                            .offset(y: 18 * (1 - seg(t, 0, GlobeMotion.enterMs)))
                            .opacity(seg(t, 0, GlobeMotion.enterMs * 0.5))
                        pin(t, at: GlobeView.point(lon: target.lon, lat: target.lat, lon0: view.lon, lat0: view.lat, radius: globe / 2), stage: stage)
                        shopRing(t, l)
                    }
                    .frame(width: stage, height: stage)
                    VStack(spacing: Theme.Spacing.s) {
                        captionView(t)
                        StepDashes(active: t < GlobeMotion.captionTimes[1] ? 0 : (t < GlobeMotion.captionTimes[2] ? 1 : 2))
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: advance)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Finding supermarkets in \(country.name)"))
        .sensoryFeedback(.impact(weight: .light), trigger: landed)
        .sensoryFeedback(.selection, trigger: shopsShown)
        .task { await run() }
    }

    /// Where the globe looks. It starts `spinDegrees` away and turns towards the country on a power
    /// curve (already moving when it fades in, never stopping with a jolt), tilting to the country's
    /// latitude as it goes. Once settled, a ±2.5° drift keeps it alive; the pin rides along with it.
    private func camera(_ t: Double, _ l: Double) -> (lon: Double, lat: Double) {
        let p = min(1, max(0, t / GlobeMotion.landMs))
        let s = 1 - pow(1 - p, GlobeMotion.spinPower)
        let tilt = max(-35, min(45, target.lat - 8))
        let drift = GlobeMotion.drift * wave(l, period: GlobeMotion.idlePeriod) * seg(t, GlobeMotion.landMs, GlobeMotion.landMs + 1_200)
        // Longitude falls towards the target, so land drifts left to right, the way the Earth turns.
        return (target.lon + GlobeMotion.spinDegrees * (1 - s) + drift,
                GlobeMotion.startTilt + (tilt - GlobeMotion.startTilt) * s)
    }

    /// Rises in from 92%, then gives 1.2% under the pin's impact and springs back (follow-through).
    private func globeScale(_ t: Double) -> CGFloat {
        let land = GlobeMotion.landMs
        let give = flow(t, [(0, 0), (land, 0), (land + 90, 1), (land + 260, -0.35), (land + 460, 0), (GlobeMotion.duration, 0)])
        return CGFloat((0.92 + 0.08 * seg(t, 0, GlobeMotion.enterMs)) * (1 + 0.012 * give))
    }

    /// One caption at a time: the old one lifts away and fades (160 ms, before the next begins), the new
    /// one rises in (260 ms). Driven by the scene clock, so two lines never sit on top of each other.
    private func captionView(_ t: Double) -> some View {
        let times = GlobeMotion.captionTimes
        return ZStack {
            ForEach(captions.indices, id: \.self) { i in
                let enter = i == 0 ? 1 : seg(t, times[i], times[i] + 260)
                let leave = i + 1 < times.count ? seg(t, times[i + 1] - 160, times[i + 1], easeOut: false) : 0
                Text(captions[i])
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .opacity(enter * (1 - leave))
                    .offset(y: 8 * (1 - enter) - 8 * leave)
            }
        }
        .padding(.horizontal, Theme.Spacing.gutter)
    }

    private func run() async {
        play = true
        try? await Task.sleep(for: .milliseconds(Int(GlobeMotion.landMs)))
        landed = true
        try? await Task.sleep(for: .milliseconds(Int(GlobeMotion.captionTimes[2] - GlobeMotion.landMs)))
        shopsShown = true
        try? await Task.sleep(for: .milliseconds(Int(GlobeMotion.duration - GlobeMotion.captionTimes[2])))
        guard !Task.isCancelled else { return }
        advance()
    }

    /// Moves on once, whether by tap or by the timeline.
    private func advance() {
        guard !advanced else { return }
        advanced = true
        onContinue()
    }

    /// A soft blue atmosphere round the globe: it blooms in with the globe, breathes 2% over the idle
    /// loop and brightens for a moment when the pin lands.
    private func atmosphere(_ t: Double, _ l: Double) -> some View {
        let flash = bell(seg(t, GlobeMotion.landMs, GlobeMotion.landMs + 800, easeOut: false))
        return Circle()
            .fill(RadialGradient(colors: [Theme.Illustration.atmosphere.opacity(0.55 + 0.25 * flash), Theme.Illustration.atmosphere.opacity(0)],
                                 center: .center, startRadius: globe * 0.46, endRadius: globe * 0.72))
            .frame(width: globe * 1.5, height: globe * 1.5)
            .scaleEffect((0.9 + 0.1 * seg(t, 0, GlobeMotion.enterMs)) * (1 + 0.02 * wave(l, period: GlobeMotion.idlePeriod / 2)))
            .opacity(seg(t, 0, GlobeMotion.enterMs))
    }

    /// The pin falls the last 40 pt onto the country with gravity, squashes on contact keeping its volume,
    /// overshoots a touch and settles. Three flat ripples (ellipses, so they lie on the surface) spread
    /// from its tip, and its contact shadow grows as it lands.
    private func pin(_ t: Double, at point: CGPoint, stage: CGFloat) -> some View {
        let land = GlobeMotion.landMs
        let fall = seg(t, land - 330, land, easeOut: false)
        let gravity = fall * fall
        let squash = flow(t, [(0, 1), (land - 20, 1), (land + 70, 0.78), (land + 210, 1.07), (land + 360, 0.98), (land + 480, 1), (GlobeMotion.duration, 1)])
        return ZStack {
            ForEach(0..<3, id: \.self) { ring in
                let p = seg(t, land + Double(ring) * 420, land + 1_000 + Double(ring) * 420)
                Ellipse()
                    .strokeBorder(Theme.tomato, lineWidth: 1.6)
                    .frame(width: 12 + 84 * p, height: (12 + 84 * p) * 0.45)
                    .opacity(bell(p) * 0.8)
            }
            Ellipse()
                .fill(Color.black.opacity(0.28 * gravity))
                .frame(width: 16 * (0.4 + 0.6 * gravity), height: 6 * (0.4 + 0.6 * gravity))
                .blur(radius: 1.5)
            PinShape()
                .fill(LinearGradient(colors: [Theme.tomato, Theme.tomatoDeep], startPoint: .top, endPoint: .bottom))
                .overlay(Circle().fill(Theme.cream).frame(width: 10, height: 10).offset(y: -8))
                .frame(width: 28, height: 38)
                .shadow(color: Theme.aubergine.opacity(0.3), radius: 3, y: 2)
                .scaleEffect(x: 1 / pow(squash, 0.6), y: squash, anchor: .bottom)
                .offset(y: -19 - 40 * (1 - gravity))
                .opacity(seg(t, land - 330, land - 200))
        }
        .position(x: stage / 2 + point.x, y: stage / 2 + point.y)
    }

    /// The country's supermarkets deal in around the globe, 70 ms apart, from 85% scale (never 0),
    /// then bob very gently on seeded phases so the ring stays alive while the caption reads.
    private func shopRing(_ t: Double, _ l: Double) -> some View {
        let start = GlobeMotion.captionTimes[2]
        return ZStack {
            ForEach(Array(stores.enumerated()), id: \.element.id) { index, store in
                let angle = 2 * Double.pi * Double(index) / Double(max(1, stores.count)) - .pi / 2
                let p = seg(t, start + Double(index) * 70, start + 420 + Double(index) * 70)
                let bob = 3 * wave(l, period: [2_000, 4_000, 8_000][index % 3], phase: seeded(index))
                StoreLogo(store: store, height: 26)
                    .frame(width: 70, height: 34)
                    .background(Capsule().fill(Theme.card))
                    .overlay(Capsule().stroke(Theme.line, lineWidth: 1))
                    .elevation(Theme.Elevation.subtle)
                    .scaleEffect(0.85 + 0.15 * p)
                    .opacity(p)
                    .offset(x: cos(angle) * Double(globe) * 0.7, y: sin(angle) * Double(globe) * 0.7 + bob - 8 * (1 - p))
            }
        }
    }
}

/// Every number for the globe scene (ms, degrees).
enum GlobeMotion {
    static let duration: Double = 4_700
    /// Rise-in of the globe and its atmosphere.
    static let enterMs: Double = 650
    /// The spin ends and the pin touches down at the same moment.
    static let landMs: Double = 2_900
    static let spinDegrees: Double = 220
    /// 1 − (1 − p)^2: starts turning at ~150°/s and glides to a stop without a jolt.
    static let spinPower: Double = 2.0
    static let startTilt: Double = 12
    static let drift: Double = 2.5
    static let idlePeriod: Double = 8_000
    /// When each caption takes over: searching, pinpointing (just before the pin falls), matching shops.
    static let captionTimes: [Double] = [0, 1_500, 3_300]
}

/// An illustrated Earth drawn in one `Canvas`: real coastlines (Natural Earth 1:110m land, public domain,
/// simplified) in an orthographic projection, land clipped to the front hemisphere and closed along the
/// limb, then a glossy ocean, a specular highlight, a soft shadow edge and a rim light.
struct GlobeView: View {
    let lon0: Double
    let lat0: Double

    var body: some View {
        Canvas { ctx, size in
            let r = min(size.width, size.height) / 2
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let rect = CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)
            let disc = Path(ellipseIn: rect)
            ctx.fill(disc, with: .radialGradient(Gradient(colors: [Theme.Illustration.oceanLight, Theme.Illustration.oceanDeep]),
                                                 center: CGPoint(x: c.x - r * 0.35, y: c.y - r * 0.4),
                                                 startRadius: 0, endRadius: r * 1.6))
            var land = Path()
            let l0 = lon0 * .pi / 180, p0 = lat0 * .pi / 180
            let sinP0 = sin(p0), cosP0 = cos(p0)
            for polygon in GlobeData.polygons {
                for ring in GlobeView.clip(polygon, l0: l0, sinP0: sinP0, cosP0: cosP0) where ring.count >= 3 {
                    land.addLines(ring.map { CGPoint(x: c.x + $0.x * r, y: c.y - $0.y * r) })
                    land.closeSubpath()
                }
            }
            var inside = ctx
            inside.clip(to: disc)
            // Faint meridians and parallels: they make the turning readable even over open ocean.
            inside.stroke(GlobeView.graticule(l0: l0, sinP0: sinP0, cosP0: cosP0, centre: c, radius: r),
                          with: .color(Color.white.opacity(0.13)), lineWidth: 0.7)
            inside.fill(land, with: .radialGradient(Gradient(colors: [Theme.Illustration.landLight, Theme.Illustration.landDeep]),
                                                    center: CGPoint(x: c.x - r * 0.35, y: c.y - r * 0.4),
                                                    startRadius: 0, endRadius: r * 1.6))
            inside.stroke(land, with: .color(Theme.Illustration.coast.opacity(0.45)), lineWidth: 0.6)
            // Light from the top left: a soft specular bloom, then the far edge falling into shadow.
            inside.fill(disc, with: .radialGradient(Gradient(colors: [Color.white.opacity(0.32), Color.white.opacity(0)]),
                                                    center: CGPoint(x: c.x - r * 0.38, y: c.y - r * 0.42),
                                                    startRadius: 0, endRadius: r * 0.9))
            inside.fill(disc, with: .radialGradient(Gradient(stops: [.init(color: .clear, location: 0.6),
                                                                     .init(color: Color.black.opacity(0.3), location: 1)]),
                                                    center: CGPoint(x: c.x - r * 0.2, y: c.y - r * 0.25),
                                                    startRadius: 0, endRadius: r * 1.25))
            ctx.stroke(Path(ellipseIn: rect.insetBy(dx: 1, dy: 1)), with: .color(Color.white.opacity(0.35)), lineWidth: 1.5)
        }
        .accessibilityHidden(true)
    }

    /// Meridians every 30° and parallels every 30°, drawn only where they face us (the path breaks
    /// wherever a line goes round the back).
    static func graticule(l0: Double, sinP0: Double, cosP0: Double, centre c: CGPoint, radius r: CGFloat) -> Path {
        var path = Path()
        func trace(_ points: [(lon: Double, lat: Double)]) {
            var drawing = false
            for point in points {
                let p = point.lat * .pi / 180, d = point.lon * .pi / 180 - l0
                let cp = cos(p), sp = sin(p), cd = cos(d)
                let z = sinP0 * sp + cosP0 * cp * cd
                guard z >= 0 else { drawing = false; continue }
                let screen = CGPoint(x: c.x + cp * sin(d) * r, y: c.y - (cosP0 * sp - sinP0 * cp * cd) * r)
                if drawing { path.addLine(to: screen) } else { path.move(to: screen); drawing = true }
            }
        }
        for lon in stride(from: -180.0, to: 180, by: 30) {
            trace(stride(from: -84.0, through: 84, by: 4).map { (lon: lon, lat: $0) })
        }
        for lat in stride(from: -60.0, through: 60, by: 30) {
            trace(stride(from: -180.0, through: 180, by: 4).map { (lon: $0, lat: lat) })
        }
        return path
    }

    /// Screen offset from the globe's centre of a place, for pinning things to it.
    static func point(lon: Double, lat: Double, lon0: Double, lat0: Double, radius: CGFloat) -> CGPoint {
        let p = lat * .pi / 180, d = (lon - lon0) * .pi / 180, p0 = lat0 * .pi / 180
        let x = cos(p) * sin(d)
        let y = cos(p0) * sin(p) - sin(p0) * cos(p) * cos(d)
        return CGPoint(x: x * radius, y: -y * radius)
    }

    /// Orthographic projection of one counter-clockwise land ring, clipped to the visible hemisphere
    /// (Weiler–Atherton): each visible run is closed by walking the limb counter-clockwise to the next
    /// place the coast comes back into view. Returns rings in unit-disc coordinates, y up.
    static func clip(_ ring: [GeoPoint], l0: Double, sinP0: Double, cosP0: Double) -> [[CGPoint]] {
        let n = ring.count
        var xs = [Double](repeating: 0, count: n), ys = xs, zs = xs
        var anyVisible = false, allVisible = true
        for i in 0..<n {
            let g = ring[i]
            let d = g.lambda - l0
            let cd = cos(d)
            xs[i] = g.cosPhi * sin(d)
            ys[i] = cosP0 * g.sinPhi - sinP0 * g.cosPhi * cd
            zs[i] = sinP0 * g.sinPhi + cosP0 * g.cosPhi * cd
            if zs[i] >= 0 { anyVisible = true } else { allVisible = false }
        }
        if allVisible { return [(0..<n).map { CGPoint(x: xs[$0], y: ys[$0]) }] }
        guard anyVisible, let start = zs.firstIndex(where: { $0 < 0 }) else { return [] }

        var chains: [[CGPoint]] = []
        var current: [CGPoint]? = nil
        for k in 0..<n {
            let i = (start + k) % n, j = (i + 1) % n
            let vi = zs[i] >= 0, vj = zs[j] >= 0
            if vi { current?.append(CGPoint(x: xs[i], y: ys[i])) }
            if vi != vj {
                let t = zs[i] / (zs[i] - zs[j])
                var x = xs[i] + (xs[j] - xs[i]) * t, y = ys[i] + (ys[j] - ys[i]) * t
                let m = max(1e-9, (x * x + y * y).squareRoot())
                x /= m; y /= m
                if !vi {
                    current = [CGPoint(x: x, y: y)]
                } else if var chain = current {
                    chain.append(CGPoint(x: x, y: y))
                    chains.append(chain)
                    current = nil
                }
            }
        }
        guard !chains.isEmpty else { return [] }

        var rings: [[CGPoint]] = []
        var used = [Bool](repeating: false, count: chains.count)
        let step = 3 * Double.pi / 180
        for first in chains.indices where !used[first] {
            var out: [CGPoint] = []
            var c = first
            while true {
                used[c] = true
                out += chains[c]
                let exit = chains[c][chains[c].count - 1]
                let aOut = atan2(exit.y, exit.x)
                var best = first, bestGap = Double.infinity
                for (k, chain) in chains.enumerated() {
                    var gap = (atan2(chain[0].y, chain[0].x) - aOut).truncatingRemainder(dividingBy: 2 * .pi)
                    if gap < 0 { gap += 2 * .pi }
                    if gap < bestGap { bestGap = gap; best = k }
                }
                let steps = Int(bestGap / step)
                if steps > 1 {
                    for i in 1..<steps {
                        let a = aOut + bestGap * Double(i) / Double(steps)
                        out.append(CGPoint(x: cos(a), y: sin(a)))
                    }
                }
                c = best
                if used[c] { break }
            }
            rings.append(out)
        }
        return rings
    }
}

/// A point on the sphere, with its latitude's sine and cosine cached for fast projection.
struct GeoPoint {
    let lambda: Double
    let sinPhi: Double
    let cosPhi: Double
}

/// Natural Earth 1:110m land (public domain, naturalearthdata.com), Antarctica and tiny islands left out,
/// simplified to 0.35°, rings counter-clockwise. "lon,lat" in tenths of a degree; ";" between points,
/// "|" between rings. Densified to 2° steps when parsed so edges bend with the sphere.
enum GlobeData {
    static let polygons: [[GeoPoint]] = encoded.split(separator: "|").map { ring in
        let points: [(Double, Double)] = ring.split(separator: ";").compactMap { pair in
            let v = pair.split(separator: ",")
            guard v.count == 2, let lon = Double(v[0]), let lat = Double(v[1]) else { return nil }
            return (lon / 10, lat / 10)
        }
        var dense: [GeoPoint] = []
        for i in points.indices {
            let a = points[i], b = points[(i + 1) % points.count]
            let k = max(1, Int(max(abs(b.0 - a.0), abs(b.1 - a.1)) / 2))
            for j in 0..<k {
                let lon = a.0 + (b.0 - a.0) * Double(j) / Double(k)
                let lat = (a.1 + (b.1 - a.1) * Double(j) / Double(k)) * .pi / 180
                dense.append(GeoPoint(lambda: lon * .pi / 180, sinPhi: sin(lat), cosPhi: cos(lat)))
            }
        }
        return dense
    }

    private static let encoded = "-686,-526;-693,-525;-711,-541;-747,-528;-723,-545;-692,-555;-681,-556;-670,-549;-655,-552;-650,-547;-678,-538|-612,-518;-607,-523;-580,-519;-578,-516;-586,-511|1447,-407;1447,-412;1460,-435;1479,-432;1483,-409;1454,-408|1728,-405;1721,-410;1705,-430;1670,-451;1667,-462;1693,-466;1706,-459;1715,-442;1731,-439;1727,-434;1742,-413;1730,-409|1743,-353;1726,-345;1747,-374;1746,-388;1738,-395;1749,-399;1752,-405;1747,-413;1752,-417;1760,-413;1772,-391;1780,-392;1785,-377;1768,-379;1754,-365;1753,-372;1746,-362|1640,-201;1655,-217;1671,-222|492,-120;477,-146;463,-158;444,-162;440,-174;444,-201;433,-221;440,-250;454,-256;471,-249;498,-169;497,-157;504,-157;501,-136|1428,-112;1425,-107;1421,-110;1417,-150;1409,-174;1402,-177;1355,-150;1360,-133;1370,-124;1365,-119;1353,-122;1324,-111;1318,-113;1326,-121;1306,-125;1294,-144;1296,-150;1284,-149;1271,-138;1257,-142;1243,-163;1238,-161;1235,-166;1239,-171;1234,-173;1230,-164;1209,-197;1167,-207;1142,-225;1141,-218;1134,-244;1142,-263;1134,-256;1138,-265;1133,-261;1157,-316;1157,-333;1150,-342;1166,-350;1180,-351;1199,-340;1237,-339;1242,-330;1261,-322;1313,-315;1343,-326;1352,-345;1360,-349;1378,-329;1379,-336;1368,-353;1382,-344;1381,-356;1396,-361;1406,-380;1436,-388;1450,-379;1449,-384;1463,-390;1500,-374;1503,-357;1529,-316;1536,-281;1531,-261;1509,-235;1507,-224;1497,-223;1488,-204;1464,-190;1454,-150;1446,-142;1439,-145;1436,-138|1273,-84;1240,-93;1235,-102;1244,-101|1061,-59;1054,-69;1083,-78;1146,-88;1157,-84;1108,-65;1105,-69;1086,-68|1523,-43;1515,-42;1516,-48;1508,-55;1502,-55;1501,-50;1498,-55;1483,-57;1502,-63;1520,-55|1522,-32;1507,-27;1524,-38;1528,-48;1531,-45|1324,-4;1305,-9;1322,-22;1337,-22;1320,-28;1330,-41;1337,-35;1379,-54;1387,-73;1376,-84;1391,-81;1426,-93;1434,-90;1433,-82;1447,-76;1460,-81;1479,-101;1507,-106;1472,-74;1470,-67;1479,-66;1476,-61;1460,-55;1446,-39;1383,-17;1363,-23;1355,-34;1344,-28;1341,-12|1229,9;1209,13;1200,6;1188,-28;1195,-35;1194,-54;1204,-55;1203,-29;1210,-26;1215,-46;1227,-45;1222,-53;1232,-53;1215,-19;1233,-6;1209,-14;1200,-5;1202,2;1237,2;1252,14|1061,-31;1034,-7;1038,1;1017,21;1006,21;975,52;953,55;986,18;1026,-42;1047,-59;1058,-59|1173,32;1192,54;1167,69;1130,31;1114,27;1112,19;1097,20;1091,13;1091,-5;1101,-16;1102,-29;1117,-30;1121,-35;1133,-31;1149,-41;1160,-37;1161,-40;1166,-15;1175,-8;1178,8;1190,9;1179,18|1262,93;1254,98;1255,90;1238,82;1235,87;1219,72;1236,78;1242,74;1242,62;1254,56;1254,68;1258,73;1262,63;1265,72;1264,84|818,75;801,98;799,68;803,60;812,62|1197,106;1195,114;1172,84;1185,93|1207,185;1203,160;1199,164;1201,150;1210,145;1206,139;1220,138;1227,132;1229,136;1241,125;1240,138;1217,143;1217,159;1225,171;1222,185;1213,185|-734,196;-723,187;-744,187;-739,180;-724,182;-714,176;-707,184;-687,182;-683,186;-700,196;-726,199|1108,201;1086,194;1087,185;1095,182;1103,187|-823,232;-850,219;-818,226;-822,224;-818,222;-787,216;-781,207;-771,204;-778,199;-742,203;-797,228|1220,250;1215,253;1201,236;1207,220;1212,228|126,381;124,376;151,366;155,382|1419,400;1414,414;1403,412;1394,382;1374,368;1367,373;1357,355;1326,354;1294,333;1304,323;1302,314;1307,310;1313,315;1320,331;1310,339;1351,346;1351,338;1358,335;1372,346;1403,351;1410,371|1420,456;1414,434;1403,433;1398,426;1400,416;1411,416;1416,427;1432,420;1441,430;1455,433;1453,444;1439,442|-1258,503;-1284,508;-1281,500;-1257,488;-1235,485|-554,516;-559,516;-574,507;-592,485;-588,483;-593,476;-563,476;-553,474;-560,469;-554,469;-542,478;-542,468;-531,467;-526,475;-531,487;-538,485;-535,492;-558,496;-555,499;-561,502;-568,498;-561,507|-1332,542;-1331,534;-1312,522;-1320,530;-1317,541;-1327,540|1427,544;1422,542;1426,538;1417,533;1416,519;1422,510;1421,460;1427,467;1435,461;1435,468;1426,479;1432,493;1447,490;1436,507|-57,546;-67,552;-97,539;-92,529;-100,518;-68,523|-50,586;-61,568;-56,553;-50,558;-48,548;-29,540;-31,534;-46,535;-48,528;-42,523;-53,520;-34,514;-58,502;-52,500;14,513;11,518;17,527;5,529;-21,559;-31,560;-20,577;-41,576;-30,586|-859,657;-864,640;-872,635;-859,636;-855,631;-831,641;-810,634;-801,637;-852,657|-191,663;-206,657;-221,664;-237,663;-243,656;-222,654;-240,649;-218,644;-228,640;-187,635;-136,651;-147,658;-145,665|-1749,672;-1800,690;-1800,650;-1794,654;-1799,659;-1787,661;-1789,657;-1784,654;-1762,654;-1730,643;-1725,654;-1699,660;-1719,669;-1746,671;-1743,663;-1750,666|-982,701;-998,694;-963,688;-956,691|-924,697;-915,702;-929,713;-952,719;-964,712;-965,701;-942,691;-947,681;-955,681;-961,673;-961,682;-977,686;-986,684;-984,678;-1015,676;-1062,688;-1082,687;-1088,683;-1078,679;-1089,674;-1099,680;-1153,679;-1139,684;-1152,689;-1215,698;-1243,694;-1244,702;-1258,695;-1281,705;-1291,698;-1298,702;-1365,689;-1436,702;-1543,707;-1566,714;-1619,703;-1632,694;-1662,689;-1668,684;-1617,661;-1638,661;-1637,666;-1645,666;-1681,657;-1650,644;-1608,648;-1615,644;-1608,638;-1646,631;-1661,615;-1638,598;-1619,596;-1620,587;-1604,591;-1591,584;-1570,589;-1577,576;-1648,544;-1584,560;-1542,581;-1533,589;-1540,594;-1506,613;-1503,610;-1514,607;-1517,592;-1480,600;-1482,607;-1471,609;-1399,595;-1366,582;-1341,581;-1320,555;-1293,536;-1291,528;-1279,523;-1274,508;-1228,490;-1226,471;-1231,480;-1247,482;-1239,455;-1245,428;-1244,403;-1206,346;-1185,340;-1173,330;-1155,296;-1142,286;-1151,277;-1123,260;-1122,247;-1100,228;-1094,234;-1107,243;-1116,267;-1147,302;-1148,318;-1139,316;-1131,312;-1122,290;-1093,264;-1093,256;-1060,228;-1053,214;-1055,199;-1035,183;-966,157;-947,162;-912,139;-875,133;-877,129;-857,111;-857,99;-851,96;-850,101;-835,84;-811,78;-809,72;-800,75;-805,81;-796,89;-782,83;-771,38;-784,26;-789,14;-801,8;-809,-11;-810,-22;-798,-27;-814,-47;-809,-57;-812,-61;-798,-72;-760,-146;-715,-174;-704,-183;-702,-198;-709,-276;-715,-289;-714,-324;-732,-371;-736,-372;-732,-393;-743,-432;-737,-434;-734,-421;-727,-424;-732,-445;-744,-441;-747,-458;-756,-466;-741,-469;-756,-487;-749,-523;-710,-538;-708,-529;-682,-523;-691,-507;-660,-481;-656,-472;-676,-463;-673,-456;-656,-450;-652,-435;-635,-426;-638,-420;-650,-421;-651,-411;-627,-410;-621,-407;-623,-388;-592,-387;-577,-382;-568,-369;-572,-353;-585,-344;-584,-339;-562,-349;-538,-344;-489,-287;-485,-259;-476,-249;-446,-234;-420,-230;-409,-219;-393,-179;-387,-131;-351,-90;-347,-73;-356,-51;-372,-48;-400,-29;-434,-24;-446,-27;-449,-16;-478,-6;-486,-12;-486,-2;-504,-1;-507,2;-500,17;-505,19;-513,42;-540,58;-571,60;-591,80;-607,86;-608,94;-624,99;-627,104;-619,107;-643,106;-649,101;-662,106;-682,106;-699,122;-702,114;-714,110;-710,99;-717,91;-719,114;-711,121;-718,124;-734,112;-749,111;-757,94;-768,86;-796,96;-814,88;-822,90;-838,111;-834,153;-850,160;-889,159;-884,165;-883,185;-878,183;-868,208;-871,215;-903,210;-908,193;-920,187;-944,181;-963,193;-979,224;-971,259;-974,274;-966,283;-938,297;-902,291;-892,293;-896,302;-892,303;-864,304;-851,296;-841,301;-829,291;-829,279;-817,259;-812,252;-804,252;-801,269;-813,300;-813,314;-757,356;-763,379;-770,382;-763,381;-763,392;-757,379;-759,372;-751,384;-755,395;-749,389;-740,408;-719,409;-737,409;-700,416;-708,423;-707,430;-670,448;-671,451;-644,453;-662,445;-661,436;-654,435;-598,459;-605,470;-615,459;-645,462;-651,481;-642,487;-651,492;-687,483;-711,468;-664,502;-600,502;-557,521;-558,533;-569,538;-573,546;-618,563;-614,570;-646,603;-662,588;-676,582;-693,590;-696,611;-714,611;-738,624;-781,623;-773,599;-785,588;-773,581;-765,565;-782,551;-798,547;-786,526;-799,512;-821,533;-823,551;-850,553;-909,573;-923,571;-932,588;-947,589;-942,609;-932,620;-908,630;-907,636;-899,640;-873,648;-858,666;-833,664;-814,671;-813,676;-820,681;-813,692;-826,697;-855,699;-856,688;-874,672;-883,679;-880,686;-892,693;-906,685;-905,695|-1179,727;-1194,716;-1161,713;-1184,709;-1179,705;-1124,704;-1173,700;-1161,692;-1133,685;-1060,692;-1024,688;-1021,691;-1027,695;-1011,696;-1010,700;-1045,710;-1054,727;-1065,731;-1084,731;-1077,721;-1082,717;-1099,730;-1111,725;-1124,730;-1147,727;-1142,731|-781,737;-804,738;-809,733;-795,727;-763,731|-858,738;-884,735;-902,722;-899,712;-885,712;-895,708;-887,704;-813,697;-790,702;-762,691;-769,689;-729,677;-727,673;-743,658;-740,655;-779,653;-786,646;-777,642;-748,647;-710,629;-662,619;-688,637;-650,627;-647,634;-653,644;-681,657;-680,663;-667,664;-639,650;-619,669;-688,687;-670,692;-679,701;-722,716;-741,713;-742,718;-778,727;-807,721;-806,727;-823,738;-849,733;-858,725;-866,732|-1015,734;-1004,727;-1025,725;-993,714;-967,717;-965,726;-981,730;-971,735;-974,738;-1004,738|-905,739;-945,741;-960,734;-954,721;-943,720;-932,728|-1192,725;-1155,735;-1176,742;-1249,743;-1239,737;-1259,719;-1231,709;-1205,714|1388,761;1375,759;1370,753;1390,746;1443,748;1451,756|-1026,763;-1025,756;-982,750;-977,763;-985,767|-1096,768;-1105,764;-1091,755;-1154,765;-1177,752;-1118,752;-1139,747;-1137,744;-1063,750;-1057,755;-1059,760;-1082,762|556,715;554,724;585,743;689,765;682,769;612,763;556,751;559,746;535,737;544,736;524,728;525,722;515,720;516,715;537,708;575,707|-967,772;-971,768;-939,763;-929,759;-924,748;-882,744;-798,749;-811,757;-892,756;-910,761;-907,764;-916,768;-947,771|-1191,775;-1229,761;-1171,765;-1163,769;-1162,776|1047,771;1061,774;1044,777;1020,773;1008,764;872,751;860,745;868,739;805,736;806,726;815,718;776,723;759,719;764,712;753,713;757,723;747,728;749,721;731,714;744,706;736,696;738,691;749,690;745,683;751,678;724,662;713,663;737,684;726,690;728,704;718,714;728,722;726,728;692,728;685,719;667,710;673,699;669,695;692,686;685,681;606,699;600,695;611,689;599,683;588,689;535,682;545,688;537,689;463,667;456,670;456,676;468,677;463,683;435,686;442,680;437,674;445,668;439,661;421,665;398,655;404,648;396,645;372,651;365,648;370,638;349,644;348,659;332,666;384,660;400,663;411,668;403,679;321,699;311,696;300,702;313,705;282,712;245,710;230,702;192,698;148,678;105,645;50,620;57,586;70,581;84,583;104,595;129,554;141,554;147,562;159,561;168,587;179,590;188,601;171,613;178,627;214,644;212,650;222,657;239,660;254,651;215,632;211,626;215,617;213,607;229,598;281,605;291,600;280,595;233,592;234,586;244,584;241,570;233,570;225,578;216,574;211,568;213,552;197,544;176,549;141,538;125,545;109,540;99,546;97,555;109,565;103,569;106,577;85,571;81,555;88,540;81,535;47,531;38,516;16,509;13,501;-10,493;-19,498;-16,486;-46,487;-45,480;-30,476;-12,460;-14,440;-19,434;-80,437;-94,430;-88,408;-95,387;-88,383;-89,369;-65,369;-54,359;-44,367;-21,367;1,387;-3,393;8,410;30,419;31,431;65,431;89,444;102,439;105,429;121,417;154,400;161,390;157,379;161,380;171,389;172,394;164,398;169,404;183,398;185,402;159,415;159,420;151,420;126,441;123,454;131,457;139,456;140,448;149,451;160,435;195,417;194,403;211,383;217,368;225,364;232,364;228,373;234,374;231,379;240,377;226,403;239,400;244,401;237,407;249,409;261,408;264,402;276,410;288,411;277,426;288,449;296,450;307,466;333,461;336,459;325,453;335,450;333,446;339,444;363,451;365,455;350,457;350,463;391,473;377,466;382,462;367,452;415,426;417,420;404,410;383,409;352,420;335,420;311,411;292,412;288,405;273,404;262,395;268,390;263,382;276,367;297,361;317,366;325,361;347,368;362,367;360,346;346,315;338,310;320,309;310,316;289,309;215,328;201,322;201,310;191,303;157,314;152,323;103,338;109,357;106,364;111,369;102,367;102,372;95,374;15,366;-22,352;-59,358;-69,341;-93,326;-98,312;-96,299;-144,263;-170,219;-161,181;-165,161;-176,147;-167,136;-166,122;-148,109;-124,73;-90,48;-75,43;-46,52;-20,47;19,61;43,63;59,43;85,48;94,37;98,31;88,-11;119,-50;137,-107;136,-120;118,-158;118,-181;143,-221;152,-271;182,-317;179,-326;184,-341;196,-348;226,-339;258,-339;282,-328;322,-288;329,-262;326,-257;356,-237;348,-198;374,-176;395,-167;408,-147;405,-108;392,-85;394,-68;388,-65;392,-47;403,-26;477,42;510,106;511,120;446,104;427,117;433,124;393,159;384,180;375,186;369,220;355,231;357,239;324,299;339,276;349,295;346,281;351,281;375,243;385,237;391,213;426,168;426,152;435,126;487,140;522,156;524,164;553,172;577,189;578,202;598,223;587,236;568,242;564,264;540,241;518,240;516,258;510,260;508,248;502,267;488,277;480,300;501,301;515,279;547,265;565,271;574,257;615,251;664,254;674,239;693,228;696,225;692,221;705,209;726,214;735,160;766,89;775,80;799,104;803,159;822,166;851,195;865,202;870,215;903,218;905,228;914,228;943,182;942,160;954,157;972,169;988,114;983,78;985,84;1001,65;1014,28;1035,12;1042,13;1030,55;1005,74;999,92;992,92;1001,134;1010,134;1008,126;1026,122;1035,106;1051,99;1052,86;1092,117;1093,134;1089,153;1057,191;1059,198;1085,217;1099,214;1099,203;1104,203;1108,214;1159,228;1187,245;1211,281;1217,282;1221,298;1213,307;1219,309;1219,317;1202,344;1192,349;1211,367;1225,369;1224,375;1208,379;1197,372;1189,374;1175,387;1180,392;1190,393;1216,409;1222,404;1211,389;1243,399;1253,396;1247,381;1262,377;1269,369;1261,367;1265,344;1291,351;1295,368;1274,392;1275,398;1297,409;1300,419;1323,433;1335,428;1349,434;1382,463;1401,484;1406,512;1414,522;1413,531;1399,542;1382,538;1367,546;1351,547;1422,590;1485,592;1498,597;1513,595;1513,588;1550,591;1542,598;1567,614;1593,618;1601,605;1627,616;1633,625;1645,626;1637,611;1584,581;1568,578;1559,568;1554,554;1568,510;1582,519;1585,530;1600,532;1604,543;1621,549;1617,553;1621,561;1631,562;1632,576;1620,582;1635,599;1658,602;1663,598;1689,606;1703,599;1737,617;1795,626;1774,646;1800,650;1800,690;1786,694;1705,701;1700,697;1708,690;1696,687;1678,696;1609,694;1597,697;1598,705;1590,709;1530,708;1495,722;1405,728;1391,724;1399,715;1339,714;1323,718;1313,708;1285,720;1291,724;1286,730;1270,736;1233,737;1232,730;1156,738;1135,733;1130,740;1094,742;1139,753;1141,758;1111,767;1072,765;1070,770|229,785;208,783;214,779;207,777;247,779|-1055,793;-1042,787;-1052,784;-997,779;-1001,783|1054,787;1021,793;994,779;1051,783|170,801;104,797;112,789;147,777;138,774;159,768;171,768;190,786;215,790;183,797|174,803;230,794;274,801;254,804|500,809;448,806;471,806;465,802;476,800;511,805|1002,798;959,813;912,803;950,790;999,789|-878,803;-924,813;-947,812;-943,810;-967,802;-950,794;-931,794;-940,788;-929,783;-908,782;-858,793;-870,797|-793,831;-824,829;-832,823;-855,827;-916,819;-876,805;-818,805;-869,803;-851,793;-880,784;-850,775;-883,779;-878,772;-896,770;-895,765;-806,762;-779,768;-798,772;-754,785;-762,790;-755,792;-769,793;-712,798;-655,815;-677,815;-619,824;-685,831|-434,832;-468,826;-469,822;-445,817;-504,824;-530,819;-572,822;-627,818;-622,813;-680,801;-653,798;-657,794;-732,784;-733,780;-668,774;-714,770;-685,761;-613,761;-586,755;-547,726;-558,717;-514,706;-544,708;-547,696;-535,693;-509,699;-515,687;-530,684;-540,672;-533,668;-537,661;-523,652;-516,636;-483,609;-434,601;-424,619;-428,627;-412,635;-398,655;-342,667;-318,681;-277,685;-223,701;-264,702;-252,708;-255,714;-235,705;-218,707;-221,715;-248,723;-223,722;-236,733;-208,735;-204,738;-216,742;-194,743;-207,752;-196,752;-198,761;-217,766;-185,770;-197,776;-197,788;-177,801;-200,802;-122,813;-158,819;-232,812;-221,817;-229,821;-314,820;-208,827;-271,835"
}

/// Three short dashes; the active one is longer and darker (which phase of the search we're in).
struct StepDashes: View {
    let active: Int
    var body: some View {
        HStack(spacing: Theme.Spacing.inline) {
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

/// "How do you measure?" Asked right after the country, preselected to that country's usual system.
/// The answer is saved to the profile (Profile → Units) and every recipe, step and list follows it.
struct UnitsStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selected: UnitSystem { state.units() }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "how do you measure?"),
            subtitle: String(localized: "every recipe, step and grocery list will use it"),
            onContinue: {
                state.unitSystem = selected
                onContinue()
            }
        ) {
            VStack(spacing: Theme.Spacing.l) {
                VStack(spacing: Theme.Spacing.m) {
                    OptionTile(title: String(localized: "Metric"), subtitle: String(localized: "grams, millilitres, °C"), emoji: "⚖️", isSelected: selected == .metric) {
                        state.unitSystem = .metric
                    }
                    OptionTile(title: String(localized: "Imperial"), subtitle: String(localized: "ounces, cups, °F"), emoji: "🥄", isSelected: selected == .imperial) {
                        state.unitSystem = .imperial
                    }
                }
                preview
            }
        }
    }

    /// The same three recipe lines, rewritten live in the chosen system.
    private var preview: some View {
        Card {
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                Text("YOUR RECIPES WILL READ")
                    .font(Theme.Typography.eyebrow)
                    .tracking(1.2)
                    .foregroundStyle(Theme.tomatoDeep)
                previewLine("•", String(localized: "\(QuantityFormatter.mass(grams: 400, system: selected)) chicken thighs"))
                previewLine("1", StepTextFormatter.string(String(localized: "Heat the oven to 200°C (400°F)."), system: selected))
                previewLine("2", StepTextFormatter.string(String(localized: "Pour 350 ml boiling water over the couscous."), system: selected))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(reduceMotion ? nil : Theme.Motion.update, value: selected)
        }
    }

    private func previewLine(_ marker: String, _ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.s) {
            Text(marker)
                .font(Theme.Typography.subheadline.weight(.bold))
                .foregroundStyle(Theme.tomato)
                .frame(width: 14)
            Text(text)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.aubergine)
                .contentTransition(.interpolate)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
