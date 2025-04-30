import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/my_button.dart';
import 'package:transporttracking/View/square_tile.dart';
import 'package:transporttracking/View/text_field.dart';

class Login extends StatefulWidget {
  final Function()? onTap  ; 
  final StatefulWidget stfwidget;
   const Login({super.key, required this.onTap , required this.stfwidget});
 static void showAlert(BuildContext context,String title, String text) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: title,
      desc: text,
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }
   
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
   final emailController = TextEditingController();

   final userpasswordController = TextEditingController();

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
              child: Text('Welcome to Transport Tracking'.tr(),style: TextStyle(
              fontSize: 25 , 
              fontWeight: FontWeight.bold
            ),textAlign: TextAlign.center,),),
            const SizedBox(height: 5),
            MyTextField(controller: emailController,hintText: 'Email'.tr(),obscureText: false,),
            const SizedBox(height: 5),
            MyTextField(controller: userpasswordController, hintText: 'Password'.tr(), obscureText:true),
            const SizedBox(height: 5),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child : Row ( mainAxisAlignment: MainAxisAlignment.end, 
              children :[ Text('Forget password ?'.tr(), style: TextStyle(color: Colors.red, fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
            )
            ]),),
            const SizedBox(height: 5),
            Mybutton(
              ontap:() {
                Controller.signUserIn(context, emailController, userpasswordController, mounted ,widget.stfwidget); 
              },
              text: "Sign In ".tr(),
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
                  child : Text('Or continue with'.tr(), style: TextStyle(
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
                    Text('Not a member ? '.tr(),style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Register now '.tr(), 
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