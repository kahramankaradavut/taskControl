import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../design/app_colors.dart';

class AppAlerts {
  static Widget success(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSuccess.withOpacity(0.16),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.lightSuccess),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              FluentIcons.checkmark_circle_24_regular,
              color: AppColors.lightSuccess,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 20,
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.lightSuccess,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget error(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightError.withOpacity(0.16),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.lightError),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              FluentIcons.dismiss_circle_24_regular,
              color: AppColors.lightError,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 20,
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.lightError,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget info(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightInfo.withOpacity(0.16),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.lightInfo),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              FluentIcons.info_24_regular,
              color: AppColors.lightInfo,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 20,
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.lightInfo,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget warning(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightWarning.withOpacity(0.16),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.lightWarning),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              FluentIcons.warning_24_regular,
              color: AppColors.lightWarning,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 20,
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.lightWarning,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> toast({
    required String message,
    Color backgroundColor = AppColors.lightPrimary,
    Color textColor = AppColors.lightSecondary,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor.withOpacity(.7),
      textColor: textColor,
      fontSize: 16,
    );
  }
}
