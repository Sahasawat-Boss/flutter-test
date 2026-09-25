import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// รวมปุ่มแบบต่างๆ ให้ลองกด
class ButtonsDemo extends StatefulWidget {
  const ButtonsDemo({super.key});

  @override
  State<ButtonsDemo> createState() => _ButtonsDemoState();
}

class _ButtonsDemoState extends State<ButtonsDemo> {
  String _last = 'ยังไม่ได้กดปุ่มไหนเลย';

  void _pressed(String name) => setState(() => _last = 'คุณกด $name 👆');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pressed('ElevatedButton'),
                child: const Text('Elevated'),
              ),
              FilledButton(
                onPressed: () => _pressed('FilledButton'),
                child: const Text('Filled'),
              ),
              FilledButton.tonal(
                onPressed: () => _pressed('FilledButton.tonal'),
                child: const Text('Tonal'),
              ),
              OutlinedButton(
                onPressed: () => _pressed('OutlinedButton'),
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: () => _pressed('TextButton'),
                child: const Text('Text'),
              ),
              IconButton.filled(
                onPressed: () => _pressed('IconButton'),
                icon: const Icon(Icons.favorite_rounded),
              ),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () => _pressed('FloatingActionButton'),
                child: const Icon(Icons.add_rounded),
              ),
              const FilledButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(_last),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _last,
              textAlign: TextAlign.center,
              style: context.text.titleSmall?.copyWith(
                color: context.colors.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
