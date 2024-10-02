import 'package:flutter/material.dart';

class CustomHomeCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const CustomHomeCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 35,
                  width: 35,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
