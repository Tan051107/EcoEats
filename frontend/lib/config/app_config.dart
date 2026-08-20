/// Build-time settings for the Flutter client.
///
/// Example: flutter run --dart-define=ECOEATS_FUNCTIONS_REGION=asia-southeast1
class AppConfig {
  static const functionsRegion = String.fromEnvironment(
    'ECOEATS_FUNCTIONS_REGION',
    defaultValue: 'us-central1',
  );
}
