import 'package:flutter/material.dart';

import '../data/curriculum.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// แท็บ "ฉัน": สถิติ ความคืบหน้าแต่ละหมวด เหรียญรางวัล และการตั้งค่า
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final total = allLessons.length;
    final done = allLessons.where((lesson) => state.isCompleted(lesson.id)).length;
    final percent = total == 0 ? 0 : (done * 100 / total).round();
    final bestAll = state.bestScore('all');

    bool moduleDone(String id) => modules
        .firstWhere((module) => module.id == id)
        .lessons
        .every((lesson) => state.isCompleted(lesson.id));

    final badges = [
      _Badge('🌱', 'ก้าวแรก', 'เรียนจบ 1 บท', done >= 1),
      _Badge('🔥', 'ครึ่งทาง', 'เรียนจบครึ่งหลักสูตร', done * 2 >= total),
      _Badge('📐', 'นักจัด Layout', 'จบหมวด Layout', moduleDone('layout')),
      _Badge('🧠', 'นักทำควิซ', 'ทำควิซครั้งแรก', state.quizCount > 0),
      _Badge('💯', 'คะแนนเต็ม', 'ได้ 100% ในควิซ', state.hasPerfectQuiz),
      _Badge('🦸', 'Flutter Hero', 'เรียนจบทุกบท', done == total),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const ScreenHeader(
              title: 'โปรไฟล์ของฉัน',
              subtitle: 'ติดตามความคืบหน้าและปรับแต่งแอป',
            ),
            const SizedBox(height: 20),
            _ProfileCard(done: done, total: total, percent: percent),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatCard(emoji: '📘', value: '$done/$total', label: 'บทเรียน')),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(emoji: '🧠', value: '${state.quizCount}', label: 'ควิซที่ทำ'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    emoji: '⭐',
                    value: bestAll == null ? '–' : '$bestAll%',
                    label: 'ควิซรวม',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const SectionTitle(title: 'ความคืบหน้าแต่ละหมวด'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < modules.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _ModuleProgressRow(index: i),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            const SectionTitle(title: 'เหรียญรางวัล'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
              children: [for (final badge in badges) _BadgeTile(badge: badge)],
            ),
            const SizedBox(height: 28),
            const SectionTitle(title: 'ตั้งค่า'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ธีมของแอป',
                    style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('ตามระบบ'),
                        icon: Icon(Icons.brightness_auto_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('สว่าง'),
                        icon: Icon(Icons.light_mode_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('มืด'),
                        icon: Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                    selected: {state.themeMode},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) =>
                        AppScope.read(context).setThemeMode(selection.first),
                  ),
                  const Divider(height: 32),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.restart_alt_rounded, color: AppColors.danger),
                    title: const Text('รีเซ็ตความคืบหน้า'),
                    subtitle: const Text('ลบบทเรียนที่เรียนจบและคะแนนควิซทั้งหมด'),
                    onTap: () => _confirmReset(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Flutter Learn v1.0.0 • สร้างด้วย 💙 และ Flutter',
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final state = AppScope.read(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('รีเซ็ตความคืบหน้า?'),
        content: const Text(
          'บทเรียนที่เรียนจบและคะแนนควิซทั้งหมดจะถูกลบ และกู้คืนไม่ได้',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('รีเซ็ต'),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.resetProgress();
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.done, required this.total, required this.percent});

  final int done;
  final int total;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final level = done == total
        ? '🦸 Flutter Hero'
        : done >= 8
            ? '🚀 ใกล้เป็นโปรแล้ว'
            : done >= 4
                ? '🌿 กำลังไปได้สวย'
                : done >= 1
                    ? '🌱 เริ่มต้นแล้ว'
                    : '🐣 มือใหม่หัดบิน';
    final white80 = Colors.white.withValues(alpha: 0.8);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.flutterBlue.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const FlutterLogo(size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('นักเรียน Flutter', style: context.text.bodySmall?.copyWith(color: white80)),
                Text(
                  level,
                  style: context.text.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                RoundedProgress(
                  value: percent / 100,
                  color: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  height: 6,
                ),
                const SizedBox(height: 6),
                Text(
                  'เรียนไปแล้ว $percent% ของหลักสูตร',
                  style: context.text.labelMedium?.copyWith(color: white80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.emoji, required this.value, required this.label});

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleProgressRow extends StatelessWidget {
  const _ModuleProgressRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final module = modules[index];
    final state = AppScope.of(context);
    final total = module.lessons.length;
    final done = module.lessons.where((lesson) => state.isCompleted(lesson.id)).length;

    return Column(
      children: [
        Row(
          children: [
            Icon(module.icon, color: module.colors.first, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                module.title,
                style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$done/$total',
              style: context.text.labelLarge?.copyWith(
                color: module.colors.first,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RoundedProgress(
          value: total == 0 ? 0 : done / total,
          color: module.colors.first,
          height: 6,
        ),
      ],
    );
  }
}

class _Badge {
  const _Badge(this.emoji, this.title, this.description, this.unlocked);

  final String emoji;
  final String title;
  final String description;
  final bool unlocked;
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final _Badge badge;

  static const _greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final emoji = Text(badge.emoji, style: const TextStyle(fontSize: 34));
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      color: badge.unlocked ? null : context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (badge.unlocked)
            emoji
          else
            Opacity(
              opacity: 0.35,
              child: ColorFiltered(colorFilter: _greyscale, child: emoji),
            ),
          const SizedBox(height: 8),
          Text(
            badge.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            badge.unlocked ? badge.description : '🔒 ${badge.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
