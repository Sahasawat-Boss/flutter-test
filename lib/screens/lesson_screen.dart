import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/curriculum.dart';
import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/lesson_block_view.dart';
import 'quiz_play_screen.dart';

/// หน้าอ่านบทเรียน: เนื้อหา → เดโม → สรุป → ควิซ → ทำเครื่องหมายว่าเรียนจบ
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final module = moduleOf(lesson);
    final done = AppScope.of(context).isCompleted(lesson.id);
    final next = nextLessonAfter(lesson);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _LessonAppBar(lesson: lesson, module: module),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList.list(
              children: [
                for (final block in lesson.blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LessonBlockView(block: block, colors: module.colors),
                  ),
                _KeyPointsCard(points: lesson.keyPoints, colors: module.colors),
                const SizedBox(height: 24),
                if (lesson.quiz.isNotEmpty) ...[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: module.colors.first,
                      side: BorderSide(color: module.colors.first.withValues(alpha: 0.5)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPlayScreen(
                          title: 'ควิซ: ${lesson.title}',
                          questions: lesson.quiz,
                          colors: module.colors,
                          quizId: 'lesson-${lesson.id}',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.psychology_rounded),
                    label: Text('ทดสอบความเข้าใจ (${lesson.quiz.length} ข้อ)'),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: done ? AppColors.success : module.colors.first,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _toggleCompleted(context, done, next),
                  icon: Icon(done ? Icons.check_circle_rounded : Icons.flag_rounded),
                  label: Text(done ? 'เรียนจบแล้ว ✓' : 'ทำเครื่องหมายว่าเรียนจบ'),
                ),
                if (next != null) ...[
                  const SizedBox(height: 20),
                  _NextLessonCard(lesson: next),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompleted(BuildContext context, bool done, Lesson? next) {
    AppScope.read(context).setCompleted(lesson.id, !done);
    if (done) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            next == null
                ? '🏆 สุดยอด! คุณเรียนครบทุกบทแล้ว'
                : '🎉 เยี่ยมมาก! ไปต่อบทถัดไปกันเลย',
          ),
        ),
      );
  }
}

class _LessonAppBar extends StatelessWidget {
  const _LessonAppBar({required this.lesson, required this.module});

  final Lesson lesson;
  final LearningModule module;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220,
      backgroundColor: module.colors.first,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, end: 20, bottom: 16),
        expandedTitleScale: 1.25,
        title: Text(
          lesson.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        background: DecoratedBox(
          decoration: BoxDecoration(gradient: module.gradient),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                bottom: -24,
                child: Icon(
                  lesson.icon,
                  size: 170,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 64,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Pill(module.title),
                    Pill('บทที่ ${lessonNumber(lesson)}'),
                    Pill('⏱ ${lesson.minutes} นาที'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyPointsCard extends StatelessWidget {
  const _KeyPointsCard({required this.points, required this.colors});

  final List<String> points;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final accent = colors.first;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.first.withValues(alpha: 0.14),
            colors.last.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📝 สรุปสั้นๆ',
            style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < points.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      points[i],
                      style: context.text.bodyMedium?.copyWith(height: 1.5),
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

class _NextLessonCard extends StatelessWidget {
  const _NextLessonCard({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final module = moduleOf(lesson);
    return AppCard(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: module.gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(lesson.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'บทถัดไป',
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: module.colors.first),
        ],
      ),
    );
  }
}
