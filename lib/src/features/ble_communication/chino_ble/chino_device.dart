// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ble_multi_connection_sample/src/utils/extension/int.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'chino_ir_tb.dart';
import 'chino_mf500b.dart';

///
/// [ChinoDeviceFactory] creates ChinoDevice object;
///
class ChinoDeviceFactory {
  static ChinoDevice create({
    required BluetoothDevice bleDevice,
    required List<BluetoothService> services,
  }) {
    if (bleDevice.name.contains(ChinoMF500B.commonModelName)) {
      return ChinoMF500B.create(
        service: services.firstWhere(
          (service) => service.uuid == ChinoMF500B.serviceUuid,
        ),
      );
    }
    if (bleDevice.name.contains(ChinoIR_TB.commonModelName)) {
      return ChinoIR_TB.create(
        service: services.firstWhere(
          (service) => service.uuid == ChinoIR_TB.serviceUuid,
        ),
      );
    }

    throw UnimplementedError();
  }
}

///
/// [ChinoDevice] is an abstract class.
///
@immutable
abstract class ChinoDevice extends Equatable {
  const ChinoDevice({
    required this.temperature,
    required this.switchStatus,
    required this.batteryStatus,
    required this.service,
    required this.characteristicTemperatureAndSwitch,
    required this.characteristicBatteryStatus,
  });

  final double temperature;
  final int switchStatus;
  final ChinoBatteryStatus batteryStatus;
  final BluetoothService service;
  final BluetoothCharacteristic characteristicTemperatureAndSwitch;
  final BluetoothCharacteristic characteristicBatteryStatus;

  ChinoDevice copyWith({
    double? temperature,
    int? switchStatus,
    ChinoBatteryStatus? batteryStatus,
  });

  ChinoDevice updateTemperatureAndSwitch({
    required List<int> values,
  });

  ChinoDevice updateBatteryStatus({
    required List<int> values,
  });
}

///
///
///
@immutable
class ChinoTemperatureAndSwitch {
  const ChinoTemperatureAndSwitch({
    required this.temperature,
    required this.switchStatus,
  });

  factory ChinoTemperatureAndSwitch.create({required List<int> values}) {
    if (values.length != 4) {
      return const ChinoTemperatureAndSwitch(
        temperature: 0.00,
        switchStatus: 0x0000,
      );
    }

    /// values are the list of little endian.
    final absT = convertFromLittleEndian2ByteListToInt(
      littleEndianValues: [values[0], values[1]],
    );
    final hundredfoldT = absT.convertTo2sComplementOf2ByteValue;
    final temperature = hundredfoldT / 100;

    final switchStatus = convertFromLittleEndian2ByteListToInt(
      littleEndianValues: [values[2], values[3]],
    );

    return ChinoTemperatureAndSwitch(
      temperature: temperature,
      switchStatus: switchStatus,
    );
  }

  /// 温度値 * 1.00
  final double temperature;

  /// 0x0000(OFF) /0x0001(ON)
  final int switchStatus;

  /// 上限値オーバーフロー
  static const int errorOverflow = 0x7FFF;

  /// バーンアウト
  static const int errorBurnOut = 0x7FFE;

  /// RJエラー
  static const int errorRJ = 0x7FFD;

  /// 演算エラー
  static const int errorCalculation = 0x7FFC;

  /// 校正異常
  static const int errorProofreading = 0x7FFB;

  /// 下限値オーバーフロー
  static const int errorUnderflow = 0x8001;

  ChinoTemperatureAndSwitch copyWith({
    double? temperature,
    int? switchStatus,
  }) {
    return ChinoTemperatureAndSwitch(
      temperature: temperature ?? this.temperature,
      switchStatus: switchStatus ?? this.switchStatus,
    );
  }

  @override
  bool operator ==(covariant ChinoTemperatureAndSwitch other) {
    if (identical(this, other)) return true;

    return other.temperature == temperature &&
        other.switchStatus == switchStatus;
  }

  @override
  int get hashCode => temperature.hashCode ^ switchStatus.hashCode;
}

///
///
///
enum ChinoBatteryStatus {
  empty(key: '0000', title: 'Empty'),
  level1(key: '0001', title: 'Level 1'),
  level2(key: '0002', title: 'Level 2'),
  level3(key: '0003', title: 'Level 3'),
  level4(key: '0004', title: 'Level 4'),
  level5(key: '0005', title: 'Level 5');

  const ChinoBatteryStatus({required this.key, required this.title});

  factory ChinoBatteryStatus.fromKey(String key) {
    return ChinoBatteryStatus.values.firstWhere(
      (e) => e.key == key,
      orElse: () => ChinoBatteryStatus.empty,
    );
  }

  factory ChinoBatteryStatus.fromValues(List<int> values) {
    if (values.length != 2) {
      return ChinoBatteryStatus.empty;
    }

    final value = convertFromLittleEndian2ByteListToInt(
      littleEndianValues: [values[0], values[1]],
    );

    if (value == ChinoBatteryStatus.empty.index) {
      return ChinoBatteryStatus.empty;
    }
    if (value == ChinoBatteryStatus.level1.index) {
      return ChinoBatteryStatus.level1;
    }
    if (value == ChinoBatteryStatus.level2.index) {
      return ChinoBatteryStatus.level2;
    }
    if (value == ChinoBatteryStatus.level3.index) {
      return ChinoBatteryStatus.level3;
    }
    if (value == ChinoBatteryStatus.level4.index) {
      return ChinoBatteryStatus.level4;
    }
    if (value == ChinoBatteryStatus.level5.index) {
      return ChinoBatteryStatus.level5;
    }

    return ChinoBatteryStatus.empty;
  }

  final String key;
  final String title;
}

enum BleConnectionState {
  connected(title: 'Connected'),
  disconnected(title: 'Disconnected');

  const BleConnectionState({required this.title});

  final String title;
}

/// TODO: 置き場所後で検討
int convertFromLittleEndian2ByteListToInt({
  required List<int> littleEndianValues,
}) {
  if (littleEndianValues.length < 2) return 0;

  final stringBuffer = StringBuffer();
  stringBuffer.write(littleEndianValues[1].toRadixString(16).padLeft(2, '0'));
  stringBuffer.write(littleEndianValues[0].toRadixString(16).padLeft(2, '0'));

  return int.parse(
    stringBuffer.toString().substring(0, 4),
    radix: 16,
  );
}
