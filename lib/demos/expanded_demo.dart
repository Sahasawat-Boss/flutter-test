import 'package:flutter/material.dart';

import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// ปรับ flex ของ Expanded 3 กล่อง แล้วดูสัดส่วนเปลี่ยน
class ExpandedDemo extends StatefulWidget {
  const ExpandedDemo({super.key});

  @override
  State<ExpandedDemo> createState() => _ExpandedDemoState();
}

class _ExpandedDemoState extends State<ExpandedDemo> {
  static const _colors = [Color(0xFFEF4444), Color(0xFF22C55E), Color(0xFF3B82F6)];
  static const _names = ['red', 'green', 'blue'];
  static const _labels = ['กล่องแดง', 'กล่องเขียว', 'กล่องน้ำเงิน'];

  final List<int> _flex = [1, 2, 1];

  int get _total => _flex.fold(0, (sum, value) => sum + value);

  String get _code => [
        'Row(',
        '  children: [',
        for (var i = 0; i < 3; i++)
          '    Expanded(flex: ${_flex[i]}, child: Box(${_names[i]})),',
        '  ],',
        ')',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 110,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              for (var i = 0; i < 3; i++)
                Expanded(
                  flex: _flex[i],
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'flex: ${_flex[i]}\n${(_flex[i] * 100 / _total).round()}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < 3; i++)
          LabeledSlider(
            label: '${_labels[i]} (flex)',
            value: _flex[i].toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            color: _colors[i],
            onChanged: (value) => setState(() => _flex[i] = value.round()),
          ),
        const SizedBox(height: 8),
        CodeView(code: _code, compact: true),
      ],
    );
  }
}
