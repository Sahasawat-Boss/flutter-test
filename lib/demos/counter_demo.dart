import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// ตัวนับเลข แสดงให้เห็นว่า setState() ทำให้ build() ทำงานใหม่
class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  int _count = 0;
  int _setStateCalls = 0;

  void _update(int Function(int current) change) {
    setState(() {
      _count = change(_count);
      _setStateCalls++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        PreviewArea(
          height: 160,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'count =',
                  style: context.text.titleMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$_count',
                    key: ValueKey(_count),
                    style: context.text.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              tooltip: 'ลด',
              onPressed: () => _update((c) => c - 1),
              icon: const Icon(Icons.remove_rounded),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => _update((c) => c + 1),
              icon: const Icon(Icons.add_rounded),
              label: const Text('เพิ่ม'),
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              tooltip: 'รีเซ็ต',
              onPressed: () => _update((_) => 0),
              icon: const Icon(Icons.restart_alt_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'เรียก setState() ไปแล้ว $_setStateCalls ครั้ง\n→ build() ทำงานใหม่ $_setStateCalls ครั้ง',
          textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
