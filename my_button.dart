import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final Function()? ontap;
  final String text;
  const Mybutton({super.key, required this.ontap, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: ontap,
    child : Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(color: Colors.green, 
      borderRadius: BorderRadius.circular(10)),
       child: Center(child: Text(text, style: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16
       ),),),
    ));
  }
}