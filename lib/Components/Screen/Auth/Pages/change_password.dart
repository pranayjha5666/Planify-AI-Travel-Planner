import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Common/widget/custom_button.dart';
import '../../../../Common/widget/custom_textformfield.dart';
import '../../../../responsive.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = "/change-password-screen";

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isCurrentPasswordVisible = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;


  bool _isLoading = false;

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final RegExp upperCase = RegExp(r'[A-Z]');
    final RegExp lowerCase = RegExp(r'[a-z]');
    final RegExp digit = RegExp(r'\d');
    final RegExp specialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!upperCase.hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!lowerCase.hasMatch(value)) {
      return 'Password must contain at least 1 lowercase letter';
    }
    if (!digit.hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }
    if (!specialCharacter.hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }
    return null; // Password is valid
  }


  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      String email = user!.email!;

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(_newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );

      Navigator.pop(context); // Go back to the profile page
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed to change password")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  margin: Responsive.isMobile(context)
                      ? EdgeInsets.only(top: 25)
                      : EdgeInsets.all(0),
                  child: Text(
                    "Change Your Password",
                    style: TextStyle(
                      fontFamily: "OutFit",
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Ensure your account security by setting a strong password.",
                  style: TextStyle(
                    fontFamily: "OutFit",
                    color: Colors.black.withOpacity(0.6),
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "Current  Password",
                  style: TextStyle(
                    fontFamily: "outfit",
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                CustomTextFormField(
                  controller: _currentPasswordController,
                  hintText: "Current Password",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _isCurrentPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  isPassword: !_isCurrentPasswordVisible,
                  onSuffixIconTap: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                  validator: passwordValidator,
                ),
                SizedBox(height: screenHeight * 0.03),

                Text(
                  "New Password",
                  style: TextStyle(
                    fontFamily: "outfit",
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextFormField(
                  controller: _newPasswordController,
                  hintText: "Enter new password",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  isPassword: !_isPasswordVisible,
                  onSuffixIconTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: passwordValidator,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontFamily: "outfit",
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: "Re-enter new password",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  isPassword: !_isConfirmPasswordVisible,
                  onSuffixIconTap: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: passwordValidator,
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomButton(
                  onTap: () async {
                    await _changePassword();
                  },
                  text: "Change Password",
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
