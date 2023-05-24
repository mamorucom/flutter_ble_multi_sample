import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'chino_device.dart';

@immutable
// ignore: camel_case_types
class ChinoIR_TB extends ChinoDevice {
  const ChinoIR_TB({
    required super.temperature,
    required super.switchStatus,
    required super.batteryStatus,
    required super.service,
    required super.characteristicTemperatureAndSwitch,
    required super.characteristicBatteryStatus,
  });

  factory ChinoIR_TB.create({required BluetoothService service}) {
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

    return ChinoIR_TB(
      temperature: 0.00,
      switchStatus: 0x0000,
      batteryStatus: ChinoBatteryStatus.empty,
      service: service,
      characteristicTemperatureAndSwitch: cTemperatureAndSwitch,
      characteristicBatteryStatus: cBatteryStatus,
    );
  }

  // IR-TB common name
  static const String commonModelName = 'IR-TB';
  // CHINO IR-TB over BLE Service UUID
  static final Guid serviceUuid = Guid('462026f6-cfe1-11e7-abc4-cec278b6b50a');
  // CHINO IR-TB Temperature+Switch status Read/Notify UUID
  static final Guid characteristicUuidTemperatureAndSwitch =
      Guid('46202b74-cfe1-11e7-abc4-cec278b6b50a');
  // CHINO IR-TB Battery status Read UUID
  static final Guid characteristicUuidBatteryStatus =
      Guid('46202f8e-cfe1-11e7-abc4-cec278b6b50a');

  @override
  ChinoIR_TB copyWith({
    double? temperature,
    int? switchStatus,
    ChinoBatteryStatus? batteryStatus,
  }) {
    return ChinoIR_TB(
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
  ChinoIR_TB updateTemperatureAndSwitch({
    required List<int> values,
  }) {
    final v = ChinoTemperatureAndSwitch.create(values: values);
    return copyWith(
      temperature: v.temperature,
      switchStatus: v.switchStatus,
    );
  }

  @override
  ChinoIR_TB updateBatteryStatus({
    required List<int> values,
  }) {
    final batteryStatus = ChinoBatteryStatus.fromValues(values);
    return copyWith(
      batteryStatus: batteryStatus,
    );
  }
}
