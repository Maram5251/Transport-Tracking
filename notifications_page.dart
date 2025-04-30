import 'package:flutter/material.dart';

class Notificationspage extends StatelessWidget {
  const Notificationspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text("Notifications", style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold),),
      ),
      backgroundColor: Colors.teal,
    );
  }
}