import 'package:flutter/material.dart';
import 'package:frontend/pages/views/onboarding.dart';
import 'package:frontend/pages/widget_tree.dart';
import 'package:frontend/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.authStateChanges, 
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasData){
          return WidgetTree();
        }
        return Onboarding();
      }
    );
  }
}