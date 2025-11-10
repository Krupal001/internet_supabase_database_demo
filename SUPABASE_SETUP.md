# 🔧 API Setup Guide

## ✅ API Already Configured!

Your API is already set up and ready to use:

**API Endpoint:** `https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata`

The configuration is in: `lib/core/config/supabase_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'https://peoaqipingwuqoyykhai.supabase.co';
  static const String apiKey = 'your-api-key-here';
  static const String userDataUrl = '$baseUrl/rest/v1/userdata';
}
```

## 🔄 How It Works

This app uses **direct HTTP API calls** (not Supabase SDK):
- ✅ GET requests to fetch data
- ✅ POST requests to create data
- ✅ PATCH requests to update data
- ✅ DELETE requests to remove data

## Step 3: Verify Your Database Table

Make sure your Supabase database has a table named `userdata` with these columns:

| Column Name | Type | Nullable |
|------------|------|----------|
| id | int8 | No (Primary Key) |
| name | text | Yes |
| email | text | Yes |
| created_at | timestamptz | Yes |

### SQL to Create Table (if needed):

```sql
CREATE TABLE userdata (
  id BIGSERIAL PRIMARY KEY,
  name TEXT,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (optional but recommended)
ALTER TABLE userdata ENABLE ROW LEVEL SECURITY;

-- Allow public access for testing (adjust for production)
CREATE POLICY "Allow public access" ON userdata
  FOR ALL USING (true);
```

## Step 4: Test the Connection

1. Run the app:
```bash
flutter run
```

2. Click on **"User Data (Supabase)"** card
3. The app will fetch data from your Supabase API
4. You can add, view, and delete user data

## API Endpoints Used

All operations use direct HTTP calls to:

**Base URL:** `https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata`

- **GET All:** `?select=*&order=id.asc`
- **GET By ID:** `?id=eq.{id}&select=*`
- **POST Create:** `?select=*` (with JSON body)
- **PATCH Update:** `?id=eq.{id}&select=*` (with JSON body)
- **DELETE:** `?id=eq.{id}`

## Features Implemented

✅ **GET** - Fetch all user data via HTTP GET
✅ **POST** - Create new user data via HTTP POST
✅ **PATCH** - Update existing user data via HTTP PATCH
✅ **DELETE** - Delete user data by ID via HTTP DELETE

## Architecture Flow

```
UI (UserDataPage)
    ↓
Cubit (UserDataCubit)
    ↓
Use Case (GetAllUserDataUseCase)
    ↓
Repository (UserDataRepositoryImpl)
    ↓
Data Source (UserDataRemoteDataSourceImpl)
    ↓
HTTP Client (http package)
    ↓
REST API (https://peoaqipingwuqoyykhai.supabase.co/rest/v1/userdata)
```

## Troubleshooting

### Error: "Failed to fetch user data"
- Check your internet connection
- Verify your Supabase anon key is correct
- Make sure the `userdata` table exists
- Check if Row Level Security policies allow access

### Error: "Invalid API key"
- Double-check you copied the **anon/public** key (not the service_role key)
- Make sure there are no extra spaces in the key

### Error: "Table does not exist"
- Create the `userdata` table using the SQL above
- Verify the table name is exactly `userdata` (lowercase)

## Security Notes

⚠️ **Important**: The anon key is safe to use in client-side code, but:
- Set up proper Row Level Security (RLS) policies in production
- Don't commit sensitive keys to public repositories
- Consider using environment variables for production

## Next Steps

1. Add authentication (Supabase Auth)
2. Implement update functionality
3. Add pagination for large datasets
4. Implement offline caching
5. Add real-time subscriptions

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
