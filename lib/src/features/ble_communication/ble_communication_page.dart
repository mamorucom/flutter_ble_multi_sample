import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BleCommunicationPage extends HookConsumerWidget {
  const BleCommunicationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE複数台接続'),
      ),
      body: Container(),
    );
  }
}
