# Planck (Personal Edition)

An educational quantum physics app designed with an engaging, TikTok-like interface.

**Note:** This project has pivoted to a **personal-use only** application for the developer and family. It is designed to be zero-cost, privacy-focused, and run entirely offline with pre-generated content.

## Features
- **TikTok-Style Content Feed:** Fluid, vertical, full-screen pagination.
- **Offline "Build-Time AI":** Content is pre-generated and bundled with the app. No API keys, no cloud, no monthly costs.
- **Generative Quantum Art:** Procedural backgrounds (wave forms, orbital rings) unique to every card.
- **Mini-games:** "Proof of Observation" challenges (Math, Word Match, etc.) to unlock facts.
- **Cross-Platform:** Runs on iOS (via local provisioning) and Android (via APK).

## Deployment Strategy
Since this is a free, personal project:
- **Android (Samsung S22):** Build `app-release.apk` and install directly. Works forever.
- **iOS (iPhone):** Build via Xcode with a personal Apple ID.
  *   *Constraint:* Requires re-signing every 7 days (Free Provisioning).
  *   *Alternative:* Use AltStore for automatic re-signing.

## Getting Started

1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. Clone this repository.
3. **Generate Content:** (Optional) Run the content generation scripts (coming in Phase 12) to update `assets/content.json`.
4. Run `flutter run` to launch on your device.

## Project Structure
- `lib/main.dart` — Entry point.
- `lib/data/post_repository.dart` — **Refactoring to JSON-based** (was static list).
- `assets/content.json` — The "Brain" of the app. Contains thousands of pre-generated facts.

## Dependencies
- `provider` — State management
- `visibility_detector` — Card visibility tracking for animations
- `shared_preferences` — Local data persistence (feed cache, IP)

---
## Current Status & Next Steps

### ✅ Phase 11a Complete — Physical Device Deployment
App successfully deployed to a physical iPhone via both **WiFi debugging** and **USB tethering**. Code signing configured with Development Team `QVM56T35B4` and Bundle ID `com.example.planck`. Physical device QA is now active and verified.

**Audio Removal:** All legacy audio services and placeholders (including `audio_service.dart`) have been removed to focus on a visual-first, text-augmented experience.

**Device Details:**
- **Device:** iPhone (iOS 18.5)
- **Status:** Verified via USB and WiFi
- **Deploy Command:** `flutter run -d 00008110-001A34510C31801E`

### 🚀 Phase 11b — App Store Release (Current)
*   **Physical Device QA:** Extensive testing of haptic feedback pacing, animation performance, and scroll responsiveness on the physical iPhone.
*   **Production Branding:** Update `com.example.planck` to a production-ready bundle ID and final app name.
*   **App Icon & Assets:** Generate official app icons and launch screens.
*   **Store Presence:** Prepare screenshots and metadata for the App Store.
*   **Internal Testing:** Upload to TestFlight for final validation.
