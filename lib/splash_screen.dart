import 'dart:developer';

import 'package:agenda_pemprov_kalteng/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    cekPermission();
    Future.delayed(const Duration(seconds: 2))
        .then((val) => Get.to(() => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/app_logo.jpg', scale: 3),
            const Text("Agenda Pemprov Kalteng"),
            const SizedBox(height: 10),
            const CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }

  void cekPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.camera,
    ].request();
    log(statuses.toString());
  }
}
