# ORCHID Symbol Receiver — VaN HQ iOS starter

Feature branch only. The keyboard inserts Unicode symbols locally and is offline by default; no key capture, background uploads, or remote execution. This folder is a prototype, not a signed or installed iOS app.

## Build
1. In Xcode create an iOS app + **Custom Keyboard Extension**.
2. Put `OrchidKeyboard/KeyboardViewController.swift` and `OrchidCore/OrchidReceiver.swift` in the keyboard extension target.
3. Include `OrchidCore/orchid_symbols.json` in the extension target's Copy Bundle Resources.
4. Merge the `NSExtension` settings from `OrchidKeyboard/Info.plist` with the generated extension Info.plist.
5. Add `OrchidHQ/HQClient.swift` to the main app target only.
6. Sign on a Mac with Xcode, install on the iPhone and enable under Settings > General > Keyboard > Keyboards > Add New Keyboard.
7. Tap 🌐 to switch keyboards.

## VaN HQ boundary
The receiver recognizes the 24 proposed symbols and shortcuts, preserves the original string and normalizes to NFC for lookup. Recognition NEVER grants authorization. The containing app's HQ client accepts a configured HTTPS endpoint exposing GET /health; **no live endpoint is identified or verified**. Do not put tokens inside keyboard extension code or JSON.

## Source of truth
Existing VaN HQ evidence and promotion policies are described in `vanellyetm-ux/-ilk--mirror/docs/VAN-KNOWLEDGE-HQ.md`. Maintain `DRAFT → SOURCE_VERIFIED → EVIDENCE_REVIEWED → IMPLEMENTATION_VERIFIED → PROMOTION_APPROVED → PUBLISHED`. Remote writes require a human-approved scope and verifiable readback. This branch doesn't modify CodEXgen, AshShow, or main.
