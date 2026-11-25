# MOTION.md: living illustrations in this project

> Copy this file next to the project's art (for example `src/art/MOTION.md`) and fill in **Part 2** as you learn the project. Part 1 is the method and stays as it is. The `rossark-motion-skill` reads this file first, and Part 2 overrides the skill's defaults.

---

## Part 1. The method

**The goal:** anything drawn (a character, a plant, a flame, a street, a logo, a chart) feels alive and calm. Nothing teleports, nothing bounces, nothing shouts.

### Principles
1. **Never teleport:** interpolate everything; never swap drawings.
2. **Calm by default:** strong curves, no bouncy overshoot.
3. **Small amplitudes:** when unsure, halve it.
4. **Arcs and pivots:** each moving part is a layer rotating around its joint (stem base, hinge, neck, hook).
5. **Overlap and follow-through:** tips and trailing parts move later and further; give each part the same wave with a growing phase delay.
6. **Variety without chaos:**
   - repeated items get a seeded phase, speed and size;
   - nothing moves in sync, and there's no random value per frame.
7. **One main action per scene, plus two or three idle loops.** Side things stay quiet.
8. **Opacity only to appear or disappear.**
9. **The layout never moves:** motion lives inside the drawing.
10. **Reduced motion:** loops freeze on a good frame 0, and one-shots show their final frame.
11. **Nothing runs unseen:** pause off screen, when hidden and in the background.
12. **Enough frames:** anything under ~100 ms flickers at 30 fps; render and export at 60 when you can. Blinks close in ~110 ms and reopen in ~190 ms.
13. **Interface rules:**
    - frequency decides how much (often seen = barely moves; rare moments get the delight);
    - every motion has a purpose;
    - shared elements travel, never teleport;
    - interface moves stay under 300 ms;
    - exits are faster than entrances;
    - nothing appears from scale 0;
    - interruptions continue from the current value.

### The engine
- **Clocks:** a loop clock for idle life, a one-shot clock for a scene that tells an action. One per character, group or scene.
- **Tracks:** keyframes `[ms, value, 'out'?]` read with `track(t, keys)`. The last key equals the first. `track` stops at every key, so use it for one move (a blink, a lid). For acting (a chain of poses), use `flow(t, keys)`, which passes through the keys without stopping and never overshoots.
- **Helpers:**
  - `wave` (−1 to 1), for sway and breathing;
  - `loop` (0 to 1), for drift and falling;
  - `bell`, to fade in and out;
  - `seg`, for one beat of a one-shot;
  - `seeded(i)`, for per-item variety.
- **Curves:**
  - travel uses ease-in-out `(0.77, 0, 0.175, 1)`;
  - open and arrive use ease-out `(0.23, 1, 0.32, 1)`;
  - leaving uses ease-in;
  - endless loops are linear.

### Quick recipes
| Subject | Recipe |
|---|---|
| Character | breathing 1–2 units over 3–5 s; a blink every 3–4 s; pupils glide; head tilt 3–6° |
| Waiting to be tapped | a jiggle every ~270 ms: squash 2%, widen 2%, the bulge trading sides |
| Floating figure | rises in from 30% of its height below, drifts 5% down and up, leaves rising |
| Tail, hair, ears | rotation around the root, phase delayed along the chain, 4–10° |
| Plant | sway 1.5–4° around the base over 3–6 s; leaves on seeded phases |
| Cloth, flag | a wave that travels along the length, growing away from the fixed edge |
| Fire | a lean of 2–4° and a 3–6% stretch on two waves of different periods |
| Smoke, steam | rises 8–14 units and fades in and out with `bell` |
| Water | ripples grow and fade; floating things bob 1–2 units and rock 2° |
| Rain, snow | seeded `loop`s; snow sways sideways |
| Sky | clouds drift over 20–60 s with parallax; sun rays take 30–60 s per turn |
| Lights | a glow of 2–5% over 2–4 s; stars twinkle at seeded times |
| Machines | gears turn linearly by ratio; a clock hand steps with ease-out |
| Phone | ±3° bursts, then a pause |
| Icon, logo | plays once on appear, then rests |
| Chart | a one-shot draw-on, with bars staggered 40–80 ms |

### Acting (a whole character)
- **Every channel:** key pose (`flow`) + idle (`wave`s, never off while on stage) + follow-through (the parent read 90–140 ms earlier) + accents (a `wave` inside a `seg` window).
- **Arms:** an upper arm and a forearm share a round elbow; the forearm points at shoulder angle + elbow bend.
- **Head turns:** slide the face toward the turn (eyes 10, nose 13 in a 100-wide head) and the ears the other way. Blink on the turn.
- **Weight:** the hips shift and carry the upper body, and the legs angle to keep the feet under it.
- **Landing:** hover, then fall with gravity and stretch; squash hard (0.8) on contact and keep the volume (`width = 1 / height^0.6`).
- **In the air:** limp feet (toes down, one knee folded, trading slowly). The shadow stays on the floor and scales with the height.
- **Props:** enter from off screen already moving and roll by distance / radius. The eyes follow them. A kick hits at the middle of the swing; the prop leaves as a throw, spinning, with a short squash.
- **Asymmetry:** the arms never mirror each other.
- **Camera:** a view from a little above is a whole build, not a tweak: the head is 40–50% of the height, the torso is short and narrower than the head, the legs are short, the feet are round from above, and the shadow is a wide oval with the feet in its lower half. Keep it in one `build` object. A flat view keeps a thin pill shadow.
- **Framing:** on a phone, as big as the screen allows, with the feet low.

### From a reference video
- Contact sheets at the full frame rate (`tools/sheet.sh`).
- Measure motion with numbers (`tools/track_edges.py`): a 2% jiggle or a 5% float doesn't show to the eye.
- Sample colors from pixels (`tools/sample_colors.py`).
- Go part by part: feet, shadow, hands, head.
- Compare proportions as ratios of one unit (head widths). "Stretched" means a ratio is far off.
- Compare your render with the reference at the same moments.
- Don't publish a copy of someone else's art.

### Performance
- Everything is a function of one clock's time.
- Draw many items in one SVG or `Canvas`.
- Reset repeating animations to 0 before starting, and cancel them on cleanup.
- Declare curves at the top of the module.

### Workflow
1. Read Part 2 and the art file's header comments.
2. List what could live in the drawing.
3. Pick one main action and two or three idle loops.
4. Split the art into layers at their pivots.
5. Put the numbers in tokens.
6. Check frame 0, the final frames and the loop seams. For a character, look at a contact sheet of every 4th frame of your own render.
7. Run the checks.
8. Hand off: what moves, and what hasn't been seen on a real device.

---

## Part 2. This project

