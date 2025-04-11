import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color titleColor;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.titleColor = const Color(0xFFFF6B00)});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Get.find<HomeController>().verificarExibicaoImagem();
          Get.back();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter-Regular',
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 90),
          child: Text(
            '',
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              color: titleColor,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
