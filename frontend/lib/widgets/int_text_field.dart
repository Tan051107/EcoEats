import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/constants.dart';

Widget IntTextField({
    required TextEditingController controller,
    required String label,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: subtitleText,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: fieldDecoration.copyWith(
            suffixText: unit
          ),
          validator:(value) {
            if(value == null || value.isEmpty){
              return "Required";
            }
            if(int.tryParse(value) == null){
                return "Invalid";
              }
            return null;
          } ,
        )
      ],
    );
  }