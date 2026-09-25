import 'package:flutter/material.dart';

import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// ออกแบบ Container ด้วย slider แล้วดูโค้ดที่ได้
class ContainerDemo extends StatefulWidget {
  const ContainerDemo({super.key});

  @override
  State<ContainerDemo> createState() => _ContainerDemoState();
}

class _ContainerDemoState extends State<ContainerDemo> {
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

  double _width = 160;
  double _height = 110;
  double _radius = 20;
  int _color = 0;
  bool _shadow = true;
  bool _gradient = false;

  String get _code {
    final colorName = _colorNames[_color];
    return [
      'Container(',
      '  width: ${_width.round()},',
      '  height: ${_height.round()},',
      '  decoration: BoxDecoration(',
      if (_gradient)
        '    gradient: LinearGradient(colors: [$colorName, ...]),'
      else
        '    color: $colorName,',
      '    borderRadius: BorderRadius.circular(${_radius.round()}),',
      if (_shadow) '    boxShadow: [BoxShadow(blurRadius: 20)],',
      '  ),',
      ')',
    ].join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final color = _colors[_color];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 200,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: _width,
              height: _height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _gradient ? null : color,
                gradient: _gradient
                    ? LinearGradient(
                        colors: [color, Color.lerp(color, Colors.white, 0.45)!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: _shadow
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.45),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : const [],
              ),
              child: Text(
                '${_width.round()} × ${_height.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LabeledSlider(
          label: 'width',
          value: _width,
          min: 60,
          max: 200,
          onChanged: (value) => setState(() => _width = value),
        ),
        LabeledSlider(
          label: 'height',
          value: _height,
          min: 50,
          max: 160,
          onChanged: (value) => setState(() => _height = value),
        ),
        LabeledSlider(
          label: 'borderRadius',
          value: _radius,
          min: 0,
          max: 80,
          onChanged: (value) => setState(() => _radius = value),
        ),
        const ControlLabel('color'),
        ColorChoice(
          colors: _colors,
          selected: _color,
          onSelected: (index) => setState(() => _color = index),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('boxShadow'),
              selected: _shadow,
              onSelected: (value) => setState(() => _shadow = value),
            ),
            FilterChip(
              label: const Text('gradient'),
              selected: _gradient,
              onSelected: (value) => setState(() => _gradient = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CodeView(code: _code, compact: true),
      ],
    );
  }
}
