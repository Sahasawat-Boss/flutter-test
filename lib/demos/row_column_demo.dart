import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// ทดลองจัดตำแหน่งใน Row / Column
class RowColumnDemo extends StatefulWidget {
  const RowColumnDemo({super.key});

  @override
  State<RowColumnDemo> createState() => _RowColumnDemoState();
}

class _RowColumnDemoState extends State<RowColumnDemo> {
  static const _crossOptions = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
    CrossAxisAlignment.end,
    CrossAxisAlignment.stretch,
  ];

  bool _isRow = true;
  MainAxisAlignment _main = MainAxisAlignment.start;
  CrossAxisAlignment _cross = CrossAxisAlignment.center;

  String get _code => [
        _isRow ? 'Row(' : 'Column(',
        '  mainAxisAlignment: MainAxisAlignment.${_main.name},',
        '  crossAxisAlignment: CrossAxisAlignment.${_cross.name},',
        '  children: [box1, box2, box3],',
        ')',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    final boxes = [
      _box(const Color(0xFF3B82F6), 44, '1'),
      _box(const Color(0xFFEC4899), 60, '2'),
      _box(const Color(0xFFF97316), 34, '3'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Row'),
              icon: Icon(Icons.more_horiz_rounded),
            ),
            ButtonSegment(
              value: false,
              label: Text('Column'),
              icon: Icon(Icons.more_vert_rounded),
            ),
          ],
          selected: {_isRow},
          showSelectedIcon: false,
          onSelectionChanged: (selection) =>
              setState(() => _isRow = selection.first),
        ),
        const SizedBox(height: 12),
        PreviewArea(
          height: 220,
          padding: const EdgeInsets.all(8),
          child: _isRow
              ? Row(
                  mainAxisAlignment: _main,
                  crossAxisAlignment: _cross,
                  children: boxes,
                )
              : Column(
                  mainAxisAlignment: _main,
                  crossAxisAlignment: _cross,
                  children: boxes,
                ),
        ),
        const SizedBox(height: 8),
        Text(
          _isRow
              ? 'แกนหลัก (main) = แนวนอน ↔   แกนรอง (cross) = แนวตั้ง ↕'
              : 'แกนหลัก (main) = แนวตั้ง ↕   แกนรอง (cross) = แนวนอน ↔',
          textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        const ControlLabel('mainAxisAlignment'),
        OptionChips<MainAxisAlignment>(
          options: MainAxisAlignment.values,
          selected: _main,
          labelBuilder: (value) => value.name,
          onSelected: (value) => setState(() => _main = value),
        ),
        const SizedBox(height: 12),
        const ControlLabel('crossAxisAlignment'),
        OptionChips<CrossAxisAlignment>(
          options: _crossOptions,
          selected: _cross,
          labelBuilder: (value) => value.name,
          onSelected: (value) => setState(() => _cross = value),
        ),
        const SizedBox(height: 16),
        CodeView(code: _code, compact: true),
      ],
    );
  }

  Widget _box(Color color, double size, String label) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
