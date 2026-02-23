import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/constants.dart';

Widget DecimalTextField({
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
            FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
          ],
          decoration: fieldDecoration.copyWith(
            suffixText: unit
          ),
          validator:(value) {
            if(value == null || value.isEmpty){
              return "Required";
            }
            if(double.tryParse(value) == null){
                return "Required";
              }
            return null;
          } ,
        )
      ],
    );
  }