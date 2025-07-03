import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FL Chart Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BarChartPage(),
    );
  }
}

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  int touchedIndex = -1;
  double? cursorPosition;

  // サンプルデータ（2つの系列）
  final List<ChartDataModel> chartData1 = [
    ChartDataModel(label: '1D', value: 6),
    ChartDataModel(label: '2D', value: 8),
    ChartDataModel(label: '3D', value: 5),
    ChartDataModel(label: '4D', value: 16),
    ChartDataModel(label: '5D', value: 15),
    ChartDataModel(label: '6D', value: 6),
    ChartDataModel(label: '7D', value: 15),
  ];

  final List<ChartDataModel> chartData2 = [
    ChartDataModel(label: '1D', value: 2),
    ChartDataModel(label: '2D', value: 6),
    ChartDataModel(label: '3D', value: 18),
    ChartDataModel(label: '4D', value: 15),
    ChartDataModel(label: '5D', value: 30),
    ChartDataModel(label: '6D', value: 22),
    ChartDataModel(label: '7D', value: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FL Chart 折れ線グラフデモ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 凡例を追加
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                    Colors.lightBlue, '「新しい自分に出会おう🤗」#新年の目標 #日常の魔法'),
                const SizedBox(width: 10),
                _buildLegendItem(Colors.blueGrey[800]!,
                    'A Healing Journey for the Soul - Vlog'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _handleInteraction(details.localPosition);
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      _handleInteraction(details.localPosition);
                    },
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: false, // 元のタッチを無効化
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitleWidgets,
                              reservedSize: 32,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 42,
                              interval: 10,
                              getTitlesWidget: leftTitleWidgets,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (chartData1.length - 1).toDouble(),
                        minY: 0,
                        maxY: 35,
                        lineBarsData: [
                          // 第1系列（ライトブルー）
                          LineChartBarData(
                            spots: List.generate(chartData1.length, (index) {
                              return FlSpot(index.toDouble(),
                                  chartData1[index].value.toDouble());
                            }),
                            isCurved: false,
                            color: Colors.lightBlue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.lightBlue,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(show: false),
                          ),
                          // 第2系列（ダークブルー）
                          LineChartBarData(
                            spots: List.generate(chartData2.length, (index) {
                              return FlSpot(index.toDouble(),
                                  chartData2[index].value.toDouble());
                            }),
                            isCurved: false,
                            color: Colors.blueGrey[800]!,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.blueGrey[800]!,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (cursorPosition != null)
                    Positioned(
                      left: _getCursorXPosition(),
                      top: 0,
                      bottom: 32, // bottomTitlesの高さ分上げる
                      child: CustomPaint(
                        painter: DashedLinePainter(
                          color: Colors.lightBlue,
                          strokeWidth: 2,
                          dashWidth: 5,
                          dashSpace: 3,
                        ),
                        child: Container(
                          width: 2,
                          child: Column(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlue.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // ツールチップを折れ線グラフのポイント上に表示
                  if (cursorPosition != null && touchedIndex >= 0)
                    Positioned(
                      left: _getTooltipXPosition(),
                      top: _getTooltipYPosition(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${chartData1[touchedIndex].label}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 第1系列のデータ
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 2,
                                  color: Colors.lightBlue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${chartData1[touchedIndex].value}',
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            // 第2系列のデータ
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 2,
                                  color: Colors.blueGrey[800]!,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${chartData2[touchedIndex].value}',
                                  style: TextStyle(
                                    color: Colors.blueGrey[800]!,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (cursorPosition != null && touchedIndex >= 0)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${chartData1[touchedIndex].label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '系列1',
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${chartData1[touchedIndex].value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '系列2',
                              style: TextStyle(
                                color: Colors.blueGrey[300]!,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${chartData2[touchedIndex].value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'カーソル位置: ${cursorPosition!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleInteraction(Offset localPosition) {
    // チャートエリアの範囲を計算
    const double leftMargin = 42; // leftTitles reserved size
    const double rightMargin = 16; // padding right

    final double chartAreaWidth = MediaQuery.of(context).size.width -
        leftMargin -
        rightMargin -
        32; // 32 = padding left + right
    final double tapX = localPosition.dx;

    // タップ位置がチャートエリア内かチェック
    if (tapX < leftMargin || tapX > (leftMargin + chartAreaWidth)) {
      return; // チャートエリア外の場合は無視
    }

    // チャートエリア内での相対位置を計算
    final double relativeX = tapX - leftMargin;
    final double normalizedPosition = relativeX / chartAreaWidth;

    // 位置を0.0 - (chartData1.length - 1)の範囲にマッピング
    final double exactPosition = normalizedPosition * (chartData1.length - 1);
    final double clampedPosition =
        exactPosition.clamp(0.0, (chartData1.length - 1).toDouble());

    // 一番近い棒グラフのインデックスを計算
    final int nearestIndex = clampedPosition.round();

    setState(() {
      cursorPosition = clampedPosition; // 正確な位置を保存
      touchedIndex = nearestIndex;
    });
  }

  double _getCursorXPosition() {
    if (cursorPosition == null) return 0;

    // チャートエリアの幅を計算（左の余白 + 棒グラフエリアでの位置）
    const double leftMargin = 42; // leftTitles reserved size
    const double rightMargin = 16; // padding

    // 画面幅からマージンを引いてチャート幅を計算
    final double chartWidth = MediaQuery.of(context).size.width -
        leftMargin -
        rightMargin -
        32; // 32 = padding left + right

    // カーソル位置をピクセル位置に変換
    final double normalizedPosition = cursorPosition! / (chartData1.length - 1);
    final double position = leftMargin + (normalizedPosition * chartWidth);

    return position;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    if (value == 0) return Text('0', style: style);
    if (value == 10) return Text('10K', style: style);
    if (value == 20) return Text('20K', style: style);
    if (value == 30) return Text('30K', style: style);
    return const SizedBox();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value.toInt() < chartData1.length) {
      return Text(chartData1[value.toInt()].label, style: style);
    }
    return const SizedBox();
  }

  double _getTooltipXPosition() {
    if (cursorPosition == null) return 0;

    // カーソルの中央位置を取得
    final double cursorX = _getCursorXPosition();

    // ツールチップの幅を考慮して中央配置（ツールチップ幅を120と仮定）
    const double tooltipWidth = 120;
    double tooltipX = cursorX - (tooltipWidth / 2);

    // 画面端からはみ出さないように調整
    const double margin = 8;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (tooltipX < margin) {
      tooltipX = margin;
    } else if (tooltipX + tooltipWidth > screenWidth - margin) {
      tooltipX = screenWidth - tooltipWidth - margin;
    }

    return tooltipX;
  }

  double _getTooltipYPosition() {
    if (touchedIndex < 0) return 0;

    // より高い方の値を基準にしてツールチップを配置
    final double value1 = chartData1[touchedIndex].value.toDouble();
    final double value2 = chartData2[touchedIndex].value.toDouble();
    final double maxPointValue = value1 > value2 ? value1 : value2;
    
    // チャートの固定値
    const double maxChartValue = 35.0;
    const double topMargin = 56 + 16 + 20 + 20; // AppBar + padding + legend + spacing
    
    // 利用可能なチャート高さを取得
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final double availableHeight = renderBox?.size.height ?? MediaQuery.of(context).size.height;
    final double chartAreaHeight = availableHeight - topMargin - 32 - 100; // bottom予約領域を除く
    
    // ポイントのY位置を計算（チャートエリア内での相対位置）
    final double relativeY = 1.0 - (maxPointValue / maxChartValue);
    final double pointY = topMargin + (relativeY * chartAreaHeight);
    
    // ツールチップをポイントの上に配置（固定オフセット）
    const double tooltipHeight = 100; // ツールチップの概算高さ
    double tooltipY = pointY - tooltipHeight - 10; // 10pxのマージン
    
    // 上端からはみ出さないように調整
    const double minY = topMargin + 10;
    if (tooltipY < minY) {
      tooltipY = pointY + 20; // ポイントの下に表示
    }
    
    return tooltipY;
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 200,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ChartDataModel {
  final String label;
  final int value;

  ChartDataModel({required this.label, required this.value});
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    final double endY = size.height;
    final double x = size.width / 2;

    while (startY < endY) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, (startY + dashWidth).clamp(0, endY)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
