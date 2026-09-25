import 'package:flutter/material.dart';
import 'package:flutter_learn/data/curriculum.dart';
import 'package:flutter_learn/state/app_state.dart';
import 'package:flutter_learn/utils/dart_highlighter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('หลักสูตร', () {
    test('id ของบทเรียนไม่ซ้ำกัน', () {
      final ids = allLessons.map((lesson) => lesson.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('ทุกคำถามมีคำตอบที่ถูกอยู่ในตัวเลือก', () {
      for (final question in allQuestions) {
        expect(question.answer, inInclusiveRange(0, question.options.length - 1),
            reason: question.question);
      }
    });

    test('nextLessonAfter คืน null เมื่อเป็นบทสุดท้าย', () {
      expect(nextLessonAfter(allLessons.last), isNull);
      expect(nextLessonAfter(allLessons.first), allLessons[1]);
    });
  });

  group('AppState', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('บันทึกบทเรียนที่เรียนจบ และโหลดกลับมาได้', () {
      AppState(prefs).setCompleted('stack', true);
      expect(AppState(prefs).isCompleted('stack'), isTrue);
    });

    test('recordScore เก็บเฉพาะคะแนนสูงสุด', () {
      final state = AppState(prefs);
      expect(state.recordScore('lesson-stack', 50), isFalse); // ครั้งแรก
      expect(state.recordScore('lesson-stack', 40), isFalse);
      expect(state.recordScore('lesson-stack', 100), isTrue);
      expect(AppState(prefs).bestScore('lesson-stack'), 100);
      expect(AppState(prefs).hasPerfectQuiz, isTrue);
    });

    test('resetProgress ล้างข้อมูลทั้งหมด', () async {
      final state = AppState(prefs)
        ..setCompleted('stack', true)
        ..recordScore('all', 80);
      await state.resetProgress();
      expect(state.isCompleted('stack'), isFalse);
      expect(AppState(prefs).quizCount, 0);
    });
  });

  test('DartHighlighter ไม่ทำให้ข้อความหายหรือเพี้ยน', () {
    const source = "final name = 'Flutter'; // comment\nText('\$name', style: 24);";
    final span = DartHighlighter.highlight(source, const TextStyle());
    expect(span.toPlainText(), source);
  });
}
