import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  final TextEditingController controller;

  const CountryPage({super.key, required this.controller});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String countryname = "Select Country".tr();

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      
      validator: (value) {
        if (value == "Select Country") {
          return 'Please select a country';
        }
        return null;
      },
      initialValue: countryname, 
      builder: (FormFieldState<String> state) {
        return Column(
          children: [
            TextFormField(
              controller: widget.controller,
              readOnly: true, 
              decoration: InputDecoration(
                labelText: "Country",
                hintText: "Select Country",
                border: OutlineInputBorder(),
                errorText: state.hasError ? state.errorText : null,
              ),
              onTap: () {
                
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      countryname = country.name; 
                      widget.controller.text = countryname;
                      state.didChange(countryname); 
                    });
                  },
                );
              },
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
