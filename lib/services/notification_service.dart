import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:on_duty/storage/storage.dart';
import 'package:on_duty/widgets/app_alerts.dart';
import 'package:provider/provider.dart';

import '../states/states.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SecureStorage _secureStorage = SecureStorage();

  void connect(BuildContext context) async {
    await Firebase.initializeApp();
    _messaging.getToken().then((token) => _secureStorage.writeSecureData("fcm-token", token!));
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppAlerts.toast(message: message.notification!.title!);
      Provider.of<States>(context, listen: false).changeNewNotification(true);
    });
  }

  static Future<void> backgroundNotification(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  }

  void create(senderId, receiverId, taskId, title, isAdmin) async {
    var url = Uri.parse("https://onduty-server.netlify.app/notification");
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var sendBody = {
      "title": title,
      "senderId": senderId,
      "receiverId": receiverId,
      "taskId": taskId,
      "isAdmin": isAdmin,
    };
    await http.post(url, body: jsonEncode(sendBody), headers: headers);
  }
}
