import 'package:ai_travel_planner/Components/Screen/Auth/Pages/login_page.dart';
import 'package:ai_travel_planner/Components/Screen/Home_Page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SplashScreenServices{
  Future<void> isLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    User? user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      Navigator.pushNamedAndRemoveUntil(context, Home_Page.routeName,(route) => false,);
    }
    else{
      Navigator.pushNamed(context, LoginPage.routeName);
    }
  }
}