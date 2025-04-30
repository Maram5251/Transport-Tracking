import 'package:flutter/material.dart';
import 'package:transporttracking/View/login.dart';
import 'package:transporttracking/View/registerpage.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final StatefulWidget stfwidget;
  const LoginOrRegisterPage({super.key , required this.stfwidget});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  
  bool showLoginPage=true;
  void togglePages(){
    setState(() {
     showLoginPage=!showLoginPage; 
    });
    
  }
  @override
  Widget build(BuildContext context) {
     if (showLoginPage){
      return Login(onTap: togglePages, stfwidget: widget.stfwidget,);
     }
     else{
      return Registerpage(onTap: 
      togglePages,
      stfwidget: widget.stfwidget,
      );
     }
  }
}