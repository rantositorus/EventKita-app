import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirestoreProfile firestoreProfile = FirestoreProfile();

class PersonalInfo extends StatefulWidget {
  final String email;
  final String password;
  const PersonalInfo({super.key, required this.email, required this.password});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = ''; // Stores error codes from Firebase or custom ones
  
  // For Gender Dropdown
  final TextEditingController _genderDisplayController = TextEditingController(); // To display selected gender textually
  String? _selectedGender; // Actual selected value for the dropdown
  final List<String> _genderOptions = ['Male', 'Female'];


  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _genderDisplayController.dispose();
    super.dispose();
  }

  void navigateHome() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'home');
  }

  String _getFriendlyErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak (at least 6 characters).';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Contact support.';
      case 'passwords-do-not-match': // Custom error code
        return 'Passwords do not match. Please re-enter.';
      default:
        // For other Firebase error codes or unexpected issues
        debugPrint('Firebase Auth Error: $errorCode'); // Log the original code for debugging
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorCode = e.code; // Store Firebase error code
        });
      }
    } catch (e) { // Catch any other unexpected errors
      if (mounted) {
        setState(() {
          // For non-Firebase exceptions, you could use a generic message
          _errorCode = 'An unexpected error occurred.';
          debugPrint('Registration Error: ${e.toString()}');
        });
      }
    } finally {
      // Ensure loading state is reset if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').tryParse(_dobController.text) ?? DateTime.now(),  
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF7350C3), // Header background
                onPrimary: Colors.white, // Header text
                onSurface: Colors.black87, // Body text
              ),
              dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            child: child!,
          );
        },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Common InputDecoration for text fields and dropdown
  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    TextEditingController? controller, // For text fields
    String? selectedValue, // For dropdown
    VoidCallback? onClear,
  }) {
    final Color accentColor = const Color(0xFF7350C3);
    final Color textFieldFillColor = Colors.white;
    bool canClear = false;
    if (controller != null) {
      canClear = controller.text.isNotEmpty;
    } else if (selectedValue != null) {
      canClear = selectedValue.isNotEmpty;
    }

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: textFieldFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentColor, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      suffixIcon: canClear && onClear != null
          ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: onClear,
            )
          : null,
    );
  }


  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF7350C3);
    const Color screenBackgroundColor = Color(0xFFF8F8FA);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: screenBackgroundColor,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Enter Your Personal Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 30.0),
        
                    // --- Full Name Text Field ---
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Input',
                        controller: _nameController,
                        onClear: () {
                          _nameController.clear();
                          setState(() {});
                        }
                      ),
                      onChanged: (value) => setState(() {}), // For suffix icon visibility
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20.0),
        
                    // --- Date of Birth Text Field ---
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'DD/MM/YYYY',
                        controller: _dobController,
                        onClear: () {
                          _dobController.clear();
                          setState(() {});
                        }
                      ),
                      onTap: () => _selectDate(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20.0),
        
                    // --- Gender Dropdown Field ---
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: _genderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                          _genderDisplayController.text = newValue ?? ''; // Update display controller
                        });
                      },
                      decoration: _inputDecoration(
                        labelText: 'Gender',
                        hintText: 'Dropdown', // This hint might be overridden by selected value
                        selectedValue: _selectedGender,
                        onClear: () {
                           setState(() {
                            _selectedGender = null;
                            _genderDisplayController.clear();
                          });
                        }
                      ).copyWith(
                        // Override hint behavior for Dropdown if a value is selected
                        hintText: _selectedGender == null ? 'Dropdown' : null,
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black87), // Ensure text color is visible
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20.0),
        
                    // --- Phone Number Text Field ---
                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Input',
                        controller: _phoneController,
                        onClear: () {
                          _phoneController.clear();
                          setState(() {});
                        }
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30.0),

                    // --- Error Message Display ---
                    if (_errorCode.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                        child: Text(
                          _getFriendlyErrorMessage(_errorCode),
                          style: const TextStyle(color: Colors.redAccent, fontSize: 14.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
        
                    // --- Continue To App Button ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_isLoading) return; // Prevent multiple submissions
                        setState(() {
                          _isLoading = true; // Set loading state
                        });
                        // Register user with email and password
                        registerUser();
                        // Check if all fields are filled
                        if (_nameController.text.isNotEmpty && _dobController.text.isNotEmpty && _selectedGender != null && _phoneController.text.isNotEmpty) {
                          // Submit personal info to firestore
                          firestoreProfile.createUserProfile(
                            FirebaseAuth.instance.currentUser!.uid,
                            {
                              'name': _nameController.text,
                              'dob': _dobController.text,
                              'gender': _selectedGender,
                              'phone': _phoneController.text,
                            }
                          );
                          navigateHome();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields')),
                          );
                        }
                      },
                      child: const Text('Continue To App', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}