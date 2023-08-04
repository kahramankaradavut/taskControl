import 'package:flutter/material.dart';
import 'package:on_duty/design/app_colors.dart';
import 'package:on_duty/design/app_text.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                  width: 200,
                  child: Image.asset("assets/images/network.png")),
              SizedBox(height: 64,),
               Text("İnternete bağlı değilsiniz gibi görünüyor...",style: AppText.titleSemiBold,textAlign: TextAlign.center,),
               SizedBox(height: 32,),
               Text("İnternet bağlantınızı kontrol edip uygulamaya tekrar giriniz",style: AppText.titleSemiBold,textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    ));
  }
}
