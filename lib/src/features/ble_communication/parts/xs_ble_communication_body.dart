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
