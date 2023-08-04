import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../design/app_colors.dart';
import '../design/app_text.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../states/states.dart';
import '../utils/helpers.dart';
import '../widgets/app_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  final _tasksStream =
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
            fromFirestore: TaskModel.fromFirestore,
            toFirestore: (TaskModel task, options) => task.toFirestore(),
          );
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _searchController = TextEditingController();

  late bool isAdmin;
  String _searchQuery = "";
  String _displayName = "";

  @override
  void initState() {
    super.initState();
    isAdmin = false;
    setDisplayName();
    setIsAdmin();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(isAdmin) Navigator.pushNamed(context, "notifications_screen");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNewNotification = Provider.of<States>(context).newNotification;
    Function changeNewNotification = Provider.of<States>(context).changeNewNotification;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Ana Sayfa"),
          actions: [
            if (isAdmin)
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  IconButton(
                    splashRadius: 24,
                    onPressed: () => {
                      Navigator.pushNamed(context, "notifications_screen"),
                      changeNewNotification(false),
                    },
                    icon: const Icon(Iconsax.notification),
                  ),
                  if(isNewNotification) Positioned(
                    top: 16,
                    right: 14,
                    child: Container(
                      height: 9,
                      width: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        border: Border.all(width: 1, color: AppColors.lightSecondary),
                      ),
                    ),
                  )
                ],
              ),
            IconButton(
              splashRadius: 24,
              onPressed: () => showMessageLogOut(context),
              icon: const Icon(FluentIcons.arrow_exit_20_regular),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Hoş geldin, ", style: AppText.labelSemiBold),
                    Text(
                      Helpers.titleCase(_displayName),
                      style: AppText.label,
                    ),
                  ],
                ),
                Text(
                  DateFormat.MMMMEEEEd("tr").format(DateTime.now()),
                  style: AppText.labelSemiBold,
                )
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              thickness: 1,
              color: AppColors.lightPrimary.withOpacity(.16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _searchController,
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  FluentIcons.search_24_filled,
                  color: AppColors.lightPrimary,
                ),
                hintText: "Görev Ara...",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightInfo),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightPrimary),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isAdmin ? "Atanan Görevler" : "Görevleriniz",
              style: AppText.titleSemiBold,
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot<TaskModel>>(
                stream: _tasksStream
                    .where('user.uid',
                        isEqualTo: isAdmin ? null : _auth.currentUser?.uid)
                    .where('isCompleted', isEqualTo: false)
                    .orderBy('importance', descending: false)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.data?.size == 0) {
                    return Image.asset("assets/images/not_found.png");
                  } else {
                    List tasks = snapshot.data!.docs.map((doc) {
                      TaskModel taskData = doc.data() as TaskModel;
                      taskData.uid = doc.id;
                      return taskData;
                    }).toList();

                    tasks = tasks
                        .where((s) => s.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                    if (tasks.isEmpty) {
                      return Image.asset("assets/images/list_empty.png");
                    }

                    return Column(
                      children: tasks.map((task) {
                        return Column(
                          children: [
                            AppCards.taskCard(
                              task: task,
                              context: context,
                              itemBuilder: (context) => [
                                if (isAdmin)
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          FluentIcons.edit_24_regular,
                                          color: AppColors.lightPrimary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Düzenle",
                                          style: AppText.contextSemiBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (isAdmin)
                                  PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          FluentIcons.delete_24_regular,
                                          color: AppColors.lightPrimary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Sil",
                                          style: AppText.contextSemiBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!isAdmin)
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          FluentIcons.checkmark_24_regular,
                                          color: AppColors.lightPrimary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Tamamla",
                                          style: AppText.contextSemiBold,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    );
                  }
                }),
          ],
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "new_task_screen"),
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );


  }

  void setDisplayName() {
    setState(() {
      _displayName = _auth.currentUser!.displayName.toString();
    });
  }

  void setIsAdmin() async {
    final docSnap = await _users
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, options) => user.toFirestore(),
        )
        .doc(_auth.currentUser!.uid)
        .get();

    final currentUser = docSnap.data();

    setState(() {
      isAdmin = (currentUser?.isAdmin ?? false);
    });
  }

  Future<UserModel?> getUser(String id) async {
    final docSnap = await _users
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, options) => user.toFirestore(),
        )
        .doc(id)
        .get();

    return docSnap.data();
  }

  void logOut() {
    _auth.signOut().then((value) => {
          Navigator.pushReplacementNamed(context, 'login_screen'),
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showMessageLogOut(context) async {
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
              onPressed: (){
                Navigator.pop(context);
                logOut();
              },
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

}

