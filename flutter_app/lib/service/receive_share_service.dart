import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Intent受信を管理するサービスクラス
class ReceiveShareService {
  // Intent受信用のStreamSubscription
  late StreamSubscription _intentSub;

  // 共有されたファイルのリスト
  final List<SharedMediaFile> _sharedFiles = [];

  // ファイル受信時のコールバック
  Function(List<SharedMediaFile>)? onFilesReceived;

  // エラー発生時のコールバック
  Function(dynamic)? onError;

  // シングルトンインスタンス
  static final ReceiveShareService _instance = ReceiveShareService._internal();
  factory ReceiveShareService() => _instance;
  ReceiveShareService._internal();

  // サービスの初期化
  void initialize({
    Function(List<SharedMediaFile>)? onFilesReceived,
    Function(dynamic)? onError,
  }) {
    this.onFilesReceived = onFilesReceived;
    this.onError = onError;
    _setupIntentHandling();
  }

  // Intent受信の設定
  void _setupIntentHandling() {
    // アプリが動作中に受信するIntentをリッスン
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        _processSharedFiles();
      },
      onError: (err) {
        print("Intent受信エラー: $err");
        onError?.call(err);
      },
    );

    // アプリが閉じている状態で受信したIntentを取得
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      _sharedFiles.clear();
      _sharedFiles.addAll(value);
      _processSharedFiles();

      // Intent処理完了を通知
      ReceiveSharingIntent.instance.reset();
    });
  }

  // 共有されたファイルの処理ロジック
  void _processSharedFiles() {
    if (_sharedFiles.isNotEmpty) {
      print("受信したファイル:");
      for (var file in _sharedFiles) {
        print("  - パス: ${file.path}");
        print("  - タイプ: ${file.type}");
        print("  - データ: ${file.toMap()}");
      }

      // コールバックを呼び出し
      onFilesReceived?.call(List.from(_sharedFiles));
    }
  }

  // 現在の共有ファイルリストを取得
  List<SharedMediaFile> get sharedFiles => List.from(_sharedFiles);

  // 共有ファイルリストをクリア
  void clearSharedFiles() {
    _sharedFiles.clear();
  }

  // サービスのクリーンアップ
  void dispose() {
    _intentSub.cancel();
    onFilesReceived = null;
    onError = null;
  }
}
