import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// ตัวไฮไลต์โค้ด Dart แบบง่าย (ใช้ RegExp แยก token แล้วระบายสี)
class DartHighlighter {
  DartHighlighter._();

  static const _keywords = {
    'abstract', 'as', 'async', 'await', 'break', 'case', 'class', 'const', //
    'continue', 'default', 'else', 'enum', 'extends', 'false', 'final', //
    'for', 'if', 'implements', 'import', 'in', 'is', 'late', 'mixin', 'new', //
    'null', 'required', 'return', 'static', 'super', 'switch', 'this', //
    'true', 'var', 'void', 'while', 'with', 'yield',
  };

  static const _builtInTypes = {'int', 'double', 'bool', 'num', 'dynamic'};

  // กลุ่ม: 1 = comment, 2 = string, 3 = annotation, 4 = number, 5 = identifier
  static final _pattern = RegExp(
    r'''(//[^\n]*)|('(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*")|(@[A-Za-z_]\w*)|(\b\d+(?:\.\d+)?\b)|([A-Za-z_]\w*)''',
  );

  static TextSpan highlight(String source, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in _pattern.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }
      final token = match[0]!;
      spans.add(TextSpan(text: token, style: _styleFor(match, token, source)));
      cursor = match.end;
    }
    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  static TextStyle? _styleFor(RegExpMatch match, String token, String source) {
    if (match[1] != null) {
      return const TextStyle(
        color: AppColors.codeComment,
        fontStyle: FontStyle.italic,
      );
    }
    if (match[2] != null) return const TextStyle(color: AppColors.codeString);
    if (match[3] != null) {
      return const TextStyle(color: AppColors.codeAnnotation);
    }
    if (match[4] != null) return const TextStyle(color: AppColors.codeNumber);
    if (_keywords.contains(token)) {
      return const TextStyle(color: AppColors.codeKeyword);
    }
    final first = token.codeUnitAt(0);
    final isCapitalized = first >= 0x41 && first <= 0x5A;
    if (isCapitalized || _builtInTypes.contains(token)) {
      return const TextStyle(color: AppColors.codeType);
    }
    if (_isFollowedByParenthesis(source, match.end)) {
      return const TextStyle(color: AppColors.codeFunction);
    }
    return null;
  }

  static bool _isFollowedByParenthesis(String source, int index) {
    var i = index;
    while (i < source.length && source[i] == ' ') {
      i++;
    }
    return i < source.length && source[i] == '(';
  }
}
