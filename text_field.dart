import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({super.key , required this.controller,required this.hintText,required this.obscureText});
  @override
  Widget build(BuildContext context) {
    return Padding ( 
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 238, 88),
                  width: 5,
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 56, 142, 60),
                    width: 10,
                  )
                ),
                fillColor: Color.fromARGB(255, 255, 215, 64),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: Color.fromARGB(255, 10, 45, 159))
              ),
            ),
            );
  }
}