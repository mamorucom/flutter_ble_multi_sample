///
/// Defines an extended function of type "int".
///
extension IntExtension on int {
  ///
  /// Convert to 2's complement of 16bit value
  ///
  int get convertTo2sComplementOf2ByteValue {
    if (this > 0x8000) {
      final a = (~this) & 0xFFFF;
      final b = -1 * (a + 1);
      return b;
    }

    return this;
  }
}
