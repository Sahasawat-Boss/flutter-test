import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';
import 'code_view.dart';
import 'common.dart';

/// แปลง [LessonBlock] แต่ละชนิดเป็น Widget ที่แสดงบนหน้าบทเรียน
class LessonBlockView extends StatelessWidget {
  const LessonBlockView({super.key, required this.block, required this.colors});

  final LessonBlock block;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      ParagraphBlock(:final text) => Text(
          text,
          style: context.text.bodyLarge?.copyWith(height: 1.75),
        ),
      HeadingBlock(:final text) => _Heading(text: text, colors: colors),
      BulletsBlock(:final items) => _Bullets(items: items, color: colors.first),
      CalloutBlock callout => _Callout(block: callout),
      CodeBlock(:final code, :final fileName) =>
        CodeView(code: code, fileName: fileName),
      DemoBlock demo => DemoCard(demo: demo, colors: colors),
    };
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.text, required this.colors});

  final String text;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items, required this.color});

  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 18,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_rounded, size: 20, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      items[i],
                      style: context.text.bodyLarge?.copyWith(height: 1.55),
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

class _Callout extends StatelessWidget {
  const _Callout({required this.block});

  final CalloutBlock block;

  @override
  Widget build(BuildContext context) {
    final (emoji, label, color) = switch (block.kind) {
      CalloutKind.analogy => ('💡', 'เปรียบเทียบง่ายๆ', AppColors.warning),
      CalloutKind.tip => ('✨', 'เคล็ดลับ', AppColors.success),
      CalloutKind.warning => ('⚠️', 'ระวัง!', AppColors.danger),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDark ? 0.14 : 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.text.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  block.text,
                  style: context.text.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// กรอบรอบเดโมแบบ interactive
class DemoCard extends StatelessWidget {
  const DemoCard({super.key, required this.demo, required this.colors});

  final DemoBlock demo;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final accent = colors.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ลองเล่นเลย!',
                      style: context.text.labelMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      demo.title,
                      style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (demo.hint != null) ...[
            const SizedBox(height: 10),
            Text(
              demo.hint!,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          demo.child,
        ],
      ),
    );
  }
}
