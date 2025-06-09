import 'package:event_kita_app/features/register/personal_info.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = ''; // Stores error codes from Firebase or custom ones

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        debugPrint('Firebase Auth Error: $errorCode');
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void toPersonalInfo() {
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalInfo(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
      )
    );
  }

  void checkInput() async {
    if (!mounted) return;

    // Basic client-side validation
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorCode = 'Please fill in all fields.';
      });
      return;
    }

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _errorCode = 'passwords-do-not-match'; // Use our custom code
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorCode = '';
    });

    try {
      // Navigate on successful registration if the widget is still mounted
      if (mounted) {
        toPersonalInfo();
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

  // Common InputDecoration for text fields and dropdown
  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    TextEditingController? controller,
    VoidCallback? onClear,
  }) {
    final Color accentColor = const Color(0xFF7350C3);
    final Color textFieldFillColor = Colors.white;
    bool canClear = false;
    if (controller != null) {
      canClear = controller.text.isNotEmpty;
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
                // --- Sign Up Title ---
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40.0),

                // --- Email Text Field ---
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(
                    labelText: 'Email',
                    hintText: 'Input your email address',
                    controller: _emailController,
                    onClear: () {
                      _emailController.clear();
                      setState(() {});
                    },
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {}), // For suffix icon visibility
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20.0),

                // --- Password Text Field ---
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration(
                    labelText: "Password", 
                    hintText: "Input your password",
                    controller: _passwordController,
                    onClear: () {
                      _passwordController.clear();
                      setState(() {});
                    }
                  ),
                  obscureText: true,
                  onChanged: (value) => setState(() {}),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20.0),

                // --- Confirm Password Text Field ---
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: _inputDecoration(
                    labelText: "Confirm Password", 
                    hintText: "Re-enter your password",
                    controller: _confirmPasswordController,
                    onClear: () {
                      _confirmPasswordController.clear();
                      setState(() {});
                    }
                  ),
                  obscureText: true,
                  onChanged: (value) => setState(() {}),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12.0),

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
                
                const SizedBox(height: 24.0), // Space before the button

                // --- checkInput Button ---
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
                  onPressed: _isLoading ? null : checkInput, // Disable button when loading
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text('Register', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20.0), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}