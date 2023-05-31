# //! android12はライブラリのコード最適化されると動作しないため、そのための処置
# The Bluetooth program has been optimized on Android and cannot scan properly.
# https://github.com/boskokg/flutter_blue_plus/issues/49
-keep class com.boskokg.flutter_blue_plus.* { *; } 
-keep class com.boskokg.flutter_blue_plus.Protos* { *; } 
-keep class com.boskokg.flutter_blue_plus.Protos.ScanSettings* { *; }