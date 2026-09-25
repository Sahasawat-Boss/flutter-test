import 'package:flutter/material.dart';

/// ชิ้นส่วนเนื้อหาในบทเรียน เช่น ย่อหน้า, โค้ด, เดโม
sealed class LessonBlock {
  const LessonBlock();
}

class ParagraphBlock extends LessonBlock {
  const ParagraphBlock(this.text);
  final String text;
}

class HeadingBlock extends LessonBlock {
  const HeadingBlock(this.text);
  final String text;
}

class BulletsBlock extends LessonBlock {
  const BulletsBlock(this.items);
  final List<String> items;
}

enum CalloutKind { analogy, tip, warning }

class CalloutBlock extends LessonBlock {
  const CalloutBlock(this.kind, this.text);
  final CalloutKind kind;
  final String text;
}

class CodeBlock extends LessonBlock {
  const CodeBlock(this.code, {this.fileName = 'main.dart'});
  final String code;
  final String fileName;
}

/// เดโมที่ผู้เรียนลองกด/ปรับค่าได้จริง
class DemoBlock extends LessonBlock {
  const DemoBlock({required this.title, required this.child, this.hint});
  final String title;
  final String? hint;
  final Widget child;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  final String question;
  final List<String> options;

  /// index ของคำตอบที่ถูกใน [options]
  final int answer;
  final String explanation;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.icon,
    required this.minutes,
    required this.blocks,
    required this.keyPoints,
    required this.quiz,
  });

  final String id;
  final String title;
  final String summary;
  final IconData icon;
  final int minutes;
  final List<LessonBlock> blocks;
  final List<String> keyPoints;
  final List<QuizQuestion> quiz;
}

class LearningModule {
  const LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
    required this.lessons,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final List<Lesson> lessons;

  LinearGradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  List<QuizQuestion> get questions => [
        for (final lesson in lessons) ...lesson.quiz,
      ];
}
