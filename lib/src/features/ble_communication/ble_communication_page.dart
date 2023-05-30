//? part of ble_communication;のものと同一package扱い(同じファイル扱いみたいな)になります.
library ble_communication;

import 'package:ble_multi_connection_sample/src/features/ble_communication/ble_scan_results_notifier.dart';
import 'package:ble_multi_connection_sample/src/features/ble_communication/chino_ble/chino_ble_peripheral.dart';
import 'package:ble_multi_connection_sample/src/features/ble_communication/chino_ble/chino_ble_peripheral_notifier.dart';
import 'package:ble_multi_connection_sample/src/features/ble_communication/chino_ble/chino_device.dart';
import 'package:ble_multi_connection_sample/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';

part 'parts/xs_ble_communication_body.dart';

class BleCommunicationPage extends HookConsumerWidget {
  const BleCommunicationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE複数台接続サンプル'),
      ),
      body: const _BleCommunicationBody(),
    );
  }
}

class _BleCommunicationBody extends HookConsumerWidget {
  const _BleCommunicationBody();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? おまけ-layout 現職ではAdaptiveBuilder packageを使ってスマホとタブレットの
    // UIを出し分けてました。めんどいので、今回はXs(スマホ)だけ用意.

    return AdaptiveBuilder(
      xs: (_) => const _XsBleCommunicationBody(),
      sm: (_) => const _XsBleCommunicationBody(),
    );
  }
}
