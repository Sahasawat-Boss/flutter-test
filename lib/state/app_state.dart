import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// เก็บความคืบหน้าของผู้เรียน (บทที่เรียนจบ, คะแนนควิซ, สถิติเกม, ธีม)
/// และบันทึกลงเครื่องด้วย SharedPreferences
class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _completed.addAll(_prefs.getStringList(_kCompleted) ?? const <String>[]);

    _loadScores(_kScores, _bestScores);
    _loadScores(_kGameScores, _gameScores);

    final themeIndex = _prefs.getInt(_kTheme) ?? 0;
    if (themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }
  }

  static const _kCompleted = 'completed_lessons';
  static const _kScores = 'quiz_best_scores';
  static const _kGameScores = 'game_best_scores';
  static const _kTheme = 'theme_mode';

  final SharedPreferences _prefs;
  final Set<String> _completed = {};
  final Map<String, int> _bestScores = {};
  final Map<String, int> _gameScores = {};
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool isCompleted(String lessonId) => _completed.contains(lessonId);

  /// คะแนนสูงสุด (เปอร์เซ็นต์) ของควิซนั้นๆ หรือ null ถ้ายังไม่เคยทำ
  int? bestScore(String quizId) => _bestScores[quizId];

  int get quizCount => _bestScores.length;

  bool get hasPerfectQuiz => _bestScores.values.any((score) => score == 100);

  void setCompleted(String lessonId, bool completed) {
    final changed =
        completed ? _completed.add(lessonId) : _completed.remove(lessonId);
    if (!changed) return;
    _prefs.setStringList(_kCompleted, _completed.toList());
    notifyListeners();
  }

  /// บันทึกคะแนนถ้าดีกว่าเดิม คืนค่า true เมื่อทำลายสถิติเดิมได้
  bool recordScore(String quizId, int percent) {
    final previous = _bestScores[quizId];
    if (previous != null && previous >= percent) return false;
    _bestScores[quizId] = percent;
    _saveScores(_kScores, _bestScores);
    notifyListeners();
    return previous != null;
  }

  /// สถิติที่ดีที่สุดของเกมนั้นๆ หรือ null ถ้ายังไม่เคยเล่น
  int? gameBest(String gameId) => _gameScores[gameId];

  /// บันทึกสถิติเกมถ้าดีกว่าเดิม คืนค่า true เมื่อทำลายสถิติเดิมได้
  /// ใช้ [lowerIsBetter] กับเกมที่ยิ่งน้อยยิ่งดี เช่น จำนวนครั้งที่เปิดการ์ด
  bool recordGameScore(String gameId, int score, {bool lowerIsBetter = false}) {
    final previous = _gameScores[gameId];
    if (previous != null &&
        (lowerIsBetter ? previous <= score : previous >= score)) {
      return false;
    }
    _gameScores[gameId] = score;
    _saveScores(_kGameScores, _gameScores);
    notifyListeners();
    return previous != null;
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    _prefs.setInt(_kTheme, mode.index);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _completed.clear();
    _bestScores.clear();
    _gameScores.clear();
    notifyListeners();
    await _prefs.remove(_kCompleted);
    await _prefs.remove(_kScores);
    await _prefs.remove(_kGameScores);
  }

  /// แปลงรายการ "id:คะแนน" จาก SharedPreferences กลับเป็น Map
  void _loadScores(String key, Map<String, int> target) {
    for (final entry in _prefs.getStringList(key) ?? const <String>[]) {
      final separator = entry.lastIndexOf(':');
      if (separator <= 0) continue;
      final score = int.tryParse(entry.substring(separator + 1));
      if (score != null) target[entry.substring(0, separator)] = score;
    }
  }

  void _saveScores(String key, Map<String, int> scores) {
    _prefs.setStringList(key, [
      for (final entry in scores.entries) '${entry.key}:${entry.value}',
    ]);
  }
}

/// ส่ง [AppState] ลงไปให้ทุก Widget ใน tree
/// ใช้ `AppScope.of(context)` ใน build() และ `AppScope.read(context)` ใน callback
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'ไม่พบ AppScope ใน widget tree');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'ไม่พบ AppScope ใน widget tree');
    return scope!.notifier!;
  }
}
