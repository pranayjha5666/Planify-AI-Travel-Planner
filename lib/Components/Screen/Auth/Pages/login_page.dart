import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Common/widget/custom_textformfield.dart';
import 'package:ai_travel_planner/Components/Screen/Auth/Pages/signup_page.dart';
import 'package:ai_travel_planner/Components/Screen/Auth/Services/auth_services.dart';
import 'package:ai_travel_planner/Components/Screen/Splash_Screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../responsive.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login-screen";
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Firebase Part
  Future<void>signInWithEmailAndPassword() async{
    try {
      await AuthServices().signInWithEmailAndPassword(email: _emailcontroller.text, password: _passwordcontroller.text,context: context);
    } on FirebaseAuthException catch(e){
        print(e.code);
        String errorMessage = getFirebaseErrorMessage(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
    }
  }

  Future<void>signInWithGoogle() async{
    try {
      await AuthServices().handleGoogleSign(context);
    } on FirebaseAuthException catch(e){
      print(e.code);
      String errorMessage = getFirebaseErrorMessage(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'Invalid email address or password.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
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
                    Navigator.pushNamed(context, SplashScreen.routeName);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  margin: Responsive.isMobile(context)
                      ? EdgeInsets.only(top: 25)
                      : EdgeInsets.all(0),
                  child: Text(
                    "Let's Sign You In",
                    style: TextStyle(
                      fontFamily: "OutFit",
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontFamily: "OutFit",
                    color: Colors.black.withOpacity(0.6),
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "You've been missed!",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: "OutFit",
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "Email",
                  style: TextStyle(
                    fontFamily: "outfit",
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextFormField(
                  controller: _emailcontroller,
                  hintText: "Enter Email",
                  prefixIcon: Icons.email_outlined,
                  validator: emailValidator,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Password",
                  style: TextStyle(
                    fontFamily: "outfit",
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextFormField(
                  controller: _passwordcontroller,
                  hintText: "Enter Password",
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
                CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await signInWithEmailAndPassword();
                    }
                  },
                  text: "Sign In",
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignupPage.routeName,
                          (route) => false,
                    );
                  },
                  text: "Create Account",
                  borderRadius: BorderRadius.circular(10),
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                ),
                SizedBox(height: screenHeight * 0.02),

          GestureDetector(
            onTap: signInWithGoogle,

            child: Container(
              margin: const EdgeInsets.all(0),
              width:  double.infinity,
              padding:  const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/google.png",height: 25,),
                  SizedBox(width: 15,),
                  Text(
                    "Continue With Google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )

              ],
            ),
          ),
        ),
      ),
    );


  }
}
