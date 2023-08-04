import 'package:flutter/material.dart';
import 'package:on_duty/views/network_error.dart';

import '../views/edit_task.dart';
import '../views/home.dart';
import '../views/login.dart';
import '../views/new_task.dart';
import '../views/notifications.dart';
import '../views/sign_up.dart';

/*Map<String, Widget Function(BuildContext)> routes = {
  "login_screen": (context) => const LoginScreen(),
  "sign_up_screen": (context) => const SignUpScreen(),
  "home_screen": (context) => const HomeScreen(),
  "notifications_screen": (context) => const NotificationsScreen(),
  "new_task_screen": (context) => const NewTaskScreen(),
  "edit_task_screen": (context) => const EditTaskScreen(),
};*/

Map<String, Widget> _routes = {
  "login_screen": const LoginScreen(),
  "sign_up_screen": const SignUpScreen(),
  "home_screen": const HomeScreen(),
  "notifications_screen": const NotificationsScreen(),
  "new_task_screen": const NewTaskScreen(),
  "edit_task_screen": const EditTaskScreen(),
  "network_error_screen": const NetworkErrorScreen(),
};

Route routeTo(String route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _routes[route]!,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      /*const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );*/

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  );
}
