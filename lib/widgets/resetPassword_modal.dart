import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:on_duty/design/app_text.dart';
import 'package:on_duty/widgets/app_alerts.dart';
import 'package:on_duty/widgets/app_form.dart';

import '../design/app_colors.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({Key? key}) : super(key: key);

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Şifremi Değiştir",
        style: AppText.titleSemiBold,
      ),
      content: SizedBox(
        height: 180,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Şifre değiştirmek için lütfen\ne-mailinizi girin size bir mail yollayacağız",
                style: AppText.label,
              ),
              const SizedBox(height: 20),
              AppForm.appTextFormField(
                label: "E-mail",
                hint: "isminiz@domain.com",
                controller: _emailController,
                isEmail: true,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 24, bottom: 24),
      actions: [
        OutlinedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });
              Future.delayed(const Duration(seconds: 2), () => {
                setState(() {
                  isLoading = false;
                }),
                passwordReset(),
                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    padding: const EdgeInsets.all(0),
                    duration: const Duration(milliseconds: 1500),
                    backgroundColor: AppColors.lightSecondary,
                    content: AppAlerts.info("Size bir bağlantı gönderdik. Mail kutunuzu kontrol ediniz"),
                  ),
                ),
              });
            }
          },
          child: isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.lightPrimary,
                  strokeWidth: 3,
                ),
              )
              : const Text("Gönder"),
          /*child: Text(
            "Gönder",
            style: AppText.labelSemiBold,
          ),*/
        )
      ],
    );
  }

  Future passwordReset() async {
    await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
