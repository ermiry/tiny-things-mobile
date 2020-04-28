import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  
  final String labelText;
  final TextEditingController controller;

  CustomTextField({@required this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        labelText: labelText
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      // validator: (value) {
      //   if (value.isEmpty) return 'Name field is required!';
      //   return null;
      // },
    );
  }

}