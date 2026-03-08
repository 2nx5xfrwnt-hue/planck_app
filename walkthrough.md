# Planck — User Walkthrough

Welcome to Planck! This guide outlines how to navigate and test the app's core features.

## Core Flow
1. **The Daily Feed:** Upon launch, you'll see the "Daily Feed". This is a vertical, TikTok-style feed of quantum facts.
2. **Scroll to Learn:** Swipe up and down to navigate between different facts. Each fact starts with a catchy "Teaser".
3. **Observation Gated:** To read the full fact, you must complete a "Proof of Observation" task. Tap the **"Proof of Observation Required"** button at the bottom of a card.
4. **Complete the Task:** A random mini-game will appear:
   - **Math:** Quick mental arithmetic.
   - **Color Sequence:** A memory-based pattern game.
   - **Word Match:** Unscramble quantum-related words.
   - **Tap Target:** Catch 5 glowing quantum particles by tapping them as they appear at random positions.
5. **Unlock Knowledge:** Once observed, the full, multi-paragraph fact is revealed. You can scroll through the text.
6. **Closing a Task:** Use the **X** button in the top-right corner of the task dialog to cancel and return to the feed.
6. **Insight Points:** Every task completed earns you Insight Points (IP), which are tracked in the top-right frosted glass badge.

> **Note (March 2026):** The page counter (e.g. "1/15") that previously appeared in the upper-left has been removed to reduce UI clutter. The IP badge is now the only HUD overlay.

## Testing on Physical Device
Testing on a physical iPhone is recommended to fully experience the nuances of the app:
- **Haptics:** Feel the subtle vibration feedback during swipes and mini-game interactions.
- **Animations:** Observe the fluid generative backgrounds and custom transition effects.
- **Performance:** Ensure the vertical scroll feels "buttery smooth" on actual hardware.

### How to Run (Personal Build)

**For iPhone (iOS):**
1.  Connect via USB.
2.  Run `flutter run --release` (for better performance) or `flutter run` (for debugging).
3.  **Note:** Since we are using a free Apple ID, the app provisioning expires every 7 days. You will need to re-deploy (run this command again) weekly.

**For Android (Samsung S22):**
1.  Enable "Developer Options" and "USB Debugging" on the Samsung device.
2.  Connect via USB.
3.  Run `flutter install` or build an APK (`flutter build apk`) and transfer it to the phone.
4.  The APK does not expire.
