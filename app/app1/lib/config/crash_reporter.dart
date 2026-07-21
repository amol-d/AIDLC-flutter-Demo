import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Whether Crashlytics initialized successfully this session.
bool _enabled = false;

/// Initializes Firebase Crashlytics **defensively**:
/// - skipped on web (Crashlytics is mobile-only), and
/// - a no-op when Firebase config is absent (so the app runs without any
///   crash-reporting setup and lights up once `google-services.json` /
///   `GoogleService-Info.plist` are added).
///
/// See `Documentation/setup/crashlytics.md` for the native enable steps.
Future<void> initCrashReporting() async {
  if (kIsWeb) return;
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    _enabled = true;
  } catch (_) {
    // No Firebase configuration yet — continue without crash reporting.
    _enabled = false;
  }
}

/// Records an uncaught async (zone) error to Crashlytics when enabled.
void recordZoneError(Object error, StackTrace stack) {
  if (!_enabled) return;
  try {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  } catch (_) {
    // Ignore — never let crash reporting crash the app.
  }
}
