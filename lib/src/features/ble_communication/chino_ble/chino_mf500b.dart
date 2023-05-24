import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'chino_device.dart';

@immutable
class ChinoMF500B extends ChinoDevice {
  const ChinoMF500B({
    required super.temperature,
    required super.switchStatus,
    required super.batteryStatus,
    required super.service,
    required super.characteristicTemperatureAndSwitch,
    required super.characteristicBatteryStatus,
  });

  factory ChinoMF500B.create({
    required BluetoothService service,
  }) {
    final cTemperatureAndSwitch = service.characteristics.firstWhere(
      (BluetoothCharacteristic? characteristic) =>
          characteristic != null &&
          characteristic.uuid == characteristicUuidTemperatureAndSwitch,
    );
    final cBatteryStatus = service.characteristics.firstWhere(
      (BluetoothCharacteristic? characteristic) =>
          characteristic != null &&
          characteristic.uuid == characteristicUuidBatteryStatus,
    );

    return ChinoMF500B(
      temperature: 0.00,
      switchStatus: 0x0000,
      batteryStatus: ChinoBatteryStatus.empty,
      service: service,
      characteristicTemperatureAndSwitch: cTemperatureAndSwitch,
      characteristicBatteryStatus: cBatteryStatus,
    );
  }

  // MF500B common name
  static const String commonModelName = 'MF500B';
  // CHINO MF500B over BLE Service UUID
  static final Guid serviceUuid = Guid('05fd8c58-9d23-11e7-abc4-cec278b6b50a');
  // CHINO MF500B Temperature+Switch status Read/Notify UUID
  static final Guid characteristicUuidTemperatureAndSwitch =
      Guid('05fd8f5a-9d23-11e7-abc4-cec278b6b50a');
  // CHINO MF500B Battery status Read UUID
  static final Guid characteristicUuidBatteryStatus =
      Guid('05fd9162-9d23-11e7-abc4-cec278b6b50a');

  @override
  ChinoMF500B copyWith({
    double? temperature,
    int? switchStatus,
    ChinoBatteryStatus? batteryStatus,
  }) {
    return ChinoMF500B(
      temperature: temperature ?? this.temperature,
      switchStatus: switchStatus ?? this.switchStatus,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      service: super.service,
      characteristicTemperatureAndSwitch:
          super.characteristicTemperatureAndSwitch,
      characteristicBatteryStatus: super.characteristicBatteryStatus,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [temperature, switchStatus, batteryStatus];

  @override
  ChinoMF500B updateTemperatureAndSwitch({
    required List<int> values,
  }) {
    final v = ChinoTemperatureAndSwitch.create(values: values);
    return copyWith(
      temperature: v.temperature,
      switchStatus: v.switchStatus,
    );
  }

  @override
  ChinoMF500B updateBatteryStatus({
    required List<int> values,
  }) {
    final batteryStatus = ChinoBatteryStatus.fromValues(values);
    return copyWith(
      batteryStatus: batteryStatus,
    );
  }
}
