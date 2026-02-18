
import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/pages/views/dashboard.dart';
import 'package:frontend/pages/views/notifications.dart';
import 'package:frontend/pages/views/take_picture.dart';
import 'package:frontend/pages/views/weekly_summary.dart';
import 'package:frontend/widgets/bottom_navbar.dart';


List<Widget> pages = [
  Dashboard(),
  Dashboard(),
  TakePicture(isTakingFoodPicture: true),
  WeeklySummary(),
  Notifications()
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