import 'dart:async';

import 'package:ble_multi_connection_sample/src/features/ble_communication/ble_scan_results_notifier.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chino_ble_peripheral.dart';
import 'chino_device.dart';

final chinoBlePeripheralProvider = StateNotifierProvider.autoDispose
    .family<ChinoBlePeripheralNotifier, AsyncValue<ChinoBlePeripheral>, String>(
  (ref, name) {
    return ChinoBlePeripheralNotifier(ref, name);
  },
);

class ChinoBlePeripheralNotifier
    extends StateNotifier<AsyncValue<ChinoBlePeripheral>> {
  ChinoBlePeripheralNotifier(
    this.ref,
    this.name,
  ) : super(AsyncData(ChinoBlePeripheral()));

  final Ref ref;
  final String name;

  ///
  /// Use case trying to connect ble device.
  ///
  Future<bool> connect() async {
    state = const AsyncLoading();

    final scanResults = ref.read(chinoBleScanResultsProvider).requireValue;
    final scanResult =
        scanResults.firstWhere((scanResult) => scanResult.device.name == name);
    final bleDevice = scanResult.device;

    try {
      await bleDevice.connect();
      final services = await bleDevice.discoverServices();

      final chinoDevice = ChinoDeviceFactory.create(
        bleDevice: bleDevice,
        services: services,
      );

      state = AsyncData(
        ChinoBlePeripheral(
          bleDevice: bleDevice,
          chinoDevice: chinoDevice,
          bleConnectionState: BleConnectionState.connected,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      // 接続失敗を返す
      return false;
    }

    // 接続成功を返す
    return true;
  }

  ///
  /// Use case trying to disconnect ble device.
  ///
  Future<bool> disconnect() async {
    if (state.valueOrNull?.bleDevice == null) {
      return false;
    }

    try {
      await state.requireValue.bleDevice!.disconnect();

      state = AsyncValue.data(ChinoBlePeripheral());
    } catch (e) {
      // 切断失敗を返す
      return false;
    }

    // 切断成功を返す
    return true;
  }

  ///
  /// start monitoring notifyValue and set notifyValue.
  ///
  Future<void> checkNotify() async {
    if (state.valueOrNull?.chinoDevice == null) {
      state = AsyncError('通信エラー', StackTrace.current);
      return;
    }

    state.requireValue.chinoDevice!.characteristicTemperatureAndSwitch.value
        .listen(_monitoringNotify);
    await state.requireValue.chinoDevice!.characteristicTemperatureAndSwitch
        .setNotifyValue(true);
  }

  ///
  /// Parse monitoring notify value and restore new ChinoDevice object.
  ///
  void _monitoringNotify(List<int> values) {
    if (state.valueOrNull?.chinoDevice == null) {
      state = AsyncError('通信エラー', StackTrace.current);
      return;
    }

    final newChinoDevice = state.requireValue.chinoDevice!
        .updateTemperatureAndSwitch(values: values);

    _newChinoDevice(newChinoDevice: newChinoDevice);
  }

  ///
  /// Get temperature and switchStatus value using read property.
  ///
  Future<void> readTemperatureAndSwitchByBleCommunication({
    List<int>? temperatureAndSwitchValues,
  }) async {
    if (state.valueOrNull?.chinoDevice == null) {
      state = AsyncError('通信エラー', StackTrace.current);
      return;
    }

    //? AsyncValue.guardはtry catchの代わりで非同期処理ないのExceptionをキャッチできます。
    final newAsync = await AsyncValue.guard<List<int>>(
      () async =>
          await state
              .requireValue.chinoDevice?.characteristicTemperatureAndSwitch
              .read() ??
          [],
    );

    if (newAsync.hasError) {
      if (newAsync.error is PlatformException) {
        final exception = newAsync.error! as PlatformException;
        state = AsyncError('通信エラー: ${exception.code}', StackTrace.current);
        return;
      }
    }

    final newChinoDevice = state.requireValue.chinoDevice!
        .updateTemperatureAndSwitch(values: newAsync.valueOrNull ?? []);

    _newChinoDevice(newChinoDevice: newChinoDevice);
  }

  ///
  /// Get batteryStatus value using read property.
  ///
  Future<void> readBatteryStatusByBleCommunication({
    List<int>? batteryStatusValues,
  }) async {
    if (state.valueOrNull?.chinoDevice == null) {
      state = AsyncError('通信エラー', StackTrace.current);
      return;
    }

    final newAsync = await AsyncValue.guard<List<int>>(
      () async =>
          await state.requireValue.chinoDevice?.characteristicBatteryStatus
              .read() ??
          [],
    );

    if (newAsync.hasError) {
      if (newAsync.error is PlatformException) {
        final exception = newAsync.error! as PlatformException;
        state = AsyncError('通信エラー: ${exception.code}', StackTrace.current);
        return;
      }
    }

    final newChinoDevice = state.requireValue.chinoDevice!
        .updateBatteryStatus(values: newAsync.valueOrNull ?? []);

    _newChinoDevice(newChinoDevice: newChinoDevice);
  }

  ///
  /// Create a new [ChinoDevice].
  ///
  void _newChinoDevice({required ChinoDevice newChinoDevice}) {
    final peripheral = state.requireValue.copyWith(
      chinoDevice: newChinoDevice,
    );

    if (!mounted) return;
    state = AsyncData(peripheral);
  }
}
