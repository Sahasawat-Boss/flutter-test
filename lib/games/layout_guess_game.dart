import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/demo_kit.dart';
import 'game_kit.dart';

/// เกมทายโค้ด Layout: ดูหน้าตาของ Row/Column แล้วเลือกโค้ดที่สร้างมันขึ้นมา
class LayoutGuessGame extends StatefulWidget {
  const LayoutGuessGame({super.key});

  static const id = 'layout-guess';
  static const rounds = 10;
  static const colors = [Color(0xFF059669), Color(0xFF34D399)];

  @override
  State<LayoutGuessGame> createState() => _LayoutGuessGameState();
}

/// ค่าที่ใช้สุ่มโจทย์ (ตัด stretch/baseline ออก เพราะดูจากภาพแยกยาก)
const _mainOptions = [
  MainAxisAlignment.start,
  MainAxisAlignment.center,
  MainAxisAlignment.end,
  MainAxisAlignment.spaceBetween,
  MainAxisAlignment.spaceAround,
  MainAxisAlignment.spaceEvenly,
];
const _crossOptions = [
  CrossAxisAlignment.start,
  CrossAxisAlignment.center,
  CrossAxisAlignment.end,
];

class _LayoutConfig {
  const _LayoutConfig(this.isRow, this.main, this.cross);

  final bool isRow;
  final MainAxisAlignment main;
  final CrossAxisAlignment cross;

  String get code => '${isRow ? 'Row' : 'Column'}(\n'
      '  mainAxisAlignment: MainAxisAlignment.${main.name},\n'
      '  crossAxisAlignment: CrossAxisAlignment.${cross.name},\n'
      ')';

  @override
  bool operator ==(Object other) =>
      other is _LayoutConfig &&
      other.isRow == isRow &&
      other.main == main &&
      other.cross == cross;

  @override
  int get hashCode => Object.hash(isRow, main, cross);
}

class _LayoutGuessGameState extends State<LayoutGuessGame> {
  final _random = Random();
  late _LayoutConfig _answer;
  late List<_LayoutConfig> _options;
  int _round = 0;
  int _correct = 0;
  int? _selected;
  bool _finished = false;
  bool _newBest = false;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  _LayoutConfig _randomConfig(bool isRow) => _LayoutConfig(
        isRow,
        _mainOptions[_random.nextInt(_mainOptions.length)],
        _crossOptions[_random.nextInt(_crossOptions.length)],
      );

  void _newRound() {
    _answer = _randomConfig(_random.nextBool());
    // ตัวหลอกใช้ Row/Column แบบเดียวกัน ต้องดู alignment ถึงจะตอบได้
    final options = {_answer};
    while (options.length < 4) {
      options.add(_randomConfig(_answer.isRow));
    }
    _options = options.toList()..shuffle(_random);
    _selected = null;
  }

  void _choose(int index) {
    if (_selected != null) return;
    setState(() {
      _selected = index;
      if (_options[index] == _answer) _correct++;
    });
  }

  void _next() {
    if (_round < LayoutGuessGame.rounds - 1) {
      setState(() {
        _round++;
        _newRound();
      });
      return;
    }
    final newBest =
        AppScope.read(context).recordGameScore(LayoutGuessGame.id, _correct);
    setState(() {
      _finished = true;
      _newBest = newBest;
    });
  }

  void _restart() {
    setState(() {
      _round = 0;
      _correct = 0;
      _finished = false;
      _newBest = false;
      _newRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ทายโค้ด Layout 📐')),
      body: SafeArea(
        child: _finished ? _buildResult(context) : _buildRound(context),
      ),
    );
  }

  Widget _buildRound(BuildContext context) {
    final answered = _selected != null;
    final isLast = _round == LayoutGuessGame.rounds - 1;

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
                    'ข้อ ${_round + 1} จาก ${LayoutGuessGame.rounds}',
                    style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  ValueBadge('✓ ถูก $_correct ข้อ'),
                ],
              ),
              const SizedBox(height: 10),
              RoundedProgress(
                value: (_round + (answered ? 1 : 0)) / LayoutGuessGame.rounds,
                color: LayoutGuessGame.colors.first,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'โค้ดไหนสร้างหน้าตาแบบนี้?',
                style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _LayoutPreview(config: _answer),
              const SizedBox(height: 20),
              for (var i = 0; i < _options.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CodeOption(
                    code: _options[i].code,
                    status: !answered
                        ? null
                        : _options[i] == _answer
                            ? true
                            : i == _selected
                                ? false
                                : null,
                    dimmed: answered && _options[i] != _answer && i != _selected,
                    onTap: () => _choose(i),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: LayoutGuessGame.colors.first,
              foregroundColor: Colors.white,
            ),
            onPressed: answered ? _next : null,
            child: Text(
              !answered
                  ? 'เลือกโค้ดก่อนนะ'
                  : isLast
                      ? 'ดูผลคะแนน 🎯'
                      : 'ข้อต่อไป →',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    const total = LayoutGuessGame.rounds;
    return GameResultView(
      emoji: _correct == total ? '🏆' : _correct >= 7 ? '📐' : '💪',
      message: _correct == total
          ? 'สุดยอดนักจัด Layout!'
          : _correct >= 7
              ? 'เข้าใจ Row/Column ดีมาก!'
              : 'ลองกลับไปเล่นเดโม Row & Column อีกรอบนะ',
      score: '$_correct/$total',
      scoreLabel: 'ข้อที่ตอบถูก',
      best: '${AppScope.of(context).gameBest(LayoutGuessGame.id)}/$total',
      newBest: _newBest,
      colors: LayoutGuessGame.colors,
      onRetry: _restart,
    );
  }
}

/// วาดกล่องสี 3 กล่องตาม config ของโจทย์
class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.config});

  final _LayoutConfig config;

  static const _boxes = [
    (Color(0xFF3B82F6), 44.0),
    (Color(0xFFF59E0B), 64.0),
    (Color(0xFFEC4899), 32.0),
  ];

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final (color, size) in _boxes)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
    ];

    return Container(
      height: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: config.isRow
          ? Row(
              mainAxisAlignment: config.main,
              crossAxisAlignment: config.cross,
              children: children,
            )
          : Column(
              mainAxisAlignment: config.main,
              crossAxisAlignment: config.cross,
              children: children,
            ),
    );
  }
}

class _CodeOption extends StatelessWidget {
  const _CodeOption({
    required this.code,
    required this.status,
    required this.dimmed,
    required this.onTap,
  });

  final String code;

  /// true = คำตอบที่ถูก, false = ตอบผิด, null = ปกติ
  final bool? status;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (status) {
      true => AppColors.success,
      false => AppColors.danger,
      null => Colors.transparent,
    };

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: dimmed ? 0.45 : 1,
      child: Material(
        color: AppColors.codeBackground,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: 3),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.codeText,
                    ),
                  ),
                ),
                if (status != null)
                  Icon(
                    status! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: borderColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
