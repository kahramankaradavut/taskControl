import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_duty/design/app_colors.dart';
import 'package:on_duty/widgets/app_form.dart';

import '../design/app_text.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../widgets/app_alerts.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key, this.task}) : super(key: key);

  final TaskModel? task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final CollectionReference _tasks = FirebaseFirestore.instance.collection('tasks');
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  // late TextEditingController _dueDateController;

  List<UserModel> users = [];
  UserModel selectedUser = UserModel();

  void getUsers() async {
    final docSnap = await _users.withConverter(
      fromFirestore: UserModel.fromFirestore,
      toFirestore: (UserModel user, options) => user.toFirestore(),
    ).get();

    final data = docSnap.docs.where((doc) => doc.id != _auth.currentUser?.uid).toList();
    setState(() {
      users = data.map((doc) {
        UserModel userData = doc.data();
        userData.uid = doc.id;
        return userData;
      }).toList();
      selectedUser = users.where((e) => e.uid == widget.task?.user?.uid).toList()[0];
    });
  }

  late int? importance;

  void editTask() {
    TaskModel newTask = TaskModel(
      uid: widget.task?.uid,
      title: _titleController.text,
      description: _descriptionController.text,
      importance: importance,
      user: selectedUser,
      isCompleted: widget.task?.isCompleted,
      // dueDate: _dueDateController.text,
      dueDate: Timestamp.fromDate(_dateTime!),
      createdAt: widget.task?.createdAt,
    );

    _tasks.withConverter(
      fromFirestore: TaskModel.fromFirestore,
      toFirestore: (TaskModel task, options) => task.toFirestore(),
    ).doc(widget.task?.uid).update(newTask.toJson()).then((value) => {
      Navigator.pop(context),
      AppAlerts.toast(message: "Görev başarıyla güncellendi."),
    });
  }
  DateTime? _dateTime;
  @override
  void initState() {
    super.initState();
    getUsers();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
    // _dueDateController = TextEditingController(text: widget.task?.dueDate);
    importance = widget.task?.importance!;
    _dateTime = widget.task?.dueDate?.toDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Görev Düzenle"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              AppForm.appTextFormField(
                label: "Başlık",
                hint: "Görevi tanımlayınız",
                controller: _titleController,
              ),
              const SizedBox(height: 24),
              AppForm.appTextFormField(
                label: "İçerik",
                hint: "Görevi özetleyiniz",
                controller: _descriptionController,
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Son Tarih', style: AppText.labelSemiBold),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => showDatePicker(
                              context: context,
                              initialDate: _dateTime!,
                              firstDate:
                              DateTime.now().subtract(Duration(days: 0)),
                              lastDate: DateTime(2999),
                            ).then((date) => setState(() {
                              _dateTime = date!;
                            })),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: AppColors.lightPrimary)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(

                                         DateFormat.yMd("tr")
                                        .format(_dateTime!),
                                    style: AppText.context,
                                  ),
                                  Icon(
                                    FluentIcons.calendar_ltr_24_regular,
                                    color: AppColors.lightPrimary,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Görevli Personel", style: AppText.labelSemiBold),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.lightPrimary),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FluentIcons.person_24_regular,
                                color: AppColors.lightPrimary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                flex: 3,
                                child: DropdownButton(
                                  underline: Container(),
                                  value: selectedUser,
                                  isExpanded: true,
                                  icon: const Icon(
                                    FluentIcons.chevron_down_24_regular,
                                    color: AppColors.lightPrimary,
                                  ),
                                  items: users.map((user) {
                                    return DropdownMenuItem<UserModel>(
                                      value: user,
                                      child: Text("${user.firstName!} ${user.lastName!}"),
                                    );
                                  }).toList(),
                                  onChanged: (UserModel? user) {
                                    setState(() {
                                      selectedUser = user!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Görevin Aciliyeti",
                    style: AppText.labelSemiBold,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            importance = 1;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.lightError,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 2,
                              color: importance == 1
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            importance = 2;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.lightWarning,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 2,
                              color: importance == 2
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            importance = 3;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.lightSuccess,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 2,
                              color: importance == 3
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(FluentIcons.save_24_regular),
                  onPressed: editTask,
                  label: const Text("Değişikilikleri Kaydet"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
