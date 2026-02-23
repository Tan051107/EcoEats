
import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/pages/views/dashboard.dart';
import 'package:frontend/pages/views/favourites.dart';
import 'package:frontend/pages/views/notifications.dart';
import 'package:frontend/pages/views/pantry.dart';
import 'package:frontend/pages/views/profile.dart';
import 'package:frontend/pages/views/take_picture.dart';
import 'package:frontend/pages/views/weekly_summary.dart';
import 'package:frontend/widgets/bottom_navbar.dart';


List<Widget> pages = [
  Dashboard(),
  Pantry(),
  TakePicture(),
  WeeklySummary(),
  Notifications(),
  ProfilePage(),
  Favourites(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ValueListenableBuilder(
        valueListenable: selectedPageNotifier, 
        builder: (context,selectedPage,child){
          return pages.elementAt(selectedPage);
        }
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}