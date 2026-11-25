# Prompt: create Tommo's identifiers on Apple Developer and App Store Connect

Set up everything Apple needs for my iOS app **Tommo** (Xcode project "Forkcast"). Use **exactly** the identifiers
below: they are hard-coded in the app, so any spelling change breaks it. I will sign in myself; stop and wait at
any login or two-factor screen. Do not change anything that already exists; if an identifier is already registered
to my account, just check its settings match and move on. Never ask me for passwords.

## Part A · developer.apple.com → Certificates, Identifiers & Profiles → Identifiers

Create these in this order (the App ID capabilities point at the first two).

1. **App Group**
   - Description: `Tommo App Group`
   - Identifier: `group.com.tomasbeja.tommo`

2. **iCloud Container**
   - Description: `Tommo iCloud`
   - Identifier: `iCloud.com.tomasbeja.tommo`

3. **App ID (type: App) for the main app**
   - Description: `Tommo`
   - Bundle ID (Explicit): `com.tomasbeja.tommo`
   - Capabilities to enable:
     - **App Groups** → configure → select `group.com.tomasbeja.tommo`
     - **iCloud** (include CloudKit support) → configure → select `iCloud.com.tomasbeja.tommo`
     - **Push Notifications**
     - **Sign in with Apple** → "Enable as a primary App ID"
     - **In-App Purchase** (on by default)

4. **App ID for the home-screen widget**
   - Description: `Tommo Widget`
   - Bundle ID (Explicit): `com.tomasbeja.tommo.widget`
   - Capabilities: **App Groups** → `group.com.tomasbeja.tommo`

5. **App ID for the share extension** ("Share to Tommo" from Safari / Notes)
   - Description: `Tommo Share`
   - Bundle ID (Explicit): `com.tomasbeja.tommo.share`
   - Capabilities: **App Groups** → `group.com.tomasbeja.tommo`

Signing certificates and provisioning profiles: none needed by hand; Xcode's automatic signing creates them.

## Part B · appstoreconnect.apple.com → Apps → "+" → New App

- Platform: **iOS**
- Name: **Tommo** (if that name is taken, use **Tommo: Meal Planner** and tell me)
- Primary language: **English (U.K.)**
- Bundle ID: **com.tomasbeja.tommo** (pick it from the list; it appears after Part A)
- SKU: **tommo-ios**
- User access: Full Access

## Part C · In the new app → Monetization → Subscriptions

1. Create a **subscription group**: Reference name `Tommo Pro` (display name "Tommo Pro").
2. In that group, create two auto-renewable subscriptions:

| Reference name | Product ID (exact) | Duration | Price | Intro offer |
|---|---|---|---|---|
| Tommo Pro Yearly | `com.tomasbeja.tommo.pro.yearly` | 1 year | 39.99 USD price point (let Apple fill other countries) | **Free trial, 3 days**, new subscribers |
| Tommo Pro Monthly | `com.tomasbeja.tommo.pro.monthly` | 1 month | 9.99 USD price point (let Apple fill other countries) | none |

- Put the **yearly** above the monthly in the group's ranking (higher level of service first).
- Subscription display name: "Tommo Pro Yearly" / "Tommo Pro Monthly"; description: "Your full weekly meal plan,
  grocery list and cookbook." (English).
- Leave review screenshots and "Ready to Submit" for me; just create them in "Missing Metadata" state.

## Part D · Report back

List every identifier and product you created or found already existing, with its status, and anything you could
not do (and why). Do not submit anything for review.
