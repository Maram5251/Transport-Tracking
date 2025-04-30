import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FormComponent extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final String hinttext;
  
  const FormComponent({super.key, required this.labeltext, required this.hinttext , required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  
    TextFormField(
            decoration:  InputDecoration(
              labelText: labeltext,
              hintText : 'Choose First Name '.tr(),
              border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value==null || value.isEmpty){
                return "You should fill the empty fields !".tr();
              }
              return null;
            },
            controller: controller,
          ));
  }
}