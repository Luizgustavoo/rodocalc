import 'package:flutter/material.dart';

class CustomIndicatorCard extends StatelessWidget {
  final String name;
  final String phone;
  final String status;
  final String date;

  const CustomIndicatorCard({
    super.key,
    required this.name,
    required this.phone,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              const TextSpan(
                text: 'NOME: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: name.toUpperCase()),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'TELEFONE: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: phone.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'STATUS: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: status.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'DATA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: date.toUpperCase()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
