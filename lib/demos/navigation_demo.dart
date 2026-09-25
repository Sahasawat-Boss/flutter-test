import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// push ไปหน้าใหม่ เลือกผลไม้ แล้ว pop กลับพร้อมค่า
class NavigationDemo extends StatefulWidget {
  const NavigationDemo({super.key});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  String? _result;
  bool _hasReturned = false;

  Future<void> _open() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const _PickFruitPage()),
    );
    if (!mounted) return;
    setState(() {
      _result = result;
      _hasReturned = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String display;
    if (!_hasReturned) {
      display = 'ยังไม่ได้ไปหน้าใหม่';
    } else if (_result == null) {
      display = 'ได้ค่า null\n(กดย้อนกลับโดยไม่เลือก)';
    } else {
      display = _result!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ค่าที่ได้กลับมาจาก Navigator.pop',
                  style: context.text.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    display,
                    key: ValueKey(display),
                    textAlign: TextAlign.center,
                    style: _result != null
                        ? const TextStyle(fontSize: 48)
                        : context.text.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _open,
          icon: const Icon(Icons.north_east_rounded),
          label: const Text('Navigator.push() ไปหน้าใหม่'),
        ),
      ],
    );
  }
}

class _PickFruitPage extends StatelessWidget {
  const _PickFruitPage();

  static const _fruits = ['🍎', '🍌', '🍇', '🍉', '🍓', '🥭', '🍍', '🍒', '🥝'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกผลไม้ 1 อย่าง')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'นี่คือหน้าใหม่ที่ถูก push เข้ามา 🎉\nแตะผลไม้เพื่อ pop กลับไปพร้อมส่งค่า',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.onPrimaryContainer),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (final fruit in _fruits)
                  Material(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context, fruit),
                      child: Center(
                        child: Text(fruit, style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
