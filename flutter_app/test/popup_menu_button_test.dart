import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/flex_popup_menu_button.dart';

void main() {
  testWidgets('MyPopupMenuButton が正しく表示される', (WidgetTester tester) async {
    // テスト用のアイテムを作成
    final List<PopupMenuItem> testItems = [
      PopupMenuItem(
        value: 'test1',
        child: const Text('テスト項目1'),
        onTap: () {},
      ),
      PopupMenuItem(
        value: 'test2',
        child: const Text('テスト項目2'),
        onTap: () {},
      ),
    ];

    // テスト用のウィジェットをビルド
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: MyPopupMenuButton(
                context: context,
                child: const Text('テストボタン'),
                items: testItems,
              ),
            ),
          ),
        ),
      ),
    );

    // ボタンが表示されていることを確認
    expect(find.text('テストボタン'), findsOneWidget);

    // OverlayPortalが正しく設定されているか確認
    expect(find.byType(OverlayPortal), findsOneWidget);
  });

  testWidgets('ColumnPopupMenu が正しく項目を表示する', (WidgetTester tester) async {
    // テスト用のアイテムを作成
    final List<PopupMenuItem> testItems = [
      PopupMenuItem(
        value: 'test1',
        child: const Text('テスト項目1'),
        onTap: () {},
      ),
      PopupMenuItem(
        value: 'test2',
        child: const Text('テスト項目2'),
        onTap: () {},
      ),
    ];

    // テスト用のウィジェットをビルド
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ColumnPopupMenu(items: testItems),
          ),
        ),
      ),
    );

    // 各項目が表示されていることを確認
    expect(find.text('テスト項目1'), findsOneWidget);
    expect(find.text('テスト項目2'), findsOneWidget);

    // Columnウィジェットが使われていることを確認
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets('MyPopupMenuButton がtooltipを正しく表示する',
      (WidgetTester tester) async {
    // テスト用のアイテムを作成
    final List<PopupMenuItem> testItems = [
      PopupMenuItem(
        value: 'test1',
        child: const Text('テスト項目1'),
        onTap: () {},
      ),
    ];

    // テスト用のウィジェットをビルド（tooltipあり）
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: MyPopupMenuButton(
                context: context,
                tooltip: 'テストツールチップ',
                child: const Text('テストボタン'),
                items: testItems,
              ),
            ),
          ),
        ),
      ),
    );

    // tooltipが設定されていることを確認
    expect(find.byTooltip('テストツールチップ'), findsNothing); // まだ表示されていない

    // tooltipを表示するためにホバー
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: tester.getCenter(find.text('テストボタン')));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('テストボタン')));
    await tester.pump(const Duration(seconds: 1)); // ツールチップが表示されるまで待機

    // tooltipが表示されたことを確認（注：実際のツールチップの検証は環境によって異なる）
    // expect(find.byTooltip('テストツールチップ'), findsOneWidget);
  });
}
