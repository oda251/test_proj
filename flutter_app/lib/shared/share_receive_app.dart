import 'package:flutter/material.dart';
import '../service/receive_share_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Intent受信機能を使用したサンプルアプリ
class ShareReceiveApp extends StatefulWidget {
  @override
  _ShareReceiveAppState createState() => _ShareReceiveAppState();
}

class _ShareReceiveAppState extends State<ShareReceiveApp> {
  final ReceiveShareService _shareService = ReceiveShareService();
  List<SharedMediaFile> _sharedFiles = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    
    // サービスを初期化
    _shareService.initialize(
      onFilesReceived: (files) {
        setState(() {
          _sharedFiles = files;
          _errorMessage = '';
        });
      },
      onError: (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _shareService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = TextStyle(fontWeight: FontWeight.bold);
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Intent受信サンプル'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("受信したファイル:", style: textStyleBold),
              const SizedBox(height: 8),
              
              // エラーメッセージ表示
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'エラー: $_errorMessage',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // ファイルリスト表示
              Expanded(
                child: _sharedFiles.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '共有されたファイルはありません',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '他のアプリからファイルを共有してください',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _sharedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _sharedFiles[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                _getFileIcon(file.type),
                                color: Colors.blue,
                              ),
                              title: Text(
                                file.path.split('/').last,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('パス: ${file.path}'),
                                  Text('タイプ: ${file.type}'),
                                  if (file.duration != null)
                                    Text('時間: ${file.duration}'),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
              
              // クリアボタン
              if (_sharedFiles.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sharedFiles.clear();
                      });
                      _shareService.clearSharedFiles();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('ファイルリストをクリア'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ファイルタイプに応じたアイコンを返す
  IconData _getFileIcon(SharedMediaType type) {
    switch (type) {
      case SharedMediaType.image:
        return Icons.image;
      case SharedMediaType.video:
        return Icons.video_file;
      case SharedMediaType.file:
        return Icons.insert_drive_file;
      default:
        return Icons.attach_file;
    }
  }
}
