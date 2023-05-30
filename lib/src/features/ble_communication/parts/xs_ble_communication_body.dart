part of ble_communication;

///
///? 画面開いたらスキャンが始まり、見つかった機器と接続するサンプル(複数接続対応)。テキトーなUIのため注意.
///  → なぜかスキャンがうまく開始できなかったので、手動でScanを押して開始としました。
///

class _XsBleCommunicationBody extends HookConsumerWidget {
  const _XsBleCommunicationBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isBleScanningAsync = ref.watch(isBleScanningProvider);
    final bleScanResultsNotifier =
        ref.watch(chinoBleScanResultsProvider.notifier);

    // useEffect(
    //   () {
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //       await bleScanResultsNotifier.listen();
    //     });
    //     return;
    //   },
    //   const [],
    // );
    // final onPressed = !(isBleScanningAsync.valueOrNull ?? true)
    //     ? () async {
    //         await bleScanResultsNotifier.startAndCheckScan();
    //       }
    //     : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await bleScanResultsNotifier.startAndCheckScan();
                },
                child: const Text('Scan'),
              ),
            ],
          ),
          const Expanded(child: _XsScanResultsListView()),
        ],
      ),
    );
  }
}

class _XsScanResultsListView extends HookConsumerWidget {
  const _XsScanResultsListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleScanResultsAsync = ref.watch(chinoBleScanResultsProvider);

    return bleScanResultsAsync.when(
      data: (bleScanResults) {
        return ListView.separated(
          itemCount: bleScanResults.length,
          itemBuilder: (context, index) {
            ///? ProviderScopeは、overrides内でproviderのstateを上書きできます。
            ///  これを利用してこの配下でのみ有効なproviderを作れます。
            ///  [メリット]
            ///  今回の例だと、_XsChinoPeripheralListTileにbleScanResults[index]を引数として渡す必要がなくなる。
            ///  → _XsChinoPeripheralListTileにconstを付けることができる。
            /// 　　※constついてるWidgetはリビルドの対象外のため、パフォーマンス向上につながる。
            ///  ただし、今回のリストはせいぜい何十台のリストの想定のため効果はたかが知れてる。
            return ProviderScope(
              overrides: [
                _xsBleScanResultProvider
                    .overrideWithValue(bleScanResults[index]),
              ],
              child: const _XsChinoPeripheralListTile(),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

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

    return Text(
      bleConnectionState?.title ?? '',
    );
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
    final chinoBlePeripheralAsync = ref.watch(chinoBlePeripheralProvider(name));
    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    return chinoBlePeripheralAsync.when(
      data: (chinoBlePeripheral) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '- Temperature: ${chinoBlePeripheral.chinoDevice?.temperature ?? ''}℃',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (chinoBlePeripheral.bleConnectionState != null &&
                    chinoBlePeripheral.bleConnectionState !=
                        BleConnectionState.connected) return;

                await notifier.readTemperatureAndSwitchByBleCommunication();
              },
              child: const Text('Read'),
            ),
            const SizedBox(width: Sizes.p4),
            ElevatedButton(
              onPressed: () async {
                if (chinoBlePeripheral.bleConnectionState != null &&
                    chinoBlePeripheral.bleConnectionState !=
                        BleConnectionState.connected) return;

                await notifier.checkNotify();
              },
              child: const Text('Notify'),
            ),
          ],
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class _XsBleCommunicationSwitchStatus extends HookConsumerWidget {
  const _XsBleCommunicationSwitchStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final chinoBlePeripheralAsync = ref.watch(chinoBlePeripheralProvider(name));

    return chinoBlePeripheralAsync.when(
      data: (chinoBlePeripheral) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '- Switch: ${chinoBlePeripheral.chinoDevice?.switchStatus ?? ''}',
              ),
            ),
          ],
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class _XsBleCommunicationBatteryStatus extends HookConsumerWidget {
  const _XsBleCommunicationBatteryStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanResult = ref.watch(_xsBleScanResultProvider);
    final name = scanResult.device.name;
    final chinoBlePeripheralAsync = ref.watch(chinoBlePeripheralProvider(name));
    final notifier = ref.read(chinoBlePeripheralProvider(name).notifier);

    return chinoBlePeripheralAsync.when(
      data: (chinoBlePeripheral) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '- Battery: ${chinoBlePeripheral.chinoDevice?.batteryStatus.title ?? ''}',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (chinoBlePeripheral.bleConnectionState != null &&
                    chinoBlePeripheral.bleConnectionState !=
                        BleConnectionState.connected) return;

                await notifier.readBatteryStatusByBleCommunication();
              },
              child: const Text('Read'),
            ),
          ],
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const SizedBox.shrink(),
    );
  }
}
