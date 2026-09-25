import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// จำลอง Hot Reload: พิมพ์ข้อความแล้วหน้าจอเปลี่ยนทันที
class HelloDemo extends StatefulWidget {
  const HelloDemo({super.key});

  @override
  State<HelloDemo> createState() => _HelloDemoState();
}

class _HelloDemoState extends State<HelloDemo> {
  final _controller = TextEditingController(text: 'สวัสดี Flutter! 👋');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = _controller.text.isEmpty ? '...' : _controller.text;
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: "แก้ข้อความใน Text('...')",
            prefixIcon: const Icon(Icons.edit_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 20),
        PhoneFrame(
          child: MiniScaffold(
            title: 'My First App',
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    message,
                    key: ValueKey(message),
                    textAlign: TextAlign.center,
                    style: context.text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
