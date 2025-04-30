import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RoleField extends StatefulWidget {
  final TextEditingController controller;

  const RoleField({super.key, required this.controller});

  @override
  State<RoleField> createState() => _RoleFieldState();
}

class _RoleFieldState extends State<RoleField> {
  String rolename = "Select Role".tr();
  List<String> roles = ["Select Role".tr(), "Administrator".tr(), "Passenger".tr(), "Transport Agent".tr(), "Taxi Driver".tr()]; 

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: rolename, 
      builder: (FormFieldState<String> state) {
        return Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Role".tr(),
                border: OutlineInputBorder(),
                errorText: state.hasError ? state.errorText : null,
              ),
              validator: (value) {
                 if (value == "Select Role".tr()) {
                  return 'Please select a Role'.tr();
                 }
                 return null;
               },
              onChanged: (String? newValue) {
                setState(() {
                  rolename = newValue!;
                  widget.controller.text = rolename;
                  state.didChange(rolename); 
                });
              },
              value: rolename,
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