### Where the code is
- **Platform:** SwiftUI, iOS 17+ (Swift 5 mode). No React Native code in this repo: never use the skill's `templates/react-native/`.
- **Motion engine:** `Forkcast/Theme/Motion/Motion.swift` (copied from the skill's `templates/swiftui/Motion.swift`): `LoopClock`, `OneShotClock`, `track`, `flow`, `seg`, `wave`, `loop`, `bell`, `seeded`, and `Animation.travel(_:)` / `Animation.open(_:)`.
- **Live face:** not used yet (`templates/swiftui/LiveFace.swift`). It needs art with eyes drawn as plain whites (see Rig limits).
- **The mascot:** `Forkcast/Theme/Components/MascotView.swift`, the ONLY place the mascot art is referenced.
  Every number lives in `enum MascotMotion` at the top of the file. Moods: `.idle`, `.cheer`, `.thinking`.
  Coordinates: fractions of the mascot's size; pivot = bottom centre (the feet). One `LoopClock` (12 s) per mascot.
- **Art:** `Forkcast/Resources/Assets.xcassets/Mascot.imageset` (source `Design/mascot-tomato-chef.png`).
  Mood art: `MascotIdle`, `MascotCheer`, `MascotThinking`, `MascotBell` (moods `.idle`, `.cheer`, `.thinking`, `.bell`).
  `LaunchMascot` is `MascotIdle` resized to 200 pt for the launch screen (same size and spot as the splash mascot).
- **Onboarding motion:** `WelcomeStep` (one continuous intro out of the launch screen: Chef Tomato is drawn at the
  launch size, rests 160 ms, then glides on the travel curve from the window centre into the hero and settles with a
  small volume-keeping squash; the scene is a still life on one floor: a soft tomato "sun" behind
  Chef Tomato and a shared floor shadow grow in as he lands; six ingredients (two behind, two front corners, two
  small accents at his feet) settle onto the floor from 14 pt above, staggered 70 ms, each with a contact shadow;
  title, subtitle and buttons rise 14 pt in with ease-out at 0.62 / 0.72 / 0.86 s; light haptic on landing.
  Idle: nothing floats. Pieces only rock around their base (0.8–1.4°, basil 3°), the sun glows 1.5% over 6 s.
  Plays once per launch. Numbers in `enum WelcomeIntro`), `ConfettiView` (one `Canvas`, one
  `OneShotClock`, seeded pieces, gravity, empty last frame so Reduce Motion shows none; numbers in `ConfettiMotion`),
  the reminder bell (`StayOnTrackStep`: a one-shot swing around its top), the mirror's typed text (`OneShotClock`),
  `OptionTile`'s icon bounce (keyframes, off with Reduce Motion), the dislike strike-through and the vibe grid shake.
- **Welcome home (end of onboarding):** `HeroDishCelebration` leads with the week's first dinner. One `OneShotClock`
  (1.1 s: dish rises 18 pt from 0.92, ingredients open out staggered 55 ms, herb check pops last) wrapping one
  `LoopClock` (9.6 s: dish breathing ±1.2% and sway 1.6° around its base, ingredients bob and rock on seeded phases).
  Every idle period divides 9.6 s so the seam never jumps. Numbers in `enum HeroMotion`.
- **Onboarding step change:** a 32 pt glide + fade in (ease-out 0.28 s), 20 pt + fade out (ease-in 0.16 s).
- **Plan day strip:** one tomato pill travels between days (`matchedGeometryEffect`, `Theme.spring`), selection haptic.
- **Grocery check:** fill opens from 70%, the tick draws on with ease-out; unchecking is quicker.
- **Mirror typing:** every letter is always laid out (unwritten ones transparent) so words never jump lines;
  letters fade in over a 6-letter soft edge; max 1.6 s.
- **Savings:** one 1.9 s timeline; 52 week squares (13 across) fill from 60% scale, 14 ms apart, with the count-up.
- **Catalog ("N recipes fit you"):** two rows of the user's matching dishes drift in opposite directions
  (linear, 60 s loop, edge-faded); three stat tiles count up with ease-out, 80 ms apart.
- **Plan reveal:** day cards deal in (rise 18 pt + fade, 70 ms apart); budget bar draws on; basket counts up.
- **Other motion:** `ProgressBar` / `ProgressRing` (one-shot draw-on with ease-out, staggered macro bars in `MacrosCard`),
  `MoneyText` (count-up with ease-out), `PrimaryButtonStyle` (0.97 press scale + light haptic), the sparkle field inside `MascotView`.

### The owner's rules
- From the product brief (Nov 2026): "Motion: springy but quick (`.spring(response: 0.35, dampingFraction: 0.8)`).
  Count-up animation on money numbers. Use `.contentTransition(.numericText())` for changing numbers. Respect Reduce Motion."
  → Interface transitions keep `Theme.spring` (this overrides the skill's "no bounce" default for UI chrome only).
  Drawings (the mascot, sparkles) and draw-ons follow the skill: timed curves, no spring overshoot.
- "Haptics: selection on chip taps, success on plan generated, trial started, and all groceries checked."
- The mascot appears only on: welcome, building-your-week, plan reveal, empty states, trial reminder, weekly feedback,
  cook-mode finish, savings moment, "shop done". "Keep it special": no mascot on everyday screens.
- Onboarding brief (Nov 2026) widens that for onboarding only: a 48 pt `MascotReaction` in the top-right of some
  question screens (obstacles, household, budget), the mirror, stay on track, trial (`.bell` mood) and welcome home.
  A mood change swaps in with a quick spring. Still never on the main tabs' everyday screens.
- The old splash (mascot ring, then a hard swap to the welcome layout) was replaced by the continuous intro above,
  because the swap made the mascot jump. The splash-* ingredient pieces are no longer used.
- Light mode only; never green as a brand colour (herb green only for success and checkmarks).

### Rig limits
- The mascot is ONE flat raster image: eyes, mouth and arms are baked in, there is no head layer, and the
  current art includes a soft baked ground shadow and a near-cream rounded-square background.
  So: no blinks, gaze, mouth or arm acting. Life comes from breathing (with volume kept), sway and tilt around
  the feet, weight drift, a hop with squash-and-stretch, and a separate floor shadow that scales with height.
- To unlock the live face, the art needs layers: body, head (with eyes as plain whites, no pupils), arms, spoon,
  on a transparent background with no baked shadow. Request this from Grok as "MascotRig" before building `LiveFace`.

### How changes are checked
- No Mac on the authoring side: SwiftUI can't be built there. Pose maths are checked by porting them to Python
  (frame 0 neutral, loop seams close, no per-frame jumps). Visual checks happen on the Mac in the Simulator / device.
- `cd Packages/ForkcastCore && swift test` for the core (motion code lives in the app, not the package).
- Check with Reduce Motion ON (Settings → Accessibility → Motion): every mascot must sit still on a good frame,
  bars and counters must show their final values immediately.
