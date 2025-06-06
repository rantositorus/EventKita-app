import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'features/register/register_screen.dart';
import 'features/profile-management/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EventKita",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(),
        'register': (context) => const RegisterScreen(),
        'profile_page': (context) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}