import 'package:flutter/material.dart';

Future<T?>showFormDialog<T>({
  required BuildContext context,
  required Widget child
}){
  return showDialog<T>(
    barrierColor: Colors.black54,
    barrierDismissible: true,
    context: context, 
    builder: (_){
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 350,
            padding: EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      );
    }
  );
}