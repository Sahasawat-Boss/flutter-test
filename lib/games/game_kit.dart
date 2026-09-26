import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// หน้าสรุปผลหลังจบเกม ใช้ร่วมกันทุกเกม
class GameResultView extends StatelessWidget {
  const GameResultView({
    super.key,
    required this.emoji,
    required this.message,
    required this.score,
    required this.scoreLabel,
    required this.best,
    required this.newBest,
    required this.colors,
    required this.onRetry,
  });

  final String emoji;
  final String message;

  /// ตัวเลขผลลัพธ์รอบนี้ เช่น "12" หรือ "8/10"
  final String score;
  final String scoreLabel;

  /// สถิติที่ดีที่สุด (หลังบันทึกรอบนี้แล้ว)
  final String best;
  final bool newBest;
  final List<Color> colors;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Text(emoji, style: const TextStyle(fontSize: 72)),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    score,
                    style: context.text.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    scoreLabel,
                    style: context.text.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              newBest ? '🎉 ทำลายสถิติเดิมได้! ($best)' : 'สถิติดีที่สุด: $best',
              style: context.text.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: newBest ? AppColors.success : context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: colors.first,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('เล่นอีกครั้ง'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: () => Navigator.pop(context),
              child: const Text('กลับไปหน้าเกม'),
            ),
          ],
        ),
      ),
    );
  }
}
