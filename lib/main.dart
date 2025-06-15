import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'features/register/register_screen.dart';
import 'screens/profile_page.dart';
import 'screens/search.dart';
import 'screens/myrsvp_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EventKita",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      routes: {
        'home': (context) => const MyHomePage(),
        'register': (context) => const RegisterScreen(),
        'profile_page': (context) => const ProfilePage(),
        'search' : (context) => const SearchPage(),
        'my-rsvp': (context) => const MyRSVPPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const Placeholder(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text('EventKita')),
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Color(0xFF6750A4)),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search', backgroundColor: Color(0xFF6750A4)),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'My Events', backgroundColor: Color(0xFF6750A4)),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile', backgroundColor: Color(0xFF6750A4)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}