import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_duty/models/task.dart';
import 'package:on_duty/views/edit_task.dart';

import '../design/app_colors.dart';
import '../design/app_text.dart';
import '../services/notification_service.dart';
import 'app_alerts.dart';

class AppCards {
  final _auth = FirebaseAuth.instance;
  static final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('tasks');

  void completeTask(TaskModel task, context) {
    NotificationService notificationService = NotificationService();

    TaskModel newTask = TaskModel(
      uid: task.uid,
      title: task.title,
      description: task.description,
      importance: task.importance,
      user: task.user,
      isCompleted: true,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );

    _tasks
        .withConverter(
          fromFirestore: TaskModel.fromFirestore,
          toFirestore: (TaskModel task, options) => task.toFirestore(),
        )
        .doc(task.uid)
        .update(newTask.toJson())
        .then((value) => {
              Navigator.pop(context),
              AppAlerts.toast(message: "Yuppi! Görevi tamamladın."),
              notificationService.create(_auth.currentUser?.uid, "9qATBkfTqbba4y72INDl7SASmcu1", newTask.uid, "Görev tamamlandı!", false),
            });
  }

  static void deleteTask(id, context) async {
    _tasks.doc(id).delete().then((value) => {
          Navigator.pop(context),
          AppAlerts.toast(message: "Görev başarıyla silindi."),
        });
  }

  static void showMessageDeleteTask(id, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Görev Sil",
            textAlign: TextAlign.center,
            style: AppText.titleSemiBold,
          ),
          content: const Text(
            "Seçtiğiniz görevi silmek üzereseniz, emin misiniz?\nBu işlem geri alınamaz.",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightError),
              ),
              child: const Text(
                "Evet, sil",
                style: TextStyle(color: AppColors.lightError),
              ),
              onPressed: () => deleteTask(id, context),
            ),
            ElevatedButton(
              child: const Text("Hayır, silme"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
  static void showMessageLogOut(id, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Çıkış Yap",
            textAlign: TextAlign.center,
            style: AppText.titleSemiBold,
          ),
          content: const Text(
            "Çıkış yapmak istediğinizden emin misiniz?",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightError),
              ),
              child: const Text(
                "Evet, çıkış yap",
                style: TextStyle(color: AppColors.lightError),
              ),
              onPressed: () => deleteTask(id, context),
            ),
            ElevatedButton(
              child: const Text("Hayır, devam et"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  static void showMessageCompleteTask(task, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Görev Tamamla",
            textAlign: TextAlign.center,
            style: AppText.titleSemiBold,
          ),
          content: const Text(
            "Seçtiğiniz görevin tamamlandığından, emin misiniz? Admin bu işlemden haberdar olacaktır.",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: [
            ElevatedButton(
              child: const Text("Evet, tamamla"),
              onPressed: () => AppCards().completeTask(task, context),
            ),
            OutlinedButton(
              child: const Text("Hayır, kapat"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static Widget taskCard({
    required TaskModel task,
    required BuildContext context,
    required List<PopupMenuEntry<int>> Function(BuildContext) itemBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: setImportanceColor(task.importance!),
                    radius: 9,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.7,
                    ),
                    child: Text(
                      task.title!,
                      // overflow: TextOverflow.ellipsis,
                      style: AppText.contextSemiBold,
                    ),
                  )
                ],
              ),
              PopupMenuButton<int>(
                padding: const EdgeInsets.all(8),
                onSelected: (index) {
                  switch (index) {
                    case 1:
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      );
                      break;
                    case 2:
                      showMessageDeleteTask(task.uid, context);
                      break;
                    case 3:
                      showMessageCompleteTask(task, context);
                  }
                },
                itemBuilder: itemBuilder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(color: AppColors.lightPrimary),
                ),
                splashRadius: 20,
                icon: const Icon(
                  FluentIcons.more_vertical_24_regular,
                  color: AppColors.lightBlack,
                ),
                offset: const Offset(0, 44),
                color: AppColors.lightSecondary,
                elevation: 0,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Text(task.description!, style: AppText.context),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FluentIcons.calendar_ltr_24_regular,
                      color: AppColors.lightBlack,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      // task.dueDate.toString(),
                      DateFormat.yMd("tr").format(task.dueDate!.toDate()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.4,
                        color: AppColors.lightBlack,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                margin: const EdgeInsets.only(right: 16),
                constraints: const BoxConstraints(maxWidth: 130),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FluentIcons.person_24_regular,
                      color: AppColors.lightBlack,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${task.user?.firstName.toString()} ${task.user?.lastName.toString()}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                          color: AppColors.lightBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget processCard({
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: AppColors.lightGrey,
        shadowColor: AppColors.lightBlack,
        child: InkWell(
          onTap: onTap,
          child: Card(
            color: AppColors.lightGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 90,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24, color: AppColors.lightPrimary),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.lightPrimary,
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color setImportanceColor(int level) {
  switch (level) {
    case 1:
      return AppColors.lightError;
    case 2:
      return AppColors.lightWarning;
    default:
      return AppColors.lightSuccess;
  }
}

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key, required this.notification}) : super(key: key);
  final Map<String, dynamic> notification;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final _notifications = FirebaseFirestore.instance.collection('notifications');
  bool _isExpanded = false;

  void makeRead() async {
    Future.delayed(const Duration(seconds: 3), () => {
      _notifications.doc(widget.notification["uid"]).update({"isRead": true}),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: ExpansionPanelList(
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
          if(_isExpanded) {
            makeRead();
          }
        },
        children: <ExpansionPanel>[
          ExpansionPanel(
            backgroundColor: widget.notification["isRead"] ? AppColors.lightSecondary : AppColors.lightGrey,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  leading: const Icon(Icons.task_alt_outlined),
                  title: Text(widget.notification["title"]),
                  subtitle: Text("${widget.notification["senderUser"]["firstName"]} ${widget.notification["senderUser"]["lastName"]}"),
                );
              },
              body: Container(
                // color: Colors.red,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification["description"],
                      style: TextStyle(color: ThemeData.light().textTheme.bodySmall?.color),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "${DateFormat.yMd("tr").format(widget.notification["createdAt"].toDate())} tarihinde görev tamamlanmıştır",
                      style: TextStyle(color: ThemeData.light().textTheme.bodySmall?.color?.withOpacity(0.3)),
                    )
                  ],
                ),
              ),
              isExpanded: _isExpanded,
              canTapOnHeader: true,
          ),
        ],
      ),
    );
  }
}
