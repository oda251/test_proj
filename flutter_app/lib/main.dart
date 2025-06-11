import 'package:flutter/material.dart';
import 'shared/flex_popup_menu_button.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() {
  runApp(const MyApp());
}

Widget a(BuildContext context) {
  Widget button = IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () {
      SmartDialog.showAttach(
        targetContext: context,
        builder: (_) => Text('text'),
      );
    },
  );
  return button;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopupMenu Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PopupMenu Demo Home Page'),
      // SmartDialogの設定を追加
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Widget buildPopupMenuItem(BuildContext context) {
  return SizedBox(
    width: 100,
    height: 100,
    child: Container(
      color: Colors.amber,
      child: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('ボタン1')),
          ElevatedButton(onPressed: () {}, child: Text('ボタン2')),
          ElevatedButton(onPressed: () {}, child: Text('ボタン3')),
        ],
      ),
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  OverlayPortalController overlayController = OverlayPortalController();
  OverlayPortalController overlayController1 = OverlayPortalController();
  OverlayPortalController overlayController2 = OverlayPortalController();

  LayerLink link = LayerLink();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            a(context),
            buildPopupMenuItem(context),
            const Text('タップしてポップアップメニューを表示：'),
            const SizedBox(height: 20),
            // テスト用のMyPopupMenuButtonウィジェット
            FlexPopupMenuButton.icon(
              context: context,
              offset: const Offset(0, 50),
              items: [
                FlexPopupMenuItem(
                  label: 'メニュー1',
                  onTap: () {
                    SmartDialog.showToast('メニュー1が選択されました');
                  },
                ),
                FlexPopupMenuItem(
                  label: 'メニュー2',
                  onTap: () {
                    SmartDialog.showToast('メニュー2が選択されました');
                  },
                ),
                FlexPopupMenuItem(
                  label: 'メニュー3',
                  onTap: () {
                    SmartDialog.showToast('メニュー3が選択されました');
                  },
                ),
              ],
              icon: Icon(Icons.menu, size: 30, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
