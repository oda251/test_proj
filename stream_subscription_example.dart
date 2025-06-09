import 'dart:async';

void main() {
  // StreamSubscriptionの基本例
  basicStreamExample();

  // Intent受信での使用例
  intentStreamExample();
}

void basicStreamExample() {
  print('=== 基本的なStreamSubscriptionの例 ===');

  // 1. Streamを作成（1秒ごとに数字を流す）
  Stream<int> counterStream =
      Stream.periodic(Duration(seconds: 1), (count) => count).take(5); // 5回で終了
      // Stream.fromIterable({1, 2, 3}); // 固定のリストからデータを流す

  // 2. StreamSubscriptionでデータを受信
  StreamSubscription<int> subscription = counterStream.listen(
    (data) {
      print('データ受信: $data');
    },
    onError: (error) {
      print('エラー: $error');
    },
    onDone: () {
      print('ストリーム終了');
    },
  );

  // 3. 必要に応じてキャンセル
  Timer(Duration(seconds: 3), () {
    print('ストリームをキャンセル');
    subscription.cancel(); // 重要！
  });
}

void intentStreamExample() {
  print('\n=== Intent受信での使用例 ===');

  // Intent受信のStreamSubscription（疑似コード）
  StreamSubscription? intentSubscription;

  // ストリームを購読
  intentSubscription = getIntentStream().listen((intentData) {
    print('Intent受信: $intentData');
    // ここでファイル処理など
  }, onError: (error) {
    print('Intent受信エラー: $error');
  });

  // アプリ終了時にキャンセル（重要！）
  // dispose()メソッドで呼ばれる
  Timer(Duration(seconds: 2), () {
    intentSubscription?.cancel();
    print('Intent受信を停止');
  });
}

// 疑似的なIntent受信ストリーム
Stream<String> getIntentStream() {
  return Stream.periodic(
      Duration(milliseconds: 500), (count) => 'Intent_$count').take(3);
}
