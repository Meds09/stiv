import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

class DiagnosticHeader extends StatelessWidget {
  final Device device;

  const DiagnosticHeader({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(device.image?? " ", width: 64, height: 64, errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 64,
                height: 64,
                color: Colors.grey[300],
                child: const Icon(Icons.devices, size: 40, color: Colors.white),
              );
            },),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(device.ip, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),),
    );
  }
}
