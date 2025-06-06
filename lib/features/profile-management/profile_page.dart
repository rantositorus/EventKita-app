import 'package:flutter/material.dart';
import '../../services/firestore_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String profilePicturePath = '';
  final ValueNotifier<bool> _isPasswordFilled = ValueNotifier<bool>(false);

  // A flag to ensure controllers are only initialized once
  bool _controllersInitialized = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper method to build styled text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true, // To make email field non-editable,
    bool isPassword = false, // To handle password field
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
            ),
            obscureText: isPassword, // Handle password visibility
            onChanged: (value) {
              if (isPassword) {
                _isPasswordFilled.value = value.isNotEmpty;
              }
            },
          ),
        ],
      ),
    );
  }

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          // You might want to navigate to a login screen here
          return const Center(child: Text('No user is logged in.'));
        }

        final user = snapshot.data!;
        return FutureBuilder<Map<String, dynamic>?>(
          future: FirestoreProfile().getUserProfile(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (profileSnapshot.hasError) {
              return Center(child: Text('Error: ${profileSnapshot.error}'));
            }
            final profileData = profileSnapshot.data;

            if (profileData != null && !_controllersInitialized) {
              _emailController.text = user.email ?? '';
              _fullNameController.text = profileData['name'] ?? '';
              _dobController.text = profileData['dob'] ?? '';
              _genderController.text = profileData['gender'] ?? '';
              _phoneController.text = profileData['phone'] ?? '';
              profilePicturePath = profileData['profilePicture'] ?? '';
              _controllersInitialized = true;
            }

            // Store initial values for comparison
            final initialProfileData = {
              'name': profileData?['name'] ?? '',
              'dob': profileData?['dob'] ?? '',
              'gender': profileData?['gender'] ?? '',
              'phone': profileData?['phone'] ?? '',
            };

            return Scaffold(
              backgroundColor: const Color(0xFFF8F8F8),
              appBar: AppBar(
                title: const Text('EventKita', style: TextStyle(fontWeight: FontWeight.bold)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // -- PROFILE HEADER --
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E0F8), // Light purple background
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (profilePicturePath != '' && profilePicturePath.toString().startsWith('http'))
                            ? NetworkImage(profilePicturePath)
                            : const AssetImage('lib/assets/images/default_profile.png') as ImageProvider,
                      ),
                      ),
                      const SizedBox(height: 30),

                      // -- FORM FIELDS --
                      _buildTextField(label: 'Email', controller: _emailController, enabled: false),
                      _buildTextField(label: 'Full Name', controller: _fullNameController),
                      _buildTextField(label: 'Date of Birth', controller: _dobController),
                      _buildTextField(label: 'Gender', controller: _genderController),
                      _buildTextField(label: 'Phone Number', controller: _phoneController),

                      // -- PASSWORD FIELD --
                      _buildTextField(label: 'Password', controller: _passwordController, isPassword: true),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Insert Password to Change Information',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: _errorMessage.contains('SUCCESS') ? Colors.green : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // -- CHANGE BUTTON --
                      ValueListenableBuilder<bool>(
                        valueListenable: _isPasswordFilled,
                        builder: (context, isFilled, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (!isFilled)
                                  ? null
                                  : () {
                                    bool isChanged =
                                      _fullNameController.text != initialProfileData['name'] ||
                                      _dobController.text != initialProfileData['dob'] ||
                                      _genderController.text != initialProfileData['gender'] ||
                                      _phoneController.text != initialProfileData['phone'];
                                      setState(() {
                                        _errorMessage = '';
                                      });
                                      if (!isChanged) {
                                        setState(() {
                                          _isPasswordFilled.value = false;
                                          _errorMessage = 'No changes detected in your information.';
                                          _passwordController.clear();
                                        });
                                        return;
                                      }
                                      FirestoreProfile().updateUserProfile(
                                        user.uid,
                                        {
                                          'name': _fullNameController.text,
                                          'dob': _dobController.text,
                                          'gender': _genderController.text,
                                          'phone': _phoneController.text,
                                          // tambahin profile picture
                                        }
                                      ).then((_) {
                                        setState(() {
                                          _isPasswordFilled.value = false;
                                          _errorMessage = 'SUCCESS: Information updated successfully.';
                                          _passwordController.clear();
                                        });
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (!isFilled)
                                    ? Colors.grey.shade300
                                    : Colors.deepPurple,
                                foregroundColor:(!isFilled)
                                    ? Colors.black54
                                    : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Change Information'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}