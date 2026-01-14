import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../providers/firebase_provider.dart';

class AuthDialog extends ConsumerStatefulWidget {
  final bool isLogin;

  const AuthDialog({super.key, this.isLogin = false});

  @override
  ConsumerState<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends ConsumerState<AuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  List<Widget> _buildBlobs() {
    final positions = [
      const Offset(30, 60),
      const Offset(300, 20),
      const Offset(20, 180),
      const Offset(280, 200),
      const Offset(40, 400),
      const Offset(240, 430),
    ];
    return positions
        .map(
          (pos) => Positioned(
            top: pos.dy,
            left: pos.dx,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget buildTextField(
    String label, {
    bool isPassword = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool? obscureText,
    VoidCallback? toggleObscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ?? true
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: toggleObscureText,
                )
                : null,
      ),
      validator: validator,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final auth = ref.read(firebaseAuthProvider);
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (widget.isLogin) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = _getErrorMessage(e));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //backgroundColor: const Color(0xFF2471BD),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          spacing: 25,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.only(top:15),child: SvgPicture.asset("assets/icons/impact-logo-v5.svg",height: 80,),),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isLogin ? "Welcome back" : "Create an account",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2471BD),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email Field
                    buildTextField(
                      "Email*",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    buildTextField(
                      "Password*",
                      isPassword: true,
                      controller: passwordController,
                      obscureText: obscurePassword,
                      toggleObscureText:
                          () => setState(
                            () => obscurePassword = !obscurePassword,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field (only for sign up)
                    if (!widget.isLogin)
                      buildTextField(
                        "Confirm Password*",
                        isPassword: true,
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        toggleObscureText:
                            () => setState(
                              () =>
                          obscureConfirmPassword =
                          !obscureConfirmPassword,
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 8),

                    // Toggle between login/signup
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) =>
                              AuthDialog(isLogin: !widget.isLogin),
                        );
                      },
                      child: Text(
                        widget.isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Log in",
                        style: const TextStyle(color: Color(0xFF2471BD)),
                      ),
                    ),

                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2471BD),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child:
                      isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(widget.isLogin ? "Log in" : "Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
