import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chino_device.dart';

part 'chino_ble_peripheral.freezed.dart';

///
/// [ChinoBlePeripheral] is mainly used as follows.
/// - Handles BLE connection.
/// - Handles BLE service UUID and characteristic UUID.
///
@freezed
class ChinoBlePeripheral with _$ChinoBlePeripheral {
  factory ChinoBlePeripheral({
    /// [BluetoothDevice] is used to connect to BLE device.
    BluetoothDevice? bleDevice,

    /// [ChinoDevice] communicates with BLE device and stores measurement
    /// results.
    ChinoDevice? chinoDevice,

    /// [BleConnectionState] stores connected/disconnected.
    BleConnectionState? bleConnectionState,
  }) = _ChinoBlePeripheral;
}
