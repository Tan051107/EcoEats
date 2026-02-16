import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/widgets/header.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<Map<String,dynamic>> notifications = [];
  bool isLoadingNotifications = true;

  Future <void>markAllAsRead()async{

  }

  Future<void>getNotifications()async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final getNotifications = functions.httpsCallable("getNotifications");
    try{
      final response = await getNotifications.call({});
      final List<dynamic> responseResult = response.data["data"];
      final List<Map<String,dynamic>> notificationsData = responseResult.map((notification)=>Map<String,dynamic>.from(notification)).toList();
      setState(() {
        notifications = notificationsData;
        isLoadingNotifications = false;
      });
    }
    on FirebaseFunctionsException catch (e){
      print('Firebase error: ${e.code} - ${e.message}');
    }
    catch(err){
      print('Unknown error: $err');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingNotifications
            ?Center(
            child: Column(
            children: [
              Text("Loading Recipes"),
              SizedBox(height: 5.0,),
              CircularProgressIndicator(),
            ], 
            ),
            )
            :notifications.isEmpty
            ?Center(
            child: Text("No recipes found"),
            )
            : Column(
        children: [
          Header(title: "Notifications" , icon: Icons.notifications, iconColor: Colors.black,isShowBackButton: false,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    style: ElevatedButtonStyle.elevatedButtonStyle,
                    onPressed: () => markAllAsRead(), 
                    child: Text(
                      "Mark All As Read",
                      style:ElevatedButtonStyle.elevatedButtonTextStyle,
                    )
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButtonStyle.elevatedButtonStyle,
                    onPressed: () => markAllAsRead(), 
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_outlined,
                          color: Color(0xFF267A3D),
                        ),
                        SizedBox(width: 2.0),
                        Text(
                          "Clear",
                          style: ElevatedButtonStyle.elevatedButtonTextStyle,
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}