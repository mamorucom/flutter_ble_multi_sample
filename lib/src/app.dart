import 'package:ble_multi_connection_sample/src/features/ble_communication/ble_communication_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BleCommunicationPage();
  }
}
