import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: const Text('Please login or register to continue.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to register screen
              Navigator.pushNamed(context, 'register');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(User? user, VoidCallback onLoggedIn) {
    if (user == null) {
      _showLoginDialog();
    } else {
      onLoggedIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final username = user?.email?.split('@').first ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello${user != null ? ' $username' : ''}!'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _onButtonPressed(user, () {
                    // Navigate to CreateEvent screen
                  }),
                  child: const Text('Create Event'),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed(user, () {
                    // Navigate to RSVPtoEvent screen
                  }),
                  child: const Text('RSVP to Event'),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed(user, () {
                    Navigator.pushNamed(context, 'profile_page');
                  }),
                  child: const Text('Profile'),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed(user, () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, 'home');
                  }),
                  child: const Text("Logout")
                )
              ],
            ),
          ),
        );
      },
    );
  }
}