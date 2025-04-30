import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/my_button.dart';
import 'package:transporttracking/View/square_tile.dart';
import 'package:transporttracking/View/text_field.dart';

class Registerpage extends StatefulWidget {
  final Function()? onTap  ; 
  final StatefulWidget stfwidget; 
   const Registerpage({super.key, required this.onTap, required this.stfwidget});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
   final emailController = TextEditingController();

   final userpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image:
          AssetImage('assets/bg1.gif'),
          fit: BoxFit.cover, 
          )
        ),
        child: SafeArea ( 
          child : Center ( 
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Icon(
              Icons.lock, 
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 5),
           Center(
              child: Text('Let\'s create account for you ! '.tr(),style: TextStyle(
              fontSize: 25 , 
              fontWeight: FontWeight.bold
            ),textAlign: TextAlign.center,),),
            const SizedBox(height: 5),
            MyTextField(controller: emailController,hintText: 'Email'.tr(),obscureText: false,),
            const SizedBox(height: 5),
            MyTextField(controller: userpasswordController, hintText: 'Password'.tr(), obscureText:true),
            const SizedBox(height: 5),
            MyTextField(controller: confirmpasswordController, hintText: 'Confirm Password'.tr(), obscureText:true),
            const SizedBox(height: 5),
            Mybutton(
              ontap:(){Controller.signUserUp(context,mounted, emailController,userpasswordController,confirmpasswordController,widget.stfwidget);},
              text : "Sign Up",
            ),
           const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.blue ,
                  ),
                ),
                Padding (
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child : Text('Or continue with '.tr(), style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),)),
                Expanded(child:
                Divider(
                  thickness: 0.5,
                  color: Colors.blue,
                )),]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/apple-icon.png'),
                    const SizedBox(width: 5),
                    SquareTile(imagePath: 'assets/google-icon.png'),
                  ],),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text('Already have an account ? '.tr(),style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child:Text('Login now '.tr(), 
                      style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),),),
                  ],)
        
              ],
            )
          )
          )
          )
          ));
  }
}