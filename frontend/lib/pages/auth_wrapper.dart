import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/views/fill_create_acc_info.dart';
import 'package:frontend/pages/views/onboarding.dart';
import 'package:frontend/pages/widget_tree.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService authService = AuthService();
  User? _currentUser;
  String? _lastSignedOutUserId;
  int _queryKey = 0;

  Stream<DocumentSnapshot> _getUserStream(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots();
  }

  void _clearNavigationStack() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState?.canPop() ?? false) {
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    });
  }

  Widget _buildFillCreateAccInfo(User user) {
    _clearNavigationStack();
    return FillCreateAccInfo(key: ValueKey('fill_info_${user.uid}_$_queryKey'));
  }

  @override
  void initState() {
    super.initState();
    authService.authStateChanges.listen((user) {
      if (user == null) {
        if (_currentUser != null) {
          setState(() {
            _lastSignedOutUserId = _currentUser!.uid;
            _currentUser = null;
          });
        }
      } else {
        final wasSignedOut = _currentUser == null && _lastSignedOutUserId == user.uid;
        final isDifferentUser = _currentUser != null && _currentUser!.uid != user.uid;
        
        if (wasSignedOut || isDifferentUser) {
          setState(() {
            _queryKey++;
            _currentUser = user;
            _lastSignedOutUserId = null;
          });
        } else if (_currentUser == null) {
          setState(() {
            _currentUser = user;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Onboarding();
    }

    final user = _currentUser!;

    return StreamBuilder<DocumentSnapshot>(
      key: ValueKey('user_doc_${user.uid}_$_queryKey'),
      stream: _getUserStream(user.uid),
      builder: (context, docSnapshot) {
        if (!docSnapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final doc = docSnapshot.data!;
        
        if (!doc.exists) {
          return _buildFillCreateAccInfo(user);
        }

        final data = doc.data() as Map<String, dynamic>?;

        if (data == null || data.isEmpty) {
          return _buildFillCreateAccInfo(user);
        }

        return WidgetTree();
      },
    );
  }
}
