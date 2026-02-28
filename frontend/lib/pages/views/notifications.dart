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
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = getNotifications();
  }

  Future<void> markAllAsRead() async {}

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final getNotifications = functions.httpsCallable("getNotifications");
    try {
      final response = await getNotifications.call({});
      final List<dynamic> responseResult = response.data["data"];
      return responseResult
          .map((notification) => Map<String, dynamic>.from(notification))
          .toList();
    } on FirebaseFunctionsException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      rethrow;
    } catch (err) {
      print('Unknown error: $err');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          const Header(
            title: "Notifications",
            icon: Icons.notifications,
            iconColor: Colors.black,
            isShowBackButton: false,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    style: ElevatedButtonStyle.elevatedButtonStyle,
                    onPressed: () => markAllAsRead(),
                    child: const Text(
                      "Mark All As Read",
                      style: ElevatedButtonStyle.elevatedButtonTextStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButtonStyle.elevatedButtonStyle,
                    onPressed: () => markAllAsRead(),
                    child: const Row(
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading Notifications"),
                        SizedBox(height: 5.0),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No notifications found"),
                  );
                }

                final notifications = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF267A3D),
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        title: Text(notification['title'] ?? 'No Title'),
                        subtitle: Text(notification['message'] ?? 'No Content'),
                        trailing: Text(
                          notification['timestamp'] != null
                              ? notification['timestamp'].toString()
                              : '',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}