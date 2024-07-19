import 'package:flutter/material.dart';

class CustomHomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const CustomHomeCard(
      {super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter-Bold')),
          ],
        ),
      ),
    );
  }
}
