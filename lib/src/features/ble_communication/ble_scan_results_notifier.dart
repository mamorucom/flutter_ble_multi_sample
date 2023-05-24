import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chino_ble/chino_ir_tb.dart';
import 'chino_ble/chino_mf500b.dart';

///
/// Start and check the scan results and create a list of them.
///
final chinoBleScanResultsProvider =
    AsyncNotifierProvider<BleScanResultsNotifier, List<ScanResult>>(
  () => BleScanResultsNotifier([
    ChinoMF500B.commonModelName,
    ChinoIR_TB.commonModelName,
  ]),
);

///
/// Start and check the scan results and create a list of them.
//? おまけ-B高監で絞るならこんな感じ?
///
final bHighBleScanResultsProvider =
    AsyncNotifierProvider<BleScanResultsNotifier, List<ScanResult>>(
  () => BleScanResultsNotifier([
    'RWC-',
    'EWC-',
  ]),
);

///
/// Whether ble is scanning or not.
///
final isBleScanningProvider = StreamProvider<bool>((ref) {
  final bleScanResultsNotifier =
      ref.watch(chinoBleScanResultsProvider.notifier);
  return bleScanResultsNotifier.isScanning;
});

//? ここは機器固有の情報ないので使い回しできそうですね。
class BleScanResultsNotifier extends AsyncNotifier<List<ScanResult>> {
  BleScanResultsNotifier(this.fiteringNames);
  final List<String> fiteringNames;
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  Stream<bool> get isScanning => flutterBlue.isScanning;

  @override
  FutureOr<List<ScanResult>> build() {
    // checkScan();
    return [];
  }

  ///
  /// listen Bluetooth ON/OFF.
  ///
  Future<void> listen() async {
    flutterBlue.state.listen((state) async {
      if (state == BluetoothState.off) {
        //Alert user to turn on bluetooth.
        // final context = useContext();
        // showAlertDialog(
        //   context,
        //   title: 'BluetoothをONにしてください。',
        //   content: 'このアプリは装置と接続するためにBluetoothをONにする必要があります。',
        //   defaultActionText: 'OK',
        // );
      } else if (state == BluetoothState.on) {
        // if bluetooth is enabled then go ahead.
        await startAndCheckScan();
      }
    });
  }

  ///
  /// start and check Scanning BLE device.
  ///
  Future<void> startAndCheckScan() async {
    final isScanning = await flutterBlue.isScanning.first;
    // スキャン中なら実行しなくてよい。
    if (isScanning) {
      return;
    }

    checkScan();

    await flutterBlue.startScan();
  }

  ///
  /// check Scanning BLE device.
  ///
  void checkScan() {
    flutterBlue.scanResults.listen(monitoringScanResults);
  }

  ///
  /// Restore monitoring scan results filtered by Chino devices.
  ///
  void monitoringScanResults(List<ScanResult> scanResults) {
    //? もっと良い絞り込み方あると思います。
    //? local変数indexの気の利いた名前が思いつかず、被ってますすいません。
    for (final ScanResult scanResult in scanResults) {
      final index = fiteringNames.indexWhere(
          (fiteringName) => fiteringName.contains(scanResult.device.name));
      if (index != -1) {
        final index =
            state.valueOrNull?.indexWhere((e) => e.device == scanResult.device);
        state = AsyncValue.data([
          ...state.valueOrNull ?? [],
          if (index == -1) scanResult,
        ]);
      }
    }
  }
}
