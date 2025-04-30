import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';


  class Languages extends StatefulWidget {
     const Languages({super.key});
  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings'.tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Account.changeLanguageAccountToFrench(context);
              },
              child: const Text('Switch to French'),
            ),
            ElevatedButton(
              onPressed: () {
                Account.changeLanguageAccountToEnglish(context);
              },
              child: const Text('Switch to English'),
            ),
          ],
        ),
      ),
    );
  }
}