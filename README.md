# Planck

An educational quantum physics app designed with an engaging, TikTok-like interface to teach complex topics intuitively.

## Features
- **TikTok-Style Content Feed:** Fluid, vertical, full-screen pagination through 25 daily quantum facts.
- **Generative Quantum Art:** Procedural backgrounds (wave forms, orbital rings, particle fields) unique to every card, driven by `CustomPaint`.
- **Ambient Particles:** Floating particle layer across the entire feed for a deep-space atmosphere.
- **Haptic Interactivity:** Haptic impacts on swipes, mini-game interactions, and fact unlocks via `flutter/services`.
- **"Proof of Observation" Mini-games:** Four unique challenges gate each fact behind an interactive task.
- **Insight Points & Live Badge:** IP tracking with a frosted-glass badge always visible in the feed header.

## Mini-games
| Game | Description |
|------|-------------|
| **Math** | Solve a multiplication problem with visual correct/wrong feedback |
| **Color Sequence** | Simon-says memory game — 2 rounds of 4 glowing orbs |
| **Word Match** | Tap scrambled letters to spell QUARK, PHOTON, etc. (with undo) |
| **Tap Target** | Catch 5 quantum particles at random positions (with particle burst FX) |

## Content Pool
30 quantum physics facts covering superposition, entanglement, tunneling, uncertainty, antimatter, qubits, dark matter, Hawking radiation, and more. Each day the app shuffles and serves 25.

- **Teasers:** Everyday-life hooks written as scroll-stopping statements and questions (e.g., *"Your coffee mug is technically passing through your desk right now"*).
- **Facts:** Each fact is a 4+ paragraph mini-article written in the tone of the funnest high school teacher / college professor. Opens with the direct answer to the teaser, expands with relatable analogies, connects to real-world tech, and closes with a mind-blowing thought. Facts are scrollable in the UI.

## Getting Started

1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version `>=3.0.0 <4.0.0`).
2. Clone this repository.
3. Run `flutter pub get` to download dependencies.
4. Run `flutter run` to launch on your preferred emulator or device.

*For the best experience (haptics + animations), test on a physical iOS or Android device.*

## Project Structure
- `lib/main.dart` — Entry point, `Provider` initialization, routes to `DailyFeedScreen`.
- `lib/screens/daily_feed_screen.dart` — Full-screen vertical paged feed with page indicator + IP badge.
- `lib/components/post_card.dart` — Individual fact card with entrance animation, scrollable fact display, unlock button, and success banner.
- `lib/components/generative_quantum_art.dart` — Procedural background art (`CustomPaint`).
- `lib/components/ambient_particles.dart` — Floating particle overlay.
- `lib/components/tasks/` — Mini-game widgets: `math_task`, `color_sequence_task`, `word_match_task`, `tap_target_task`, and the routing `task_manager_dialog`.
- `lib/data/quantum_post.dart` — `QuantumPost` model and `TaskType` enum.
- `lib/data/post_repository.dart` — Daily feed generation with 30-fact pool (expanded multi-paragraph facts) and `SharedPreferences` caching.
- `lib/data/module_data.dart` — Static module/course data.
- `lib/services/progress_service.dart` — Insight Points persistence via `SharedPreferences`.
- `lib/theme/app_theme.dart` — Dark-mode-first theme with neon blue/purple palette.

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
