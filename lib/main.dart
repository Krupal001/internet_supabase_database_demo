import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_db/features/userdata/presentation/pages/internet_page.dart';
import 'core/di/injection_container.dart';
import 'features/userdata/presentation/cubit/user_data_cubit.dart';
import 'features/userdata/presentation/pages/user_data_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (includes Supabase)
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => sl<UserDataCubit>(),
        child: const InternetPage(),
      ),
    );
  }
}
