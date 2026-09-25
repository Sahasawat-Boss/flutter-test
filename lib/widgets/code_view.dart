import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../utils/dart_highlighter.dart';

/// กล่องแสดงโค้ดพร้อมไฮไลต์สีและปุ่มคัดลอก
class CodeView extends StatelessWidget {
  const CodeView({
    super.key,
    required this.code,
    this.fileName = 'main.dart',
    this.compact = false,
  });

  final String code;
  final String fileName;

  /// true = แบบย่อ ไม่มีแถบหัว ใช้แสดงโค้ดที่เปลี่ยนตามเดโม
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final source = code.trimRight();
    final baseStyle = GoogleFonts.jetBrainsMono(
      fontSize: compact ? 12 : 13,
      height: 1.6,
      color: AppColors.codeText,
    );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(compact ? 14 : 18),
        boxShadow: compact
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact)
            _CodeHeader(
              fileName: fileName,
              onCopy: () => _copy(context, source),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(16, compact ? 12 : 4, 16, compact ? 12 : 16),
            child: Text.rich(DartHighlighter.highlight(source, baseStyle)),
          ),
        ],
      ),
    );
  }

  void _copy(BuildContext context, String source) {
    Clipboard.setData(ClipboardData(text: source));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('คัดลอกโค้ดแล้ว ✓'),
          duration: Duration(milliseconds: 1500),
        ),
      );
  }
}

class _CodeHeader extends StatelessWidget {
  const _CodeHeader({required this.fileName, required this.onCopy});

  final String fileName;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 4, 2),
      child: Row(
        children: [
          const _Dot(Color(0xFFFF5F57)),
          const SizedBox(width: 6),
          const _Dot(Color(0xFFFEBC2E)),
          const SizedBox(width: 6),
          const _Dot(Color(0xFF28C840)),
          const SizedBox(width: 12),
          Text(
            fileName,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: AppColors.codeComment,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'คัดลอกโค้ด',
            onPressed: onCopy,
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            color: AppColors.codeComment,
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
