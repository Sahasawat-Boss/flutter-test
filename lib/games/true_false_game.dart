import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/glossary.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/demo_kit.dart';
import 'game_kit.dart';

/// เกมถูก/ผิดจับเวลา: คำศัพท์กับความหมายตรงกันไหม ตอบให้ได้มากที่สุดใน 45 วินาที
/// ตอบถูกติดกันได้โบนัส ตอบผิดโดนหักเวลา
class TrueFalseGame extends StatefulWidget {
  const TrueFalseGame({super.key});

  static const id = 'true-false';
  static const colors = [Color(0xFFEA580C), Color(0xFFFBBF24)];
  static const duration = Duration(seconds: 45);
  static const penalty = Duration(seconds: 3);

  @override
  State<TrueFalseGame> createState() => _TrueFalseGameState();
}

class _Round {
  const _Round({required this.term, required this.meaning, required this.isTrue});

  final String term;
  final String meaning;
  final bool isTrue;
}

class _TrueFalseGameState extends State<TrueFalseGame> {
  final _random = Random();
  Timer? _ticker;
  Duration _left = TrueFalseGame.duration;
  late _Round _round = _nextRound();
  int _score = 0;
  int _combo = 0;
  int _answered = 0;
  int _correct = 0;

  /// true = ตอบถูก, false = ตอบผิด, null = ยังไม่มีผลให้แสดง
  bool? _flash;
  bool _started = false;
  bool _finished = false;
  bool _newBest = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  _Round _nextRound() {
    final term = glossary[_random.nextInt(glossary.length)];
    if (_random.nextBool()) {
      return _Round(term: term.term, meaning: term.meaning, isTrue: true);
    }
    GlossaryTerm other;
    do {
      other = glossary[_random.nextInt(glossary.length)];
    } while (other == term);
    return _Round(term: term.term, meaning: other.meaning, isTrue: false);
  }

  void _start() {
    setState(() {
      _started = true;
      _left = TrueFalseGame.duration;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final left = _left - const Duration(milliseconds: 100);
      if (left <= Duration.zero) {
        _finish();
      } else {
        setState(() => _left = left);
      }
    });
  }

  void _answer(bool saysTrue) {
    if (!_started || _finished) return;
    final correct = saysTrue == _round.isTrue;
    setState(() {
      _answered++;
      if (correct) {
        _correct++;
        _combo++;
        // ตอบถูกติดกันทุก 3 ข้อ ได้คะแนนต่อข้อเพิ่มขึ้น 1
        _score += 1 + _combo ~/ 3;
      } else {
        _combo = 0;
        _left -= TrueFalseGame.penalty;
      }
      _flash = correct;
      _round = _nextRound();
    });
    if (_left <= Duration.zero) _finish();
  }

  void _finish() {
    _ticker?.cancel();
    final newBest = AppScope.read(context).recordGameScore(TrueFalseGame.id, _score);
    setState(() {
      _left = Duration.zero;
      _finished = true;
      _newBest = newBest;
    });
  }

  void _restart() {
    _ticker?.cancel();
    setState(() {
      _round = _nextRound();
      _score = 0;
      _combo = 0;
      _answered = 0;
      _correct = 0;
      _flash = null;
      _finished = false;
      _newBest = false;
    });
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ถูกหรือผิด? ⚡')),
      body: SafeArea(
        child: _finished
            ? _buildResult(context)
            : _started
                ? _buildPlaying(context)
                : _buildIntro(context),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚡', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 12),
          Text(
            'คำศัพท์กับความหมายตรงกันไหม?',
            textAlign: TextAlign.center,
            style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final rule in [
                  '⏱️ มีเวลา ${TrueFalseGame.duration.inSeconds} วินาที',
                  '✅ ตรงกันกด "ถูก" ไม่ตรงกด "ผิด"',
                  '🔥 ตอบถูกติดกันทุก 3 ข้อ คะแนนต่อข้อเพิ่มขึ้น',
                  '❌ ตอบผิดโดนหัก ${TrueFalseGame.penalty.inSeconds} วินาที',
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(rule, style: context.text.bodyMedium),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: TrueFalseGame.colors.first,
              foregroundColor: Colors.white,
            ),
            onPressed: _start,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('เริ่มเลย'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaying(BuildContext context) {
    final progress = _left.inMilliseconds / TrueFalseGame.duration.inMilliseconds;
    final seconds = (_left.inMilliseconds / 1000).ceil();
    final flashColor = switch (_flash) {
      true => AppColors.success,
      false => AppColors.danger,
      null => Colors.transparent,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '⏱️ $seconds วิ',
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: seconds <= 10 ? AppColors.danger : null,
                ),
              ),
              const Spacer(),
              if (_combo >= 3) ...[
                ValueBadge('🔥 x$_combo'),
                const SizedBox(width: 8),
              ],
              ValueBadge('⭐ $_score คะแนน'),
            ],
          ),
          const SizedBox(height: 10),
          RoundedProgress(
            value: progress,
            color: seconds <= 10 ? AppColors.danger : TrueFalseGame.colors.first,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: flashColor,
                borderRadius: BorderRadius.circular(28),
              ),
              onEnd: () {
                if (_flash != null && mounted) setState(() => _flash = null);
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _RoundCard(key: ValueKey(_answered), round: _round),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _AnswerButton(
                  label: 'ผิด',
                  icon: Icons.close_rounded,
                  color: AppColors.danger,
                  onTap: () => _answer(false),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _AnswerButton(
                  label: 'ถูก',
                  icon: Icons.check_rounded,
                  color: AppColors.success,
                  onTap: () => _answer(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final accuracy = _answered == 0 ? 0 : (_correct * 100 / _answered).round();
    return GameResultView(
      emoji: _score >= 25 ? '🏆' : _score >= 12 ? '⚡' : '💪',
      message: _score >= 25
          ? 'เร็วและแม่นสุดๆ!'
          : _score >= 12
              ? 'มือไวใช้ได้เลย!'
              : 'ลองอ่านคลังคำศัพท์แล้วกลับมาใหม่นะ',
      score: '$_score',
      scoreLabel: 'คะแนน • ตอบถูก $_correct จาก $_answered ข้อ ($accuracy%)',
      best: '${AppScope.of(context).gameBest(TrueFalseGame.id)} คะแนน',
      newBest: _newBest,
      colors: TrueFalseGame.colors,
      onRetry: _restart,
    );
  }
}

class _RoundCard extends StatelessWidget {
  const _RoundCard({super.key, required this.round});

  final _Round round;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: TrueFalseGame.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            round.term,
            textAlign: TextAlign.center,
            style: context.text.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'หมายถึง',
            style: context.text.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            round.meaning,
            textAlign: TextAlign.center,
            style: context.text.titleMedium?.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
        backgroundColor: color,
        foregroundColor: Colors.white,
        textStyle: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(label),
    );
  }
}
