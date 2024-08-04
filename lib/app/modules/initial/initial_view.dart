import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:rodocalc/app/data/controllers/initial_controller.dart';

class InitialView extends GetView<InitialController> {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = controller.verifyAuth();
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(route);
      });
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                'assets/images/rodocalc.riv',
              ),
            ),
            SizedBox(height: 18.0),
            CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
