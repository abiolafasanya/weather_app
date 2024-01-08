import 'package:flutter/material.dart';

class ForcastCard extends StatelessWidget {
  final String temperature;
  final String time;
  final IconData icon;

  const ForcastCard({super.key, required this.time, required this.temperature, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Column(
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
             const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                temperature,
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
