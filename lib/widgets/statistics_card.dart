import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.title,
    required this.values,
    this.chartType = ChartType.bars,
  });

  final String title;
  final Map<String, int> values;
  final ChartType chartType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: _ChartPainter(values, theme.colorScheme, chartType),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ChartType { bars, line, pie, histogram }

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.values, this.colors, this.type);

  final Map<String, int> values;
  final ColorScheme colors;
  final ChartType type;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      final text = TextPainter(
        text: TextSpan(
          text: 'Aucune donnée',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(
        canvas,
        Offset((size.width - text.width) / 2, size.height / 2),
      );
      return;
    }
    switch (type) {
      case ChartType.pie:
        _paintPie(canvas, size);
      case ChartType.line:
        _paintLine(canvas, size);
      case ChartType.histogram:
      case ChartType.bars:
        _paintBars(canvas, size);
    }
  }

  void _paintBars(Canvas canvas, Size size) {
    final maxValue = values.values.reduce((a, b) => a > b ? a : b).toDouble();
    final barWidth = size.width / values.length;
    var index = 0;
    for (final entry in values.entries) {
      final height = (entry.value / maxValue) * (size.height - 28);
      final rect = Rect.fromLTWH(
        index * barWidth + 6,
        size.height - height - 22,
        barWidth - 12,
        height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        Paint()..color = _palette(index),
      );
      _label(
        canvas,
        entry.key,
        Offset(index * barWidth + 4, size.height - 18),
        barWidth - 8,
      );
      index++;
    }
  }

  void _paintLine(Canvas canvas, Size size) {
    final maxValue = values.values.reduce((a, b) => a > b ? a : b).toDouble();
    final points = <Offset>[];
    final step = values.length == 1
        ? size.width
        : size.width / (values.length - 1);
    var index = 0;
    for (final value in values.values) {
      points.add(
        Offset(
          index * step,
          size.height - 20 - (value / maxValue) * (size.height - 36),
        ),
      );
      index++;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = colors.primary
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
    for (final point in points) {
      canvas.drawCircle(point, 4, Paint()..color = colors.tertiary);
    }
  }

  void _paintPie(Canvas canvas, Size size) {
    final total = values.values.fold<int>(0, (a, b) => a + b).toDouble();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 10;
    var start = -1.57;
    var index = 0;
    for (final value in values.values) {
      final sweep = value / total * 6.283;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        Paint()..color = _palette(index),
      );
      start += sweep;
      index++;
    }
  }

  void _label(Canvas canvas, String text, Offset offset, double width) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10),
      ),
      maxLines: 1,
      ellipsis: '…',
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    painter.paint(canvas, offset);
  }

  Color _palette(int index) {
    final palette = [
      colors.primary,
      colors.tertiary,
      Colors.green,
      Colors.orange,
      Colors.blueGrey,
    ];
    return palette[index % palette.length];
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.type != type;
}
