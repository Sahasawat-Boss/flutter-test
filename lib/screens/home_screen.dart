import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/curriculum.dart';
import '../data/glossary.dart';
import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/module_card.dart';
import 'glossary_screen.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenTab});

  /// เปลี่ยนแท็บด้านล่าง (0 = หน้าแรก, 1 = บทเรียน, 2 = ควิซ, 3 = เกม, 4 = ฉัน)
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = allLessons.where((lesson) => state.isCompleted(lesson.id)).length;

    Lesson? next;
    for (final lesson in allLessons) {
      if (!state.isCompleted(lesson.id)) {
        next = lesson;
        break;
      }
    }

    final tip = dailyTips[DateTime.now().day % dailyTips.length];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _HomeHeader(done: done, total: allLessons.length),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              sliver: SliverList.list(
                children: [
                  if (next != null)
                    _ContinueCard(lesson: next, isFirst: done == 0)
                  else
                    _AllDoneCard(onTap: () => onOpenTab(2)),
                  const SizedBox(height: 28),
                  SectionTitle(
                    title: 'หมวดบทเรียน',
                    actionLabel: 'ดูทั้งหมด',
                    onAction: () => onOpenTab(1),
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < modules.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ModuleCard(module: modules[i], index: i),
                    ),
                  const SizedBox(height: 12),
                  const SectionTitle(title: 'ตัวช่วยเรียน'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ToolCard(
                          emoji: '📖',
                          title: 'คลังคำศัพท์',
                          subtitle: '${glossary.length} คำที่ควรรู้',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GlossaryScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ToolCard(
                          emoji: '🧠',
                          title: 'แบบทดสอบ',
                          subtitle: '${allQuestions.length} ข้อให้ลองทำ',
                          onTap: () => onOpenTab(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TipCard(tip: tip),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    final white80 = Colors.white.withValues(alpha: 0.8);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(top: -60, right: -40, child: _Bubble(size: 200)),
            const Positioned(bottom: -50, left: -30, child: _Bubble(size: 140)),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const FlutterLogo(size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดี นักพัฒนา 👋',
                                style: context.text.bodyMedium?.copyWith(color: white80),
                              ),
                              Text(
                                'มาเรียน Flutter กันเถอะ!',
                                style: context.text.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'สลับธีมสว่าง/มืด',
                          onPressed: () => AppScope.read(context).setThemeMode(
                            context.isDark ? ThemeMode.light : ThemeMode.dark,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                          ),
                          icon: Icon(
                            context.isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 58,
                            height: 58,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) => Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 6,
                                    strokeCap: StrokeCap.round,
                                    color: Colors.white,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  ),
                                  Center(
                                    child: Text(
                                      '${(value * 100).round()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ความคืบหน้าของคุณ',
                                  style: context.text.bodySmall?.copyWith(color: white80),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'เรียนจบ $done จาก $total บท',
                                  style: context.text.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RoundedProgress(
                                  value: progress,
                                  color: Colors.white,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.lesson, required this.isFirst});

  final Lesson lesson;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final module = moduleOf(lesson);
    return AppCard(
      radius: 24,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: module.gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(lesson.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFirst ? 'เริ่มเรียนบทแรกกันเลย' : 'เรียนต่อจากเดิม',
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${module.title} • ${lesson.minutes} นาที',
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow_rounded, color: context.colors.onPrimary),
          ),
        ],
      ),
    );
  }
}

class _AllDoneCard extends StatelessWidget {
  const _AllDoneCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 24,
      onTap: onTap,
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'คุณเรียนจบทุกบทแล้ว!',
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'ลองท้าทายตัวเองด้วยควิซรวมดูสิ',
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            title,
            style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('💡', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เกร็ดความรู้วันนี้',
                  style: context.text.labelLarge?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(tip, style: context.text.bodyMedium?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
