import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Added
import 'package:provider/provider.dart';

import 'package:recycling_app/theme/theme_provider.dart';
import 'package:recycling_app/features/spalsh/presentation/view/splash_view.dart';
import 'package:recycling_app/services/auth_services.dart'; // <-- Auth service for cubit

import 'features/login/cubit/login_cubit.dart';
import 'features/register/cubit/register_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => RegisterCubit(AuthServices())),
          BlocProvider(create: (context) => LoginCubit(AuthServices())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      home: const SplashView(),
    );
  }
}
