import 'dart:math';

import 'package:flutter/material.dart';

import '../data/glossary.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';
import 'game_kit.dart';

/// เกมจับคู่การ์ด: เปิดการ์ดทีละ 2 ใบ หาคำศัพท์ให้ตรงกับความหมาย
/// ยิ่งเปิดน้อยครั้งยิ่งดี
class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  static const id = 'memory';
  static const pairs = 6;
  static const colors = [Color(0xFF7C3AED), Color(0xFFC084FC)];

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryCard {
  _MemoryCard({required this.pairId, required this.text, required this.isTerm});

  final int pairId;
  final String text;
  final bool isTerm;
  bool matched = false;
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  final _random = Random();
  late List<_MemoryCard> _cards = _deal();
  final List<int> _open = [];
  int _moves = 0;
  bool _busy = false;
  bool _finished = false;
  bool _newBest = false;

  List<_MemoryCard> _deal() {
    final terms = (List.of(glossary)..shuffle(_random)).take(MemoryMatchGame.pairs);
    var pairId = 0;
    return [
      for (final term in terms) ...[
        _MemoryCard(pairId: pairId, text: term.term, isTerm: true),
        _MemoryCard(pairId: pairId++, text: term.meaning, isTerm: false),
      ],
    ]..shuffle(_random);
  }

  Future<void> _flip(int index) async {
    final card = _cards[index];
    if (_busy || card.matched || _open.contains(index)) return;

    setState(() => _open.add(index));
    if (_open.length < 2) return;

    _moves++;
    final first = _cards[_open[0]];
    final second = _cards[_open[1]];
    if (first.pairId == second.pairId) {
      setState(() {
        first.matched = true;
        second.matched = true;
        _open.clear();
      });
      if (_cards.every((card) => card.matched)) _finish();
      return;
    }

    // ไม่ตรงกัน: เปิดค้างไว้ให้จำแป๊บหนึ่งแล้วค่อยปิด
    _busy = true;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _open.clear();
      _busy = false;
    });
  }

  void _finish() {
    final newBest = AppScope.read(context)
        .recordGameScore(MemoryMatchGame.id, _moves, lowerIsBetter: true);
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _finished = true;
        _newBest = newBest;
      });
    });
  }

  void _restart() {
    setState(() {
      _cards = _deal();
      _open.clear();
      _moves = 0;
      _busy = false;
      _finished = false;
      _newBest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matched = _cards.where((card) => card.matched).length ~/ 2;

    return Scaffold(
      appBar: AppBar(title: const Text('จับคู่คำศัพท์ 🃏')),
      body: SafeArea(
        child: _finished
            ? _buildResult(context)
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'จับคู่ได้ $matched/${MemoryMatchGame.pairs}',
                          style: context.text.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        ValueBadge('🔄 เปิด $_moves ครั้ง'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _buildGrid()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGrid() {
    const columns = 3;
    const spacing = 10.0;
    final rows = (_cards.length / columns).ceil();

    // คำนวณสัดส่วนการ์ดให้เต็มจอพอดีโดยไม่ต้องเลื่อน
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        final height = (constraints.maxHeight - spacing * (rows - 1)) / rows;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: width / height,
          ),
          itemBuilder: (context, index) => _CardTile(
            card: _cards[index],
            faceUp: _cards[index].matched || _open.contains(index),
            onTap: () => _flip(index),
          ),
        );
      },
    );
  }

  Widget _buildResult(BuildContext context) {
    final perfect = _moves == MemoryMatchGame.pairs;
    return GameResultView(
      emoji: perfect ? '🧠' : _moves <= 10 ? '🎉' : '💪',
      message: perfect
          ? 'ความจำระดับเทพ ไม่พลาดเลยสักครั้ง!'
          : _moves <= 10
              ? 'เก่งมาก! จำคำศัพท์ได้แม่นเลย'
              : 'จับคู่ครบแล้ว ลองใหม่ให้เปิดน้อยลงนะ',
      score: '$_moves',
      scoreLabel: 'จำนวนครั้งที่เปิดการ์ด (ยิ่งน้อยยิ่งดี)',
      best: '${AppScope.of(context).gameBest(MemoryMatchGame.id)} ครั้ง',
      newBest: _newBest,
      colors: MemoryMatchGame.colors,
      onRetry: _restart,
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.faceUp, required this.onTap});

  final _MemoryCard card;
  final bool faceUp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = MemoryMatchGame.colors.first;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: faceUp
            ? Container(
                key: const ValueKey('front'),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: card.matched
                      ? AppColors.success.withValues(alpha: 0.15)
                      : context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: card.matched ? AppColors.success : accent,
                    width: 2,
                  ),
                ),
                child: Text(
                  card.text,
                  textAlign: TextAlign.center,
                  maxLines: card.isTerm ? 3 : 7,
                  overflow: TextOverflow.ellipsis,
                  style: card.isTerm
                      ? context.text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: card.matched ? AppColors.success : accent,
                        )
                      : context.text.labelSmall?.copyWith(height: 1.3),
                ),
              )
            : Container(
                key: const ValueKey('back'),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: MemoryMatchGame.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const FlutterLogo(size: 32, style: FlutterLogoStyle.markOnly),
              ),
      ),
    );
  }
}
