import 'package:flutter/material.dart';

import '../data/curriculum.dart';
import '../models/lesson.dart';
import '../screens/lesson_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// แถวบทเรียนในรายการ แสดงสถานะเรียนจบด้วยเครื่องหมายถูก
class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final done = AppScope.of(context).isCompleted(lesson.id);
    final module = moduleOf(lesson);
    final accent = module.colors.first;

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: done ? module.gradient : null,
              color: done ? null : accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: done
                ? const Icon(Icons.check_rounded, color: Colors.white)
                : Icon(lesson.icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'บทที่ ${lessonNumber(lesson)}',
                  style: context.text.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                '${lesson.minutes} น.',
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
