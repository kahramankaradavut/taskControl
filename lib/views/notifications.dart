import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_duty/design/app_colors.dart';
import 'package:on_duty/widgets/app_cards.dart';
import 'package:provider/provider.dart';

import '../states/states.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifications = FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Bildirimler")),
        body: StreamBuilder<QuerySnapshot>(
            stream: _notifications.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.data?.size == 0) {
                return Image.asset("assets/images/empty_notification.png");
              } else {
                return ListView(
                  children: snapshot.data!.docs.map((item) {
                    Map<String, dynamic> notification = item.data()! as Map<String, dynamic>;
                    Map<String, dynamic> _notification = {"uid": item.id, ...notification};
                    return NotificationCard(notification: _notification);
                  }).toList(),
                );
              }
            }),
      ),
    );
  }
}
