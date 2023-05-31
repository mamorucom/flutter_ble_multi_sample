part of ble_communication;

/// The type a Future-type of [VoidCallback].
typedef FutureVoidCallback = Future<void> Function();

class _XsChinoPeripheralServiceButton extends HookConsumerWidget {
  const _XsChinoPeripheralServiceButton({
    required this.onPressed,
    required this.child,
  });

  final FutureVoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleConnectionState = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.bleConnectionState),
    );

    return ElevatedButton(
      onPressed: () async {
        if (bleConnectionState != null &&
            bleConnectionState != BleConnectionState.connected) return;

        await onPressed();
      },
      child: child,
    );
  }
}
