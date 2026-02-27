import 'package:flutter/material.dart';

Future<T?>showFormDialog<T>({
  required BuildContext context,
  required Widget child
}){
  return showDialog<T>(
    barrierColor: Colors.black54,
    barrierDismissible: true,
    context: context, 
    builder: (BuildContext dialogContext){
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(dialogContext).size.width * 0.9,
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          )
        ),
      );
    }
  );
}