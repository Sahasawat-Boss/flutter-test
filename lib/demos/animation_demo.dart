import 'package:flutter/material.dart';

import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// เล่นกับ AnimatedContainer + AnimatedAlign พร้อมเลือก Curve และความเร็ว
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  static const _curves = <(String, Curve)>[
    ('easeInOut', Curves.easeInOut),
    ('bounceOut', Curves.bounceOut),
    ('elasticOut', Curves.elasticOut),
    ('linear', Curves.linear),
    ('fastOutSlowIn', Curves.fastOutSlowIn),
  ];

  bool _isBig = false;
  int _curve = 1;
  double _milliseconds = 800;

  Duration get _duration => Duration(milliseconds: _milliseconds.round());

  String get _code => [
        'AnimatedContainer(',
        '  duration: Duration(milliseconds: ${_milliseconds.round()}),',
        '  curve: Curves.${_curves[_curve].$1},',
        '  width: isBig ? 140 : 70,',
        '  height: isBig ? 140 : 70,',
        '  decoration: BoxDecoration(',
        '    color: isBig ? Colors.purple : Colors.cyan,',
        '    borderRadius: BorderRadius.circular(isBig ? 70 : 16),',
        '  ),',
        ')',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    final curve = _curves[_curve].$2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 200,
          child: AnimatedAlign(
            alignment: _isBig ? Alignment.centerRight : Alignment.centerLeft,
            duration: _duration,
            curve: curve,
            child: AnimatedContainer(
              duration: _duration,
              curve: curve,
              width: _isBig ? 140 : 70,
              height: _isBig ? 140 : 70,
              decoration: BoxDecoration(
                color: _isBig ? const Color(0xFF8B5CF6) : const Color(0xFF06B6D4),
                borderRadius: BorderRadius.circular(_isBig ? 70 : 16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.flutter_dash, color: Colors.white, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => setState(() => _isBig = !_isBig),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('เล่นแอนิเมชัน'),
        ),
        const SizedBox(height: 16),
        const ControlLabel('curve'),
        OptionChips<int>(
          options: List.generate(_curves.length, (index) => index),
          selected: _curve,
          labelBuilder: (index) => _curves[index].$1,
          onSelected: (index) => setState(() => _curve = index),
        ),
        const SizedBox(height: 12),
        LabeledSlider(
          label: 'duration',
          value: _milliseconds,
          min: 200,
          max: 2000,
          divisions: 18,
          format: (value) => '${value.round()} ms',
          onChanged: (value) => setState(() => _milliseconds = value),
        ),
        const SizedBox(height: 8),
        CodeView(code: _code, compact: true),
      ],
    );
  }
}
