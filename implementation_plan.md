# Planck — Implementation Plan

This document tracks the development phases of the Planck quantum physics educational app.

## Completed Phases
- [x] **Phase 1: Project Initialization** — Flutter setup, basic architecture.
- [x] **Phase 2: TikTok-Style Feed** — Vertical pager, full-screen cards.
- [x] **Phase 3: Generative Art** — Procedural backgrounds for cards.
- [x] **Phase 4: Task Framework** — Core mini-game mechanics.
- [x] **Phase 5: Content Pool** — 30 initial quantum facts.
- [x] **Phase 6: UI/UX Polish** — Frosted glass IP badge, smoother transitions.
- [x] **Phase 7: Word Match & Tap Target** — Expanded task variety.
- [x] **Phase 8: Persistence** — SharedPreferences for IP and feed caching.
- [x] **Phase 9: Audio Removal** — Shifted focus to a visual-first experience; removed legacy audio services.
- [x] **Phase 10: Content Expansion** — Rewrote 30 facts into engaging, multi-paragraph articles with a fun teacher tone.
- [x] **Phase 11a: Physical Device Deployment** — Verified deployment and haptics on physical iPhone via USB and WiFi.

## Current Status: Pivot to Personal Use (Phase 12+)
**Strategic Pivot (March 2026):**
The project has shifted from a public App Store release to a high-quality, personal app for the developer (iOS) and partner (Android).
- **Goal:** Zero cost, offline-first, massive content library.
- **Strategy:** "Build-Time AI". Content is generated in bulk (1000+ facts) and bundled as JSON. No runtime API calls.

---

## Active Phase: 12 — Local Content Engine
- [ ] **Data Layer Refactor:**
    - [ ] Create `assets/content.json` schema.
    - [ ] Update `pubspec.yaml` to include assets.
    - [ ] Rewrite `PostRepository` to load/parse JSON asynchronously.
    - [ ] Remove hardcoded facts from Dart code.
- [ ] **Content Generation (The "Brain"):**
    - [ ] Create a "Fact Generator" prompt/script to mass-produce valid JSON entries.
    - [ ] Generate Batch 1: 50-100 deep-dive facts (Quantum Computing, String Theory, etc.).
    - [ ] Validate JSON integrity.

## Phase 13 — Personal Deployment
- [ ] **Android (Samsung S22):**
    - [ ] Configure signing config (debug keystore is fine for personal use, or create a release keystore).
    - [ ] Build APK: `flutter build apk --release`.
    - [ ] Verify installation on device.
- [ ] **iOS (iPhone):**
    - [ ] Configure Xcode for Personal Team signing.
    - [ ] Document the 7-day renewal process (or setup AltStore).
    - [ ] Build and deploy: `flutter run --release`.

## Future Ideas
- [ ] **"Update Packs":** A simple script to generate 100 new facts and "patch" the app by rebuilding it.
- [ ] **Personal Stats:** Local graphing of "Insight Points" over time.

---

## Deprecated / Completed Phases
- [x] **Phase 1-11a:** Core Development (Completed).
- [x] **Phase 11b:** App Store Readiness (**CANCELLED** - Pivoted to Personal Use).
