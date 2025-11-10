/// API configuration
class ApiConfig {
  // Base API URL
  static const String baseUrl = 'https://peoaqipingwuqoyykhai.supabase.co';
  
  // API Key (Supabase anon key)
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlb2FxaXBpbmd3dXFveXlraGFpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2OTI2NTcsImV4cCI6MjA3NDI2ODY1N30.wzQmzf0-JABFeX341bTZakzm_-L9VhUD_hiXxDiPjN8';
  
  // Full API endpoint
  static const String userDataUrl = '$baseUrl/rest/v1/userdata';
  
  // Headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
  };
}
