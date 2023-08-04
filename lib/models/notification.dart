import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_duty/models/user.dart';

class NotificationModel {
  String? uid;
  UserModel? senderUser;
  // UserModel? receiverUser;
  String? title;
  String? description;
  bool? isRead;
  Timestamp? createdAt;

  NotificationModel({
    this.uid,
    this.senderUser,
    // this.receiverUser,
    this.title,
    this.description,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    uid: json["uid"] as String,
    senderUser: UserModel.fromJson(json["senderUser"]),
    // receiverUser: UserModel.fromJson(json["receiverUser"]),
    title: json["title"] as String,
    description: json["description"] as String,
    isRead: json["isRead"] as bool,
    createdAt: json["createdAt"] as Timestamp,
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "senderUser": senderUser,
    // "receiverUser": receiverUser,
    "title": title,
    "description": description,
    "isRead": isRead,
    "createdAt": createdAt,
  };

  factory NotificationModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return NotificationModel(
      uid: data?['uid'],
      senderUser: UserModel.fromFirestore(snapshot, options),
      // receiverUser: data?['receiverUser'],
      title: data?['title'],
      description: data?['description'],
      isRead: data?['isRead'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (senderUser != null) "senderUser": senderUser?.toFirestore(),
      // if (receiverUser != null) "receiverUser": receiverUser?.toFirestore(),
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (isRead != null) "isRead": isRead,
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
