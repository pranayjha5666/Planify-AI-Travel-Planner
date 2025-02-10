import 'package:ai_travel_planner/Components/Screen/Auth/Pages/login_page.dart';
import 'package:ai_travel_planner/Components/Screen/Auth/Services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../Common/widget/custom_button.dart';
import '../../../../Common/widget/custom_textformfield.dart';
import '../../Splash_Screen/splash_screen.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = "/signup-screen";

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  //firebase Part
  Future<void>createUserWithEmailAndPassword() async{
    try {
      Map<String, dynamic> userInfoMap = {
        "name": _namecontroller.text,
        "email": _emailcontroller.text,
        "profileImage": 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      };
      await AuthServices().createUserWithEmailAndPassword(email: _emailcontroller.text, password: _passwordcontroller.text,context: context,userInfoMap: userInfoMap);

    } on FirebaseAuthException catch(e){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    }
  }

  Future<void>signInWithGoogle() async{
    try {
      await AuthServices().handleGoogleSign(context);
    } on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
    }
  }


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

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SplashScreen.routeName,
                          (route) => false,
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Create New Account",
                  style: TextStyle(
                    fontFamily: "OutFit",
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: height * 0.03),
                buildLabel("Full Name", height),
                SizedBox(height: height * 0.01),

                CustomTextFormField(
                  controller: _namecontroller,
                  hintText: "Enter Full Name",
                  prefixIcon: Icons.person_outline,
                  validator: nameValidator,
                ),
                SizedBox(height: height * 0.02),
                buildLabel("Email", height),
                SizedBox(height: height * 0.01),

                CustomTextFormField(
                  controller: _emailcontroller,
                  hintText: "Enter Email",
                  prefixIcon: Icons.email_outlined,
                  validator: emailValidator,
                ),
                SizedBox(height: height * 0.02),
                buildLabel("Password", height),
                SizedBox(height: height * 0.01),

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
                SizedBox(height: height * 0.03),
                CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await createUserWithEmailAndPassword();
                    }
                  },
                  text: "Create Account",
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: height * 0.02),
                CustomButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPage.routeName,
                          (route) => false,
                    );
                  },
                  text: "Sign In",
                  borderRadius: BorderRadius.circular(10),
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                ),
                SizedBox(height: height * 0.02),

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

  Widget buildLabel(String text, double height) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "outfit",
        fontSize: height * 0.02,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
