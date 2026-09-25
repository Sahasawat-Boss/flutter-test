import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/lesson_tile.dart';
import 'quiz_play_screen.dart';

/// รายละเอียดหมวด: รายการบทเรียนในหมวด + ปุ่มทำควิซของหมวด
class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key, required this.module});

  final LearningModule module;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final total = module.lessons.length;
    final done = module.lessons.where((lesson) => state.isCompleted(lesson.id)).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: module.colors.first,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 56, end: 20, bottom: 16),
              expandedTitleScale: 1.3,
              title: Text(
                module.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              background: DecoratedBox(
                decoration: BoxDecoration(gradient: module.gradient),
                child: Stack(
                  children: [
                    Positioned(
                      right: -24,
                      bottom: -30,
                      child: Icon(
                        module.icon,
                        size: 180,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 62,
                      child: Text(
                        module.description,
                        maxLines: 2,
                        style: context.text.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                AppCard(
                  child: Row(
                    children: [
                      Text(
                        'ความคืบหน้า',
                        style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoundedProgress(
                          value: total == 0 ? 0 : done / total,
                          color: module.colors.first,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$done/$total',
                        style: context.text.titleSmall?.copyWith(
                          color: module.colors.first,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (final lesson in module.lessons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LessonTile(lesson: lesson),
                  ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: module.colors.first,
                  ),
                  onPressed: () => Navigator.push(
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
                  icon: const Icon(Icons.psychology_rounded),
                  label: Text('ทำควิซของหมวดนี้ (${module.questions.length} ข้อ)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
