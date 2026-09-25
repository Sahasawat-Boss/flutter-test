import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/code_view.dart';
import '../widgets/demo_kit.dart';

/// เลือก Alignment ของชั้นบนใน Stack จากตาราง 3×3
class StackDemo extends StatefulWidget {
  const StackDemo({super.key});

  @override
  State<StackDemo> createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  static const _alignments = <(String, Alignment)>[
    ('topLeft', Alignment.topLeft),
    ('topCenter', Alignment.topCenter),
    ('topRight', Alignment.topRight),
    ('centerLeft', Alignment.centerLeft),
    ('center', Alignment.center),
    ('centerRight', Alignment.centerRight),
    ('bottomLeft', Alignment.bottomLeft),
    ('bottomCenter', Alignment.bottomCenter),
    ('bottomRight', Alignment.bottomRight),
  ];

  int _selected = 2;

  String get _code => [
        'Stack(',
        '  alignment: Alignment.${_alignments[_selected].$1},',
        '  children: [',
        '    Container(width: 200, height: 130), // ชั้นล่าง',
        "    const Chip(label: Text('ชั้นบน')),     // ชั้นบน",
        '  ],',
        ')',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 190,
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFEC4899)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.image_rounded,
                    size: 56,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: AnimatedAlign(
                      alignment: _alignments[_selected].$2,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite_rounded, color: Colors.pink, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'ชั้นบน',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ControlLabel(
          'alignment',
          trailing: ValueBadge('Alignment.${_alignments[_selected].$1}'),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var row = 0; row < 3; row++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var col = 0; col < 3; col++) _cell(row * 3 + col),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CodeView(code: _code, compact: true),
      ],
    );
  }

  Widget _cell(int index) {
    final selected = index == _selected;
    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: selected
            ? Icon(Icons.favorite_rounded, color: context.colors.onPrimary, size: 18)
            : null,
      ),
    );
  }
}
