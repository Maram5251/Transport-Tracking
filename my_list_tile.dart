import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text1;
  final String text2;
  const MyListTile({super.key,required this.icon,required this.text1,required this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: const EdgeInsets.only(left : 10.0),
      child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(text1 , style: TextStyle(
        color: Colors.white
      ),),
      subtitle: Text(text2),
    ));
  }
}