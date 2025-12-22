import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiagnosticChatPage extends ConsumerWidget {


  const DiagnosticChatPage({super.key, required this.deviceId});

  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text('Diagnostic Chat Page for Device ID: $deviceId'),
      ),  
    );
  }
}