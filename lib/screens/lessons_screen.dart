import 'package:flutter/material.dart';

import '../data/curriculum.dart';
import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/lesson_tile.dart';

/// แท็บ "บทเรียน": รายการบทเรียนทั้งหมดแยกตามหมวด
class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ScreenHeader(
                  title: 'บทเรียนทั้งหมด 📚',
                  subtitle:
                      '${allLessons.length} บทเรียน ใน ${modules.length} หมวด เรียนตามลำดับได้เลย',
                ),
              ),
            ),
            for (var i = 0; i < modules.length; i++) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: _ModuleHeader(module: modules[i], index: i),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.list(
                  children: [
                    for (final lesson in modules[i].lessons)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: LessonTile(lesson: lesson),
                      ),
                  ],
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({required this.module, required this.index});

  final LearningModule module;
  final int index;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = module.lessons.where((lesson) => state.isCompleted(lesson.id)).length;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: module.gradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(module.icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'หมวด ${index + 1}',
                style: context.text.labelSmall?.copyWith(
                  color: module.colors.first,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                module.title,
                style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Pill(
          '$done/${module.lessons.length}',
          background: module.colors.first.withValues(alpha: 0.12),
          foreground: module.colors.first,
        ),
      ],
    );
  }
}
