part of ble_communication;

//? 上記で上書きされて使うことができるScopedなProvider
final _xsBleScanResultProvider = Provider<ScanResult>(
  (_) => throw UnimplementedError(),
);

class _XsChinoPeripheralListTile extends HookConsumerWidget {
  const _XsChinoPeripheralListTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final chinoBlePeripheralAsync = ref.watch(chinoBlePeripheralProvider(name));
    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          final isSuccess = await notifier.connect();

          if (!isSuccess) return;
          // TODO: 思いやりタイマー必要??
          await notifier.checkNotify();
        });
        return;
      },
      const [],
    );

    return chinoBlePeripheralAsync.when(
      data: (chinoBlePeripheral) {
        ///? ここはわざわざScopedなProvider用意しなくとも良いかもですが、
        /// widget classを分けたかったのでついでに...
        return ProviderScope(
          overrides: [
            _xsChinoBlePeripheralProvider.overrideWithValue(chinoBlePeripheral),
          ],
          child: const _XsChinoPeripheralListTileContents(),
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

final _xsChinoBlePeripheralProvider = Provider<ChinoBlePeripheral>(
  (_) => throw UnimplementedError(),
);

class _XsChinoPeripheralListTileContents extends HookConsumerWidget {
  const _XsChinoPeripheralListTileContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleConnectionState = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.bleConnectionState),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _XsDeviceName()),
            _XsBleConnectionState(),
            SizedBox(width: Sizes.p4),
            _XsBleConnectButton(),
          ],
        ),
        if (bleConnectionState == BleConnectionState.connected) ...[
          const _XsBleCommunicationTemperature(),
          const _XsBleCommunicationSwitchStatus(),
          const _XsBleCommunicationBatteryStatus(),
        ],
      ],
    );
  }
}

class _XsDeviceName extends HookConsumerWidget {
  const _XsDeviceName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;

    return Text(
      name,
      style: themeData.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _XsBleConnectionState extends HookConsumerWidget {
  const _XsBleConnectionState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleConnectionState = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.bleConnectionState),
    );

    return Text(bleConnectionState?.title ?? '');
  }
}

class _XsBleConnectButton extends HookConsumerWidget {
  const _XsBleConnectButton();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final bleConnectionState = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.bleConnectionState),
    );
    final connectionButtonTitle =
        bleConnectionState == BleConnectionState.connected ? '切断' : '接続';

    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    return ElevatedButton(
      onPressed: () async {
        if (bleConnectionState != null &&
            bleConnectionState != BleConnectionState.disconnected) {
          await notifier.disconnect();
          return;
        }

        await notifier.connect();
      },
      child: Text(connectionButtonTitle),
    );
  }
}

class _XsBleCommunicationTemperature extends HookConsumerWidget {
  const _XsBleCommunicationTemperature();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final temperature = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.chinoDevice?.temperature),
    );
    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            '- Temperature: ${temperature ?? ''}℃',
          ),
        ),
        _XsChinoPeripheralServiceButton(
          onPressed: () async {
            await notifier.readTemperatureAndSwitchByBleCommunication();
          },
          child: const Text('Read'),
        ),
        const SizedBox(width: Sizes.p4),
        _XsChinoPeripheralServiceButton(
          onPressed: () async {
            await notifier.checkNotify();
          },
          child: const Text('Notify'),
        ),
      ],
    );
  }
}

class _XsBleCommunicationSwitchStatus extends HookConsumerWidget {
  const _XsBleCommunicationSwitchStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchStatus = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.chinoDevice?.switchStatus),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            '- Switch: ${switchStatus ?? ''}',
          ),
        ),
      ],
    );
  }
}

class _XsBleCommunicationBatteryStatus extends HookConsumerWidget {
  const _XsBleCommunicationBatteryStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final batteryStatus = ref.watch(
      _xsChinoBlePeripheralProvider.select((v) => v.chinoDevice?.batteryStatus),
    );
    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            '- Battery: ${batteryStatus?.title ?? ''}',
          ),
        ),
        _XsChinoPeripheralServiceButton(
          onPressed: () async {
            await notifier.readBatteryStatusByBleCommunication();
          },
          child: const Text('Read'),
        ),
      ],
    );
  }
}
