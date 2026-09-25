import 'package:flutter/material.dart';

import '../data/curriculum.dart';
import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'quiz_play_screen.dart';

/// แท็บ "ควิซ": ควิซรวม + ควิซแยกตามหมวด พร้อมคะแนนสูงสุด
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const ScreenHeader(
              title: 'แบบทดสอบ 🧠',
              subtitle: 'ทบทวนความรู้ ทำซ้ำได้ไม่จำกัดครั้ง',
            ),
            const SizedBox(height: 20),
            _ChallengeCard(best: state.bestScore('all')),
            const SizedBox(height: 28),
            const SectionTitle(title: 'ควิซตามหมวด'),
            const SizedBox(height: 12),
            for (final module in modules)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ModuleQuizTile(module: module, best: state.bestScore(module.id)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.best});

  final int? best;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.flutterBlue.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -10,
            top: -10,
            child: Text('🏆', style: TextStyle(fontSize: 96)),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Pill('ความท้าทายรวม'),
                const SizedBox(height: 14),
                Text(
                  'ควิซรวมทุกบทเรียน',
                  style: context.text.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${allQuestions.length} ข้อ สุ่มลำดับใหม่ทุกครั้ง',
                  style: context.text.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.heroGradient.first,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPlayScreen(
                            title: 'ควิซรวมทุกบท',
                            questions: allQuestions,
                            colors: AppColors.heroGradient,
                            quizId: 'all',
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('เริ่มเลย'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      best == null ? 'ยังไม่เคยทำ' : 'สูงสุด $best%',
                      style: context.text.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleQuizTile extends StatelessWidget {
  const _ModuleQuizTile({required this.module, required this.best});

  final LearningModule module;
  final int? best;

  @override
  Widget build(BuildContext context) {
    final accent = module.colors.first;
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPlayScreen(
            title: 'ควิซ: ${module.title}',
            questions: module.questions,
            colors: module.colors,
            quizId: module.id,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: module.gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(module.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${module.questions.length} ข้อ',
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Pill(
            best == null ? 'ยังไม่เคยทำ' : 'สูงสุด $best%',
            background: best == null
                ? context.colors.surfaceContainerHighest
                : accent.withValues(alpha: 0.14),
            foreground: best == null ? context.colors.onSurfaceVariant : accent,
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
