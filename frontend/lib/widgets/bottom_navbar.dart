import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier, 
      builder: (context,selectedPage,child){
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color.fromARGB(255, 194, 191, 191),
                width: 2.0
              )
            )
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              height:70.0,
              backgroundColor: Colors.white,
              indicatorColor: lightGreen,
              labelTextStyle: WidgetStateProperty.resolveWith((states){
                if(states.contains(WidgetState.selected)){
                  return TextStyle(
                    color: normalGreen
                  );
                }
                return TextStyle(
                  color: Colors.black
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states){
                if(states.contains(WidgetState.selected)){
                  return IconThemeData(
                    color: normalGreen,
                  );
                }
                return IconThemeData(
                  color: gray
                );
              })
            ), 
            child: NavigationBar(
              destinations:[
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 25.0
                  ), 
                  label: "Home"
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.shelves,
                    size: 30.0
                  ), 
                  label: "Shelf"
                ),
                NavigationDestination(
                  icon: Transform.translate(
                    offset: Offset(0,-15),
                    child:Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: normalGreen,
                        shape: BoxShape.circle
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                  ), 
                  label: ""),
                NavigationDestination(
                  icon: Icon(
                    Icons.bar_chart_outlined,
                    size: 30.0,
                  ), 
                  label: "Summary"),
                NavigationDestination(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    size: 30.0
                  ), 
                  label: "Alerts"
                )
              ],
              onDestinationSelected: (int value){
                selectedPageNotifier.value = value;
              },
              selectedIndex: selectedPage,
            ),
          )
        );
      }
    );
  }
}