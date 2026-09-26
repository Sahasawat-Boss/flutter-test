import 'package:flutter/material.dart';

import '../games/layout_guess_game.dart';
import '../games/memory_match_game.dart';
import '../games/true_false_game.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// แท็บ "เกม": มินิเกมทบทวนความรู้ พร้อมสถิติที่ดีที่สุดของแต่ละเกม
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    String? best(String id, String Function(int value) format) {
      final value = state.gameBest(id);
      return value == null ? null : format(value);
    }

    final games = [
      _GameInfo(
        emoji: '🃏',
        title: 'จับคู่คำศัพท์',
        description: 'เปิดการ์ดหาคู่คำศัพท์กับความหมาย ยิ่งเปิดน้อยยิ่งเก่ง',
        colors: MemoryMatchGame.colors,
        best: best(MemoryMatchGame.id, (value) => 'ดีสุด $value ครั้ง'),
        builder: (context) => const MemoryMatchGame(),
      ),
      _GameInfo(
        emoji: '⚡',
        title: 'ถูกหรือผิด?',
        description: 'ตอบให้ไวใน ${TrueFalseGame.duration.inSeconds} วินาที คำศัพท์กับความหมายตรงกันไหม',
        colors: TrueFalseGame.colors,
        best: best(TrueFalseGame.id, (value) => 'สูงสุด $value'),
        builder: (context) => const TrueFalseGame(),
      ),
      _GameInfo(
        emoji: '📐',
        title: 'ทายโค้ด Layout',
        description: 'ดูหน้าตาของ Row / Column แล้วเลือกโค้ดที่ถูกต้อง',
        colors: LayoutGuessGame.colors,
        best: best(LayoutGuessGame.id, (value) => '$value/${LayoutGuessGame.rounds}'),
        builder: (context) => const LayoutGuessGame(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const ScreenHeader(
              title: 'มินิเกม 🎮',
              subtitle: 'พักจากบทเรียน มาทบทวนแบบสนุกๆ กัน',
            ),
            const SizedBox(height: 20),
            for (final game in games)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _GameCard(game: game),
              ),
          ],
        ),
      ),
    );
  }
}

class _GameInfo {
  const _GameInfo({
    required this.emoji,
    required this.title,
    required this.description,
    required this.colors,
    required this.best,
    required this.builder,
  });

  final String emoji;
  final String title;
  final String description;
  final List<Color> colors;

  /// ข้อความสถิติดีที่สุด หรือ null ถ้ายังไม่เคยเล่น
  final String? best;
  final WidgetBuilder builder;
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final _GameInfo game;

  @override
  Widget build(BuildContext context) {
    final accent = game.colors.first;
    final best = game.best;

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: game.builder)),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: game.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(game.emoji, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  game.description,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Pill(
                  best ?? 'ยังไม่เคยเล่น',
                  background: best == null
                      ? context.colors.surfaceContainerHighest
                      : accent.withValues(alpha: 0.14),
                  foreground: best == null ? context.colors.onSurfaceVariant : accent,
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_fill_rounded, color: accent, size: 36),
        ],
      ),
    );
  }
}
