import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// ฟอร์มทักทาย + ช่องรหัสผ่านพร้อมตัววัดความแข็งแรง
class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final _name = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();
    final length = _password.text.length;
    final strength = math.min(length / 12, 1.0);
    final (strengthLabel, strengthColor) = switch (length) {
      0 => ('ยังไม่ได้ตั้ง', context.colors.outline),
      < 6 => ('อ่อน 😟', AppColors.danger),
      < 10 => ('พอใช้ 🙂', AppColors.warning),
      _ => ('แข็งแรง 💪', AppColors.success),
    };
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(14));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _name,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'ชื่อของคุณ',
            hintText: 'เช่น สมชาย',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            border: border,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _obscure,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'รหัสผ่าน',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscure ? 'แสดงรหัสผ่าน' : 'ซ่อนรหัสผ่าน',
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              ),
            ),
            border: border,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: strength),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              color: strengthColor,
              backgroundColor: context.colors.surfaceContainerHighest,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'ความแข็งแรงของรหัสผ่าน: $strengthLabel',
          style: context.text.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        PreviewArea(
          child: Row(
            children: [
              const Text('👋', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    name.isEmpty
                        ? 'พิมพ์ชื่อด้านบนสิ...'
                        : 'สวัสดีคุณ $name!\nยินดีต้อนรับสู่ Flutter',
                    key: ValueKey(name),
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: name.isEmpty ? context.colors.onSurfaceVariant : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
