import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/views/fill_create_acc_info.dart';
import 'package:frontend/pages/views/onboarding.dart';
import 'package:frontend/pages/widget_tree.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        if(!snapshot.hasData){
          return Onboarding();
        }
        
        User user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get(), 
          builder: (context,userSnapshot){
            if(userSnapshot.connectionState == ConnectionState.waiting){
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if(!userSnapshot.data!.exists){
              return FillCreateAccInfo();
            }

            return WidgetTree();
          }
        );
      }
    );
  }
}