// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chino_ble_peripheral.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChinoBlePeripheral {
  /// [BluetoothDevice] is used to connect to BLE device.
  BluetoothDevice? get bleDevice => throw _privateConstructorUsedError;

  /// [ChinoDevice] communicates with BLE device and stores measurement
  /// results.
  ChinoDevice? get chinoDevice => throw _privateConstructorUsedError;

  /// [BleConnectionState] stores connected/disconnected.
  BleConnectionState? get bleConnectionState =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChinoBlePeripheralCopyWith<ChinoBlePeripheral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChinoBlePeripheralCopyWith<$Res> {
  factory $ChinoBlePeripheralCopyWith(
          ChinoBlePeripheral value, $Res Function(ChinoBlePeripheral) then) =
      _$ChinoBlePeripheralCopyWithImpl<$Res, ChinoBlePeripheral>;
  @useResult
  $Res call(
      {BluetoothDevice? bleDevice,
      ChinoDevice? chinoDevice,
      BleConnectionState? bleConnectionState});
}

/// @nodoc
class _$ChinoBlePeripheralCopyWithImpl<$Res, $Val extends ChinoBlePeripheral>
    implements $ChinoBlePeripheralCopyWith<$Res> {
  _$ChinoBlePeripheralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bleDevice = freezed,
    Object? chinoDevice = freezed,
    Object? bleConnectionState = freezed,
  }) {
    return _then(_value.copyWith(
      bleDevice: freezed == bleDevice
          ? _value.bleDevice
          : bleDevice // ignore: cast_nullable_to_non_nullable
              as BluetoothDevice?,
      chinoDevice: freezed == chinoDevice
          ? _value.chinoDevice
          : chinoDevice // ignore: cast_nullable_to_non_nullable
              as ChinoDevice?,
      bleConnectionState: freezed == bleConnectionState
          ? _value.bleConnectionState
          : bleConnectionState // ignore: cast_nullable_to_non_nullable
              as BleConnectionState?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChinoBlePeripheralCopyWith<$Res>
    implements $ChinoBlePeripheralCopyWith<$Res> {
  factory _$$_ChinoBlePeripheralCopyWith(_$_ChinoBlePeripheral value,
          $Res Function(_$_ChinoBlePeripheral) then) =
      __$$_ChinoBlePeripheralCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BluetoothDevice? bleDevice,
      ChinoDevice? chinoDevice,
      BleConnectionState? bleConnectionState});
}

/// @nodoc
class __$$_ChinoBlePeripheralCopyWithImpl<$Res>
    extends _$ChinoBlePeripheralCopyWithImpl<$Res, _$_ChinoBlePeripheral>
    implements _$$_ChinoBlePeripheralCopyWith<$Res> {
  __$$_ChinoBlePeripheralCopyWithImpl(
      _$_ChinoBlePeripheral _value, $Res Function(_$_ChinoBlePeripheral) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bleDevice = freezed,
    Object? chinoDevice = freezed,
    Object? bleConnectionState = freezed,
  }) {
    return _then(_$_ChinoBlePeripheral(
      bleDevice: freezed == bleDevice
          ? _value.bleDevice
          : bleDevice // ignore: cast_nullable_to_non_nullable
              as BluetoothDevice?,
      chinoDevice: freezed == chinoDevice
          ? _value.chinoDevice
          : chinoDevice // ignore: cast_nullable_to_non_nullable
              as ChinoDevice?,
      bleConnectionState: freezed == bleConnectionState
          ? _value.bleConnectionState
          : bleConnectionState // ignore: cast_nullable_to_non_nullable
              as BleConnectionState?,
    ));
  }
}

/// @nodoc

class _$_ChinoBlePeripheral implements _ChinoBlePeripheral {
  _$_ChinoBlePeripheral(
      {this.bleDevice, this.chinoDevice, this.bleConnectionState});

  /// [BluetoothDevice] is used to connect to BLE device.
  @override
  final BluetoothDevice? bleDevice;

  /// [ChinoDevice] communicates with BLE device and stores measurement
  /// results.
  @override
  final ChinoDevice? chinoDevice;

  /// [BleConnectionState] stores connected/disconnected.
  @override
  final BleConnectionState? bleConnectionState;

  @override
  String toString() {
    return 'ChinoBlePeripheral(bleDevice: $bleDevice, chinoDevice: $chinoDevice, bleConnectionState: $bleConnectionState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChinoBlePeripheral &&
            (identical(other.bleDevice, bleDevice) ||
                other.bleDevice == bleDevice) &&
            (identical(other.chinoDevice, chinoDevice) ||
                other.chinoDevice == chinoDevice) &&
            (identical(other.bleConnectionState, bleConnectionState) ||
                other.bleConnectionState == bleConnectionState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, bleDevice, chinoDevice, bleConnectionState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChinoBlePeripheralCopyWith<_$_ChinoBlePeripheral> get copyWith =>
      __$$_ChinoBlePeripheralCopyWithImpl<_$_ChinoBlePeripheral>(
          this, _$identity);
}

abstract class _ChinoBlePeripheral implements ChinoBlePeripheral {
  factory _ChinoBlePeripheral(
      {final BluetoothDevice? bleDevice,
      final ChinoDevice? chinoDevice,
      final BleConnectionState? bleConnectionState}) = _$_ChinoBlePeripheral;

  @override

  /// [BluetoothDevice] is used to connect to BLE device.
  BluetoothDevice? get bleDevice;
  @override

  /// [ChinoDevice] communicates with BLE device and stores measurement
  /// results.
  ChinoDevice? get chinoDevice;
  @override

  /// [BleConnectionState] stores connected/disconnected.
  BleConnectionState? get bleConnectionState;
  @override
  @JsonKey(ignore: true)
  _$$_ChinoBlePeripheralCopyWith<_$_ChinoBlePeripheral> get copyWith =>
      throw _privateConstructorUsedError;
}
