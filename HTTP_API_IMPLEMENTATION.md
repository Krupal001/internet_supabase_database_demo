# 🌐 HTTP API Implementation

## ✅ What Changed

Your app now uses **direct HTTP API calls** instead of the Supabase SDK.

### Before (Supabase SDK):
```dart
final response = await supabaseClient
    .from('userdata')
    .select('*')
    .order('id', ascending: true);
```

### After (HTTP Client):
```dart
final url = Uri.parse('${ApiConfig.userDataUrl}?select=*&order=id.asc');
final response = await httpClient.get(url, headers: ApiConfig.headers);
final List<dynamic> jsonList = json.decode(response.body);
```

## 📦 Dependencies

### Removed:
- ❌ `supabase_flutter: ^2.0.0`

### Added:
- ✅ `http: ^1.1.0`

## 🔧 Configuration

### API Config (`lib/core/config/supabase_config.dart`)

```dart
class ApiConfig {
  // Base API URL
  static const String baseUrl = 'https://peoaqipingwuqoyykhai.supabase.co';
  
  // API Key
  static const String apiKey = 'your-api-key-here';
  
  // Full API endpoint
  static const String userDataUrl = '$baseUrl/rest/v1/userdata';
  
  // Headers for all requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
  };
}
```

## 🌐 HTTP Endpoints

All operations use the base URL: `https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata`

### 1. GET All User Data
```dart
GET /rest/v1/userdata?select=*&order=id.asc

Headers:
- Content-Type: application/json
- apikey: {your-api-key}
- Authorization: Bearer {your-api-key}

Response: 200 OK
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 2. GET User Data by ID
```dart
GET /rest/v1/userdata?id=eq.1&select=*

Response: 200 OK
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 3. POST Create User Data
```dart
POST /rest/v1/userdata?select=*

Body:
{
  "name": "Jane Doe",
  "email": "jane@example.com"
}

Response: 201 Created
[
  {
    "id": 2,
    "name": "Jane Doe",
    "email": "jane@example.com",
    "created_at": "2024-01-02T00:00:00Z"
  }
]
```

### 4. PATCH Update User Data
```dart
PATCH /rest/v1/userdata?id=eq.2&select=*

Body:
{
  "name": "Jane Smith",
  "email": "jane.smith@example.com"
}

Response: 200 OK
[
  {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane.smith@example.com",
    "created_at": "2024-01-02T00:00:00Z"
  }
]
```

### 5. DELETE User Data
```dart
DELETE /rest/v1/userdata?id=eq.2

Response: 204 No Content
```

## 📝 Implementation Details

### Data Source (`user_data_remote_datasource.dart`)

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/supabase_config.dart';

class UserDataRemoteDataSourceImpl implements UserDataRemoteDataSource {
  final http.Client httpClient;

  UserDataRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<UserDataModel>> getAllUserData() async {
    try {
      final url = Uri.parse('${ApiConfig.userDataUrl}?select=*&order=id.asc');
      final response = await httpClient.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => UserDataModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
  
  // ... other methods
}
```

### Dependency Injection (`injection_container.dart`)

```dart
import 'package:http/http.dart' as http;

Future<void> initializeDependencies() async {
  // Register HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Register Data Source with HTTP Client
  sl.registerLazySingleton<UserDataRemoteDataSource>(
    () => UserDataRemoteDataSourceImpl(httpClient: sl()),
  );
}
```

## ✅ Benefits

1. **No SDK Dependencies**: Direct control over HTTP requests
2. **Lightweight**: Only uses the `http` package
3. **Transparent**: Easy to see exactly what API calls are being made
4. **Flexible**: Easy to modify headers, query parameters, etc.
5. **Testable**: Easy to mock HTTP client for testing

## 🔍 Query Parameters

Supabase REST API uses PostgREST query syntax:

- `select=*` - Select all columns
- `select=id,name,email` - Select specific columns
- `order=id.asc` - Order by id ascending
- `order=created_at.desc` - Order by created_at descending
- `id=eq.1` - Where id equals 1
- `name=like.*John*` - Where name contains "John"
- `limit=10` - Limit to 10 results
- `offset=20` - Skip first 20 results

## 🎯 Status Codes

- **200 OK** - GET, PATCH successful
- **201 Created** - POST successful
- **204 No Content** - DELETE successful
- **400 Bad Request** - Invalid request
- **401 Unauthorized** - Invalid or missing API key
- **403 Forbidden** - RLS policy denies access
- **404 Not Found** - Resource not found
- **500 Internal Server Error** - Server error

## 🔐 Security

### Headers Required:
```dart
{
  'Content-Type': 'application/json',
  'apikey': 'your-anon-key',           // Required
  'Authorization': 'Bearer your-anon-key'  // Required
}
```

### Row Level Security (RLS):
- Make sure your Supabase table has appropriate RLS policies
- The anon key has limited permissions based on RLS policies
- For testing, you can allow public access (not recommended for production)

## 🧪 Testing

You can test the API directly using curl:

```bash
# GET All
curl -X GET \
  'https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata?select=*' \
  -H 'apikey: your-api-key' \
  -H 'Authorization: Bearer your-api-key'

# POST Create
curl -X POST \
  'https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata?select=*' \
  -H 'apikey: your-api-key' \
  -H 'Authorization: Bearer your-api-key' \
  -H 'Content-Type: application/json' \
  -d '{"name":"Test User","email":"test@example.com"}'

# DELETE
curl -X DELETE \
  'https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata?id=eq.1' \
  -H 'apikey: your-api-key' \
  -H 'Authorization: Bearer your-api-key'
```

## 📚 Resources

- [PostgREST API Documentation](https://postgrest.org/en/stable/api.html)
- [Supabase REST API Guide](https://supabase.com/docs/guides/api)
- [HTTP Package Documentation](https://pub.dev/packages/http)

## 🎉 Summary

Your app now makes direct HTTP calls to the Supabase REST API:
- ✅ No Supabase SDK dependency
- ✅ Full control over HTTP requests
- ✅ Easy to understand and debug
- ✅ Uses standard `http` package
- ✅ All CRUD operations working
