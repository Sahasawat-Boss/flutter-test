import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../screens/module_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// การ์ดหมวดบทเรียนแบบ gradient บนหน้าแรก
class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module, required this.index});

  final LearningModule module;
  final int index;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final total = module.lessons.length;
    final done = module.lessons.where((lesson) => state.isCompleted(lesson.id)).length;
    final borderRadius = BorderRadius.circular(24);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: module.gradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: module.colors.first.withValues(alpha: context.isDark ? 0.2 : 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ModuleScreen(module: module)),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -12,
                bottom: -20,
                child: Icon(
                  module.icon,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(module.icon, color: Colors.white),
                        ),
                        const Spacer(),
                        Pill('หมวด ${index + 1}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      module.title,
                      style: context.text.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: context.text.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedProgress(
                            value: total == 0 ? 0 : done / total,
                            color: Colors.white,
                            backgroundColor: Colors.white.withValues(alpha: 0.25),
                            height: 6,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$done/$total บท',
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
        ),
      ),
    );
  }
}
