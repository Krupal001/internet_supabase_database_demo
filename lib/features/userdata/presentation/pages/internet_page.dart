import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_db/features/userdata/domain/entities/geolocation_entity.dart';
import 'package:supabase_db/features/userdata/domain/entities/user_data_entity.dart';
import 'package:supabase_db/features/userdata/presentation/cubit/user_data_cubit.dart';
import 'package:supabase_db/features/userdata/presentation/cubit/user_data_state.dart';

class InternetPage extends StatefulWidget {
  const InternetPage({super.key});

  @override
  State<InternetPage> createState() => _InternetPageState();
}

class _InternetPageState extends State<InternetPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  void _getIpInfo() {
    context.read<UserDataCubit>().getGeolocation();
  }

  void _searchByLocation() {
    context.read<UserDataCubit>().searchByGeolocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        // Show error snackbar
        if (state is UserDataError) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        final isLoading = state is UserDataLoading;

        final geolocation = state is GeolocationLoaded
            ? state.geolocation
            : null;
        _ipController.text = geolocation?.query ?? '';

        final searchResults = state is SearchResultsLoaded ? state.results : null;
        final searchType = state is SearchResultsLoaded ? state.searchType : null;

        return _buildContent(context, isLoading, geolocation, searchResults, searchType);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    GeolocationEntity? geolocation,
    List<UserDataEntity>? searchResults,
    String? searchType,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Page'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.cyan,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                'IP Address Lookup',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Input Card
              Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 850,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // IP Address TextField
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ipController,
                                decoration: InputDecoration(
                                  labelText: 'Enter IP Address',
                                  hintText: '192.168.1.1',
                                  prefixIcon: Icon(
                                    Icons.language,
                                    color: Colors.cyan,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.cyan,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.cyan.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.cyan,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Get IP Button
                            ElevatedButton(
                              onPressed: isLoading ? null : _getIpInfo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        const Icon(Icons.search, size: 28),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Get IP',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: isLoading ? null : _searchByLocation,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 50),
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Search by Location',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Search Results Section
              if (searchResults != null && searchResults.isNotEmpty) ...[
                const SizedBox(height: 30),
                Text(
                  'Search Results (${searchResults.length} found)',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ...searchResults.map((userData) => Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '${userData.firstName} ${userData.lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('DOB: ${userData.dob}'),
                        Text('City: ${userData.city}'),
                        Text('State: ${userData.state}'),
                        Text('Zip: ${userData.zip}'),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.cyan,
                      child: Text(
                        userData.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
