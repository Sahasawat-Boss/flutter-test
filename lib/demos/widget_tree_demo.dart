import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// แตะชื่อ Widget ใน tree เพื่อไฮไลต์ส่วนนั้นบนหน้าจอจำลอง
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  // (ชื่อ, ระดับความลึก, คำอธิบาย)
  static const _nodes = <(String, int, String)>[
    ('Scaffold', 0, 'โครงหน้าจอหลัก มีช่องสำหรับ appBar และ body'),
    ('AppBar', 1, 'แถบด้านบนของหน้าจอ ใช้แสดงชื่อหน้า'),
    ('Center', 1, 'จัดลูกของมันให้อยู่กึ่งกลางพื้นที่'),
    ('Column', 2, 'เรียงลูกหลายตัวในแนวตั้ง'),
    ('Icon', 3, 'แสดงไอคอนสำเร็จรูป'),
    ('Text', 3, 'แสดงข้อความ'),
  ];

  String _selected = 'Column';

  @override
  Widget build(BuildContext context) {
    final description =
        _nodes.firstWhere((node) => node.$1 == _selected).$3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final node in _nodes) _treeNode(node.$1, node.$2)],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 6, child: _preview(context)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(_selected),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.pink, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$_selected: ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: description),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _treeNode(String name, int depth) {
    final selected = name == _selected;
    return Padding(
      padding: EdgeInsets.only(left: depth * 12.0, bottom: 6),
      child: GestureDetector(
        onTap: () => setState(() => _selected = name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? Colors.pink : context.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? Colors.pink
                  : context.colors.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Text(
            depth == 0 ? name : '└ $name',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : context.colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _preview(BuildContext context) {
    final colors = context.colors;
    return _highlight(
      'Scaffold',
      radius: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 200,
          child: ColoredBox(
            color: colors.surface,
            child: Column(
              children: [
                _highlight(
                  'AppBar',
                  child: Container(
                    height: 36,
                    width: double.infinity,
                    color: colors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My App',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _highlight(
                    'Center',
                    child: Center(
                      child: _highlight(
                        'Column',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _highlight(
                              'Icon',
                              child: Icon(Icons.flutter_dash, size: 40, color: colors.primary),
                            ),
                            const SizedBox(height: 4),
                            _highlight(
                              'Text',
                              child: const Text(
                                'Hello Widget!',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _highlight(String name, {required Widget child, double radius = 6}) {
    final selected = name == _selected;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: selected ? Colors.pink.withValues(alpha: 0.12) : Colors.transparent,
        border: Border.all(
          color: selected ? Colors.pink : Colors.transparent,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
