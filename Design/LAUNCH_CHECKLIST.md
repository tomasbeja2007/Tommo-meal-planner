# Tommo launch checklist

Everything outside the code that has to exist before Tommo can go to TestFlight and the App Store.
Identifiers are hard-coded in the app: use them exactly.

## 1. Apple Developer account (developer.apple.com)
- [ ] Apple Developer Program membership active (99 USD / year), and your **Team ID** noted.
- [ ] **App Group** `group.com.tomasbeja.tommo` (app and widget share the plan through it).
- [ ] **iCloud container** `iCloud.com.tomasbeja.tommo` (CloudKit sync of plans, recipes, ratings).
- [ ] **App ID** `com.tomasbeja.tommo` with: App Groups, iCloud + CloudKit, Push Notifications, Sign in with Apple
      (primary), In-App Purchase.
- [ ] **App ID** `com.tomasbeja.tommo.widget` with: App Groups.
- [ ] Nothing for the old share extension (removed). Delete `com.tomasbeja.tommo.share` if you made it.
- [ ] Certificates and provisioning profiles: none by hand; Xcode automatic signing makes them.
- [ ] No APNs key needed: the app only uses local reminders and CloudKit's own sync pushes.

## 2. App Store Connect (appstoreconnect.apple.com)
- [ ] **Agreements, Tax and Banking**: sign the **Paid Apps** agreement, add bank and tax details
      (subscriptions don't load in TestFlight or the App Store without it).
- [ ] **New app**: name "Tommo" (fallback "Tommo: Meal Planner"), bundle ID `com.tomasbeja.tommo`, SKU `tommo-ios`,
      primary language English (U.K.).
- [ ] **Subscription group** "Tommo Pro" with:
  - [ ] `com.tomasbeja.tommo.pro.yearly`, 1 year, 39.99 USD point, 3-day free trial for new subscribers.
  - [ ] `com.tomasbeja.tommo.pro.monthly`, 1 month, 9.99 USD point.
  - [ ] Each needs a display name, a description, and a **review screenshot of the paywall** before submission.
- [ ] **App Privacy** questionnaire: the app sends no data to your own servers and has no analytics or tracking.
      Name and email from Sign in with Apple stay on the device and in the user's own iCloud.
      → most likely **"Data Not Collected"**, matching `PrivacyInfo.xcprivacy`. Confirm before answering.
- [ ] **Age rating** questionnaire (no objectionable content → 4+).
- [ ] **App Information**: category Food & Drink (secondary: Health & Fitness or Lifestyle).
- [ ] **Pricing and availability**: free download (Pro is the subscription), countries.
- [ ] **TestFlight**: add yourself as internal tester; add the "What to test" note.

## 3. Things only you can make (the app links to them)
- [ ] **Privacy Policy page**: a public URL. The app currently opens `https://forkcast.app/privacy` → replace.
- [ ] **Terms of Use page**: a public URL. The app currently opens `https://forkcast.app/terms` → replace.
      (Apple's standard EULA is fine; then link to it: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/)
- [ ] **Support email**: the app's "Contact us" writes to `hello@forkcast.app` → replace with your inbox.
- [ ] **Support URL** (required by App Store Connect): any page with a way to contact you.
- [ ] **Marketing URL** (optional).
→ Send me the three URLs and the email; I'll put them in `Forkcast/App/FeatureFlags.swift` (AppLinks).

## 4. iCloud / CloudKit (icloud.developer.apple.com)
- [ ] Run the app once with iCloud signed in (Simulator or device) so the schema is created in Development.
- [ ] CloudKit Console → `iCloud.com.tomasbeja.tommo` → **Deploy Schema Changes to Production**.
      Without this, sync fails for TestFlight and App Store users.
- [ ] Re-deploy whenever a SwiftData model gains a new field.

## 5. Xcode before the first archive
- [ ] Signing & Capabilities → pick your **Team** for **Forkcast** and **ForkcastWidget**.
- [ ] Delete the **ForkcastShare** target (Project → Targets → ForkcastShare → "−").
- [ ] Version 1.0, build 1 (raise the build number for every upload).
- [ ] App icon present (done), encryption declared (done: no non-exempt encryption), privacy manifest (done).
- [ ] Product → Archive (device: Any iOS Device) → Distribute → App Store Connect → Upload.

## 6. App Store listing (for review, not needed for TestFlight)
- [ ] Screenshots: 6.9" iPhone (1320×2868 or 1290×2796) at minimum; 3 to 10 of them.
- [ ] App name, subtitle (30 characters), description, keywords (100 characters), promotional text.
- [ ] Review notes: "No login needed. Pro is a subscription with a 3-day free trial; use a sandbox account.
      Sign in with Apple is optional." No demo account needed.
- [ ] Copyright line ("2026 Tomás Beja").

## 7. Not needed (so you don't go looking)
- No backend, database, API keys or third-party services; no analytics or ads SDKs.
- No push server, no APNs key, no Firebase.
- No location or camera permissions (photos use the system picker; the globe uses the phone's region).
- Supermarket logos: only if/when you get permission (`store-<id>` assets).
