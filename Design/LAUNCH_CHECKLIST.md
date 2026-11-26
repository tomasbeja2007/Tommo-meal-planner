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
- [ ] **New app**: name "Tommo" (fallback "Tommo: Meal Planner"), bundle ID `com.tomasbeja.tommo`, SKU `tommo-meal-planner`,
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

## 3. Public links and contact details
- [ ] Verify that the live privacy, terms and support pages open without signing in. [Tommo website](https://tomasbeja2007.github.io/Tommo-meal-planner/)
- [ ] Send a test message to `tomasbeja2007@icloud.com` and verify that the published inbox receives it.
- [ ] Set the Privacy Policy and Support URLs in App Store Connect. Include the Apple standard Terms of Use link in the app metadata when using that licence. [Apple standard EULA](https://www.apple.com/legal/internet-services/itunes/dev/stdeula/)
- [ ] Confirm the developer's public business contact details, trader status and any required address and phone number for EU distribution. [Apple Digital Services Act information](https://developer.apple.com/support/dsa/)

## 4. iCloud / CloudKit (icloud.developer.apple.com)
- [ ] Run the app once with iCloud signed in (Simulator or device) so the schema is created in Development.
- [ ] CloudKit Console → `iCloud.com.tomasbeja.tommo` → **Deploy Schema Changes to Production**.
      Without this, sync fails for TestFlight and App Store users.
- [ ] Re-deploy whenever a SwiftData model gains a new field.

## 5. Xcode before the first archive
- [ ] Use an Xcode and iOS SDK version that App Store Connect currently accepts. [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- [ ] Run `xcodegen generate` and open `Tommo.xcodeproj`. Set the signing team for Tommo and ForkcastWidget.
- [ ] Set an unused build number and archive the Tommo Release scheme for Any iOS Device.
- [ ] Inspect the archive for the iPhone-only device family, app and widget signing, and the bundled app privacy manifest. Validate the new archive in Xcode Organizer.
- [ ] In Sandbox or TestFlight, test monthly and yearly purchase, intro-offer eligibility and billing, Restore, cancellation, and access after renewal or expiry.
- [ ] On two iCloud devices, confirm that deleting data in Profile syncs deletions. If Sign in with Apple is linked, confirm local account data is cleared and confirm Apple's account management instructions work. Review token revocation before submission. [Apple Sign in with Apple deletion guidance](https://developer.apple.com/documentation/technotes/tn3194-handling-account-deletions-and-revoking-tokens-for-sign-in-with-apple)

## 6. App Store listing (for review, not needed for TestFlight)
- [ ] Screenshots: 6.9" iPhone (1320×2868 or 1290×2796) at minimum; 3 to 10 of them.
- [ ] App name, subtitle (30 characters), description, keywords (100 characters), promotional text.
- [ ] Review notes: "No login needed. Pro is a subscription with a 3-day free trial for eligible subscribers. Use a sandbox account.
      Sign in with Apple is optional." No demo account needed.
- [ ] Copyright line ("2026 <your name or company>").

## 7. Not needed (so you don't go looking)
- No backend, database, API keys or third-party services; no analytics or ads SDKs.
- No push server, no APNs key, no Firebase.
- No location or camera permissions (photos use the system picker; the globe uses the phone's region).
- Supermarket logos: only if/when you get permission (`store-<id>` assets).
