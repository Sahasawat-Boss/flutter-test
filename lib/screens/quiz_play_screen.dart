import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/demo_kit.dart';

/// หน้าทำควิซ: ตอบทีละข้อ เฉลยทันที แล้วสรุปคะแนนตอนจบ
class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.colors,
    this.quizId,
  });

  final String title;
  final List<QuizQuestion> questions;
  final List<Color> colors;

  /// ใช้บันทึกคะแนนสูงสุด (null = ไม่บันทึก)
  final String? quizId;

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

enum _OptionStatus { idle, correct, wrong, dimmed }

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late List<QuizQuestion> _questions = _shuffled();
  int _index = 0;
  int? _selected;
  int _correct = 0;
  bool _finished = false;
  bool _newBest = false;

  List<QuizQuestion> _shuffled() => List.of(widget.questions)..shuffle();

  QuizQuestion get _current => _questions[_index];

  int get _percent => (_correct * 100 / _questions.length).round();

  void _choose(int option) {
    if (_selected != null) return;
    setState(() {
      _selected = option;
      if (option == _current.answer) _correct++;
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    final quizId = widget.quizId;
    final newBest =
        quizId != null && AppScope.read(context).recordScore(quizId, _percent);
    setState(() {
      _finished = true;
      _newBest = newBest;
    });
  }

  void _restart() {
    setState(() {
      _questions = _shuffled();
      _index = 0;
      _selected = null;
      _correct = 0;
      _finished = false;
      _newBest = false;
    });
  }

  _OptionStatus _statusOf(int option) {
    final selected = _selected;
    if (selected == null) return _OptionStatus.idle;
    if (option == _current.answer) return _OptionStatus.correct;
    if (option == selected) return _OptionStatus.wrong;
    return _OptionStatus.dimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: _finished
            ? _ResultView(
                percent: _percent,
                correct: _correct,
                total: _questions.length,
                newBest: _newBest,
                colors: widget.colors,
                onRetry: _restart,
              )
            : _buildQuestion(context),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final question = _current;
    final total = _questions.length;
    final answered = _selected != null;
    final isLast = _index == total - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'ข้อ ${_index + 1} จาก $total',
                    style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  ValueBadge('✓ ถูก $_correct ข้อ'),
                ],
              ),
              const SizedBox(height: 10),
              RoundedProgress(
                value: (_index + (answered ? 1 : 0)) / total,
                color: widget.colors.first,
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder: (current, previous) => Stack(
              fit: StackFit.expand,
              children: [...previous, if (current != null) current],
            ),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: ListView(
              key: ValueKey(_index),
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: widget.colors.first.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'คำถาม',
                        style: context.text.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.question,
                        style: context.text.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < question.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OptionTile(
                      letter: String.fromCharCode(0x41 + i),
                      text: question.options[i],
                      status: _statusOf(i),
                      onTap: () => _choose(i),
                    ),
                  ),
                if (answered)
                  _ExplanationCard(
                    correct: _selected == question.answer,
                    text: question.explanation,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: widget.colors.first,
              foregroundColor: Colors.white,
            ),
            onPressed: answered ? _next : null,
            child: Text(
              !answered
                  ? 'เลือกคำตอบก่อนนะ'
                  : isLast
                      ? 'ดูผลคะแนน 🎯'
                      : 'ข้อต่อไป →',
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.text,
    required this.status,
    required this.onTap,
  });

  final String letter;
  final String text;
  final _OptionStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = switch (status) {
      _OptionStatus.correct => AppColors.success,
      _OptionStatus.wrong => AppColors.danger,
      _ => colors.primary,
    };
    final highlighted =
        status == _OptionStatus.correct || status == _OptionStatus.wrong;
    final borderRadius = BorderRadius.circular(18);

    final Widget leading = switch (status) {
      _OptionStatus.correct =>
        const Icon(Icons.check_rounded, color: Colors.white, size: 18),
      _OptionStatus.wrong =>
        const Icon(Icons.close_rounded, color: Colors.white, size: 18),
      _ => Text(
          letter,
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
        ),
    };

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: status == _OptionStatus.dimmed ? 0.5 : 1,
      child: Material(
        color: highlighted ? accent.withValues(alpha: 0.12) : context.cardColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: status == _OptionStatus.idle ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: highlighted
                    ? accent
                    : colors.outlineVariant.withValues(alpha: 0.6),
                width: highlighted ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: highlighted ? accent : colors.primary.withValues(alpha: 0.1),
                  ),
                  child: leading,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.correct, required this.text});

  final bool correct;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.warning;
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(correct ? '🎉' : '💡', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct ? 'ถูกต้อง!' : 'ยังไม่ถูกนะ ลองดูคำอธิบาย',
                  style: context.text.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(text, style: context.text.bodyMedium?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.percent,
    required this.correct,
    required this.total,
    required this.newBest,
    required this.colors,
    required this.onRetry,
  });

  final int percent;
  final int correct;
  final int total;
  final bool newBest;
  final List<Color> colors;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (emoji, message) = percent == 100
        ? ('🏆', 'สมบูรณ์แบบ! คุณคือ Flutter Master')
        : percent >= 70
            ? ('🎉', 'เก่งมาก! เข้าใจเนื้อหาดีเลย')
            : percent >= 40
                ? ('💪', 'ใกล้แล้ว! ทบทวนอีกนิดนะ')
                : ('📚', 'ไม่เป็นไร ลองกลับไปอ่านบทเรียนอีกครั้ง');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent / 100),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 14,
                      strokeCap: StrokeCap.round,
                      color: colors.first,
                      backgroundColor: colors.first.withValues(alpha: 0.15),
                    ),
                    Center(
                      child: Text(
                        '${(value * 100).round()}%',
                        style: context.text.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'ตอบถูก $correct จาก $total ข้อ',
              style: context.text.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            if (newBest) ...[
              const SizedBox(height: 12),
              const Pill(
                '⭐ ทำลายสถิติเดิมได้!',
                background: Color(0x33F59E0B),
                foreground: Color(0xFFB45309),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: colors.first,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('ทำอีกครั้ง'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: () => Navigator.pop(context),
              child: const Text('กลับ'),
            ),
          ],
        ),
      ),
    );
  }
}
