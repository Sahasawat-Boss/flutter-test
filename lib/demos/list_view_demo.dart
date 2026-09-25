import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/demo_kit.dart';

/// รายการผลไม้: เพิ่มด้วยปุ่ม + และปัดเพื่อลบ
class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _Fruit {
  const _Fruit(this.id, this.emoji, this.name);

  final int id;
  final String emoji;
  final String name;
}

class _ListViewDemoState extends State<ListViewDemo> {
  static const _pool = [
    ('🍎', 'แอปเปิล'),
    ('🍌', 'กล้วย'),
    ('🍇', 'องุ่น'),
    ('🍉', 'แตงโม'),
    ('🍓', 'สตรอว์เบอร์รี'),
    ('🥭', 'มะม่วง'),
    ('🍍', 'สับปะรด'),
    ('🥥', 'มะพร้าว'),
    ('🍊', 'ส้ม'),
    ('🍒', 'เชอร์รี'),
  ];

  final List<_Fruit> _items = [];
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      _items.add(_newFruit());
    }
  }

  _Fruit _newFruit() {
    final (emoji, name) = _pool[_nextId % _pool.length];
    return _Fruit(_nextId++, emoji, name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PreviewArea(
          height: 280,
          padding: EdgeInsets.zero,
          child: _items.isEmpty
              ? const Center(child: Text('ว่างเปล่า! กด + เพื่อเพิ่มผลไม้ 🧺'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final fruit = _items[index];
                    return Dismissible(
                      key: ValueKey(fruit.id),
                      onDismissed: (_) => setState(() => _items.remove(fruit)),
                      background: const _DeleteBackground(Alignment.centerLeft),
                      secondaryBackground:
                          const _DeleteBackground(Alignment.centerRight),
                      child: Card(
                        elevation: 0,
                        color: context.cardColor,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: context.colors.primaryContainer,
                            child: Text(fruit.emoji, style: const TextStyle(fontSize: 20)),
                          ),
                          title: Text(fruit.name),
                          subtitle: Text('index: $index'),
                          trailing: const Icon(Icons.swipe_rounded, size: 20),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'ทั้งหมด ${_items.length} รายการ',
                style: context.text.titleSmall,
              ),
            ),
            FilledButton.icon(
              onPressed: () => setState(() => _items.add(_newFruit())),
              icon: const Icon(Icons.add_rounded),
              label: const Text('เพิ่ม'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground(this.alignment);

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    );
  }
}
