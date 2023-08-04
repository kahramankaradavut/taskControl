import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:on_duty/views/sign_up.dart';
import 'package:on_duty/widgets/app_form.dart';
import 'package:page_transition/page_transition.dart';

import '../design/app_colors.dart';
import '../design/app_text.dart';
import '../storage/storage.dart';
import '../widgets/app_alerts.dart';
import '../widgets/resetPassword_modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SecureStorage secureStorage = SecureStorage();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool isLoading = false;

  void onTapClickMe(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        child: const SignUpScreen(),
        duration: const Duration(milliseconds: 400),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    secureStorage.readSecureData('rememberMeEmail').then((value) => {
      _emailController.text = value ?? '',
      if(value != null) isChecked = true,
      if(mounted) setState(() {}),
    });
    secureStorage.readSecureData('rememberMePassword').then((value) => {
      _passwordController.text = value ?? '',
      if(value != null) isChecked = true,
      if(mounted) setState(() {}),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.all(24),
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset("assets/images/logo-onduty.png", height: 50),
            ),
            const SizedBox(height: 80),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Hoş Geldiniz", style: AppText.titleSemiBold),
                  const SizedBox(height: 8),
                  Text(
                    "Giriş yapmak için email & şifrenizi giriniz.",
                    style: AppText.context,
                  ),
                  const SizedBox(height: 32),
                  AppForm.appTextFormField(
                    label: "Email",
                    hint: "isminiz@domain.com",
                    controller: _emailController,
                    isEmail: true,
                  ),
                  const SizedBox(height: 24),
                  PasswordFieldWithVisibility(
                    showForgotPassword: true,
                    content: const ResetPasswordModal(),
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text("Beni Hatırla", style: AppText.label)
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: logIn,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.lightSecondary,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text("Giriş Yap"),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    children: [
                      Text(
                        "Hesabınız yok mu? Kaydolmak için ",
                        style: AppText.context,
                      ),
                      GestureDetector(
                        // onTap: () => onTapClickMe(context),
                        onTap: () => Navigator.pushNamed(context, "sign_up_screen"),
                        child: const Text(
                          "tıklayın",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: AppColors.lightPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTokenToDatabase(String token) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  void logIn() async {
    if(isChecked) {
      await secureStorage.writeSecureData('rememberMeEmail', _emailController.text);
      await secureStorage.writeSecureData('rememberMePassword', _passwordController.text);
    } else {
      await secureStorage.deleteSecureData('rememberMeEmail');
      await secureStorage.deleteSecureData('rememberMePassword');
    }

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).then((value) async => {
        await setupToken(),
        setState(() => isLoading = false),
        Navigator.pushReplacementNamed(context, 'home_screen'),
        AppAlerts.toast(message: "Başarıyla giriş yapıldı."),
      }).catchError((e) => {
        setState(() => isLoading = false),
        if (e.code == 'user-not-found') {
          AppAlerts.toast(message: "Kullanıcı bulunamadı."),
        } else if (e.code == 'wrong-password') {
          AppAlerts.toast(message: "Yanlış şifre."),
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              padding: const EdgeInsets.all(20),
              content: Text(e.toString()),
              duration: const Duration(milliseconds: 1500),
            ),
          ),
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
