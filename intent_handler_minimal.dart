import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class IntentHandler extends StatefulWidget {
  @override
  _IntentHandlerState createState() => _IntentHandlerState();
}

class _IntentHandlerState extends State<IntentHandler> {
  // Intent受信用のStreamSubscription
  late StreamSubscription _intentSub;

  // 共有されたファイルのリスト
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    // Intent受信の設定
    _setupIntentHandling();
  }

  void _setupIntentHandling() {
    // 1. アプリが動作中に受信するIntentをリッスン
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        // 受信したファイル情報を処理
        _processSharedFiles();
      });
    }, onError: (err) {
      print("Intent受信エラー: $err");
    });

    // 2. アプリが閉じている状態で受信したIntentを取得
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        // 受信したファイル情報を処理
        _processSharedFiles();

        // Intent処理完了を通知
        ReceiveSharingIntent.instance.reset();
      });
    });
  }

  void _processSharedFiles() {
    // 共有されたファイルの処理ロジック
    for (var file in _sharedFiles) {
      print("ファイルパス: ${file.path}");
      print("ファイルタイプ: ${file.type}");
    }
  }

  @override
  void dispose() {
    // StreamSubscriptionを確実にキャンセル
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("共有ファイル数: ${_sharedFiles.length}"),
    );
  }
}
