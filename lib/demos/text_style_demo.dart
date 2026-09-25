import 'package:flutter/material.dart';

import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// ปรับ TextStyle แล้วดูผลลัพธ์พร้อมโค้ดแบบ real-time
class TextStyleDemo extends StatefulWidget {
  const TextStyleDemo({super.key});

  @override
  State<TextStyleDemo> createState() => _TextStyleDemoState();
}

class _TextStyleDemoState extends State<TextStyleDemo> {
  static const List<Color> _colors = [
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.teal,
    Colors.purple,
  ];
  static const _colorNames = [
    'Colors.blue',
    'Colors.pink',
    'Colors.orange',
    'Colors.teal',
    'Colors.purple',
  ];

  double _size = 26;
  bool _bold = true;
  bool _italic = false;
  bool _underline = false;
  int _color = 0;

  String get _code => [
        'Text(',
        "  'Flutter สนุกมาก',",
        '  style: TextStyle(',
        '    fontSize: ${_size.round()},',
        if (_bold) '    fontWeight: FontWeight.bold,',
        if (_italic) '    fontStyle: FontStyle.italic,',
        if (_underline) '    decoration: TextDecoration.underline,',
        '    color: ${_colorNames[_color]},',
        '  ),',
        ')',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    final color = _colors[_color];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 110,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Flutter สนุกมาก',
                style: TextStyle(
                  fontSize: _size,
                  fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                  decoration:
                      _underline ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: color,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LabeledSlider(
          label: 'fontSize',
          value: _size,
          min: 12,
          max: 40,
          divisions: 28,
          onChanged: (value) => setState(() => _size = value),
        ),
        const ControlLabel('สไตล์'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('bold'),
              selected: _bold,
              onSelected: (value) => setState(() => _bold = value),
            ),
            FilterChip(
              label: const Text('italic'),
              selected: _italic,
              onSelected: (value) => setState(() => _italic = value),
            ),
            FilterChip(
              label: const Text('underline'),
              selected: _underline,
              onSelected: (value) => setState(() => _underline = value),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const ControlLabel('color'),
        ColorChoice(
          colors: _colors,
          selected: _color,
          onSelected: (index) => setState(() => _color = index),
        ),
        const SizedBox(height: 16),
        CodeView(code: _code, compact: true),
      ],
    );
  }
}
