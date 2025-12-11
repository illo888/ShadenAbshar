## Quick orientation for AI coding agents

This project is a Flutter mobile app: `SARA/`.
Focus areas: conversation UI, Groq AI integration, Saimaltor action handlers, RTL-first Arabic UX, and audio (TTS/recording).

Key files to inspect before editing behavior or generating code:
- App entry: `lib/main.dart` (app initialization, RTL setup)
- Navigation: `lib/config/routes/app_router.dart` (go_router setup, bottom tabs)
- Chat & UX: `lib/features/chat/chat_screen.dart` (assistant context composition, OTP handling, CTA parsing)
- AI client: `lib/core/services/groq_service.dart` (system prompt, call shape, error fallback, model/env usage)
- Action executor: `lib/core/services/saimaltor_service.dart` (action descriptor format, SERVICE_MAP handlers, `executeSaimaltorAction`)
- Config: `lib/config/constants.dart` (GROQ_API_KEY, GROQ_BASE_URL, model defaults)

Architecture & data flow (short):
- UI triggers -> `ChatScreen` collects context/history -> `GroqService.sendMessage` in `groq_service.dart` -> assistant reply (string) -> `ChatScreen` extracts CTA JSON block and renders with `ChatBubble`.
- CTA actions that start with `saimaltor:` are routed to `executeSaimaltorAction` which runs a local handler in `saimaltor_service.dart` and returns a `SaimaltorActionResult` (message, ctas, reference, status).
- TTS uses `lib/core/services/tts_service.dart` and `AudioService` abstraction; recording uses `VoiceRecorder` which relies on `flutter_sound`.

Project-specific conventions you must follow when generating assistant text or plumbing:
- Assistant replies MAY include a CTA block in a fenced code block labeled ```cta ... ``` containing either a JSON array or an object with `.ctas` array. Example:
```json
```cta
[ { "label":"تحميل الجواز الرقمي", "action":"saimaltor:download-passport?target=self", "variant":"primary" } ]
```
```
- Any action that will be executed by the app must have `action` starting with `saimaltor:` (e.g. `saimaltor:renew-passport?person=self`).
- CTA variant must be `primary` or `secondary` (primary = main action). Keep 1 primary and up to 2 secondary.
- The assistant system prompt in `groq_service.dart` enforces: Arabic Najdi dialect, short friendly sentences, and Saimaltor execution authority. When altering assistant prompts, preserve those constraints and the CTA formatting rules.

Build / run / debug commands (from repo):
- Install: `flutter pub get`
- Start dev server: `flutter run` (runs on connected device/simulator)
- iOS simulator: `flutter run -d ios` (requires Xcode)
- Android emulator: `flutter run -d android` (requires Android Studio/SDK)
- Web: `flutter run -d chrome`
- Clear cache: `flutter clean && flutter pub get`
- TypeScript check: `flutter analyze`
- Build APK: `flutter build apk`
- Build iOS: `flutter build ios`

Notes for changes and PRs
- Prefer small, localized edits. If your change affects assistant behavior, update `lib/core/services/groq_service.dart` and ensure CTA extraction in `lib/features/chat/chat_screen.dart` still parses the block.
- When adding features that execute services, register a handler in `SERVICE_MAP` inside `lib/core/services/saimaltor_service.dart` and return a `SaimaltorActionResult` (see existing handlers for pattern).
- Keep RTL-first assumptions: `locale: const Locale('ar', 'SA')` is enabled in `lib/app.dart`. Test layout on both platforms.
- Do not hardcode API keys; use environment variables or secure storage referenced from `lib/config/constants.dart`.

Files worth referencing for examples and patterns:
- `lib/core/services/saimaltor_service.dart` — canonical CTA/result format and action parsing
- `lib/core/services/groq_service.dart` — system prompt + model fallback logic
- `lib/features/chat/chat_screen.dart` — CTA extraction, OTP injection, TTS playback
- `lib/main.dart` — app initialization & RTL setup

If anything in these instructions is unclear or you need additional examples (more CTA variants, more Saimaltor action examples, or testing tips for audio), ask and I will iterate.