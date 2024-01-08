import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final String value;
  final IconData icon;
  const InfoCard(
      {super.key, required this.text, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
