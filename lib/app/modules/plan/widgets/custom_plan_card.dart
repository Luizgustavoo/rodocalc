import 'package:flutter/material.dart';

class CustomPlanCard extends StatelessWidget {
  final String? name;
  final String? description;
  final String? price;

  final VoidCallback onPressed;

  const CustomPlanCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter-Black',
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Inter-Regular'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      price!,
                      style: const TextStyle(
                        fontFamily: 'Inter-Black',
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Valor por licença',
                      style: TextStyle(
                        fontFamily: 'Inter-Regular',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xFFFF6B00),
                        Color.fromARGB(127, 221, 101, 15)
                      ]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'SELECIONAR',
                        style: TextStyle(
                            fontFamily: 'Inter-Bold', color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
