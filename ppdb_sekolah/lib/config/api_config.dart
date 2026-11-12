/// Base URL for the PPDB API.
///
/// Override for production builds with:
/// flutter build web --release --dart-define=API_BASE_URL=https://your-api.example.com
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000',
);
