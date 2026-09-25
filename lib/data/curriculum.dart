import 'package:flutter/material.dart';

import '../demos/animation_demo.dart';
import '../demos/buttons_demo.dart';
import '../demos/container_demo.dart';
import '../demos/counter_demo.dart';
import '../demos/expanded_demo.dart';
import '../demos/hello_demo.dart';
import '../demos/list_view_demo.dart';
import '../demos/navigation_demo.dart';
import '../demos/row_column_demo.dart';
import '../demos/stack_demo.dart';
import '../demos/text_field_demo.dart';
import '../demos/text_style_demo.dart';
import '../demos/widget_tree_demo.dart';
import '../models/lesson.dart';

/// หลักสูตรทั้งหมด แบ่งเป็นหมวด (module) และบทเรียน (lesson)
const List<LearningModule> modules = [
  // ─────────────────────────────── หมวด 1 ───────────────────────────────
  LearningModule(
    id: 'basics',
    title: 'เริ่มต้นกับ Flutter',
    description: 'รู้จัก Flutter, Widget และ State แนวคิดหลักที่ต้องรู้',
    icon: Icons.rocket_launch_rounded,
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    lessons: [
      Lesson(
        id: 'what-is-flutter',
        title: 'Flutter คืออะไร?',
        summary: 'เครื่องมือสร้างแอปจาก Google เขียนครั้งเดียวใช้ได้ทุกแพลตฟอร์ม',
        icon: Icons.waving_hand_rounded,
        minutes: 3,
        blocks: [
          ParagraphBlock(
            'Flutter คือ UI Toolkit (ชุดเครื่องมือสร้างหน้าจอ) จาก Google ที่ช่วยให้เราสร้างแอปสวยๆ ได้ด้วยการเขียนโค้ดเพียงชุดเดียว แล้วนำไปใช้ได้ทั้ง Android, iOS, Web และ Desktop',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'ลองนึกถึงตัวต่อเลโก้ 🧱 Flutter เตรียมตัวต่อสำเร็จรูปไว้ให้เป็นร้อยๆ ชิ้น (เรียกว่า Widget) เราแค่หยิบมาต่อกันให้เป็นแอปตามที่ต้องการ',
          ),
          HeadingBlock('ทำไมคนถึงชอบ Flutter?'),
          BulletsBlock([
            '⚡ Hot Reload แก้โค้ดแล้วเห็นผลทันทีภายในไม่ถึงวินาที',
            '🎨 ออกแบบ UI ได้อิสระ หน้าตาเหมือนกันทุกเครื่อง',
            '🚀 ทำงานเร็ว เพราะคอมไพล์เป็น Native Code',
            '📱 โค้ดชุดเดียว ใช้ได้หลายแพลตฟอร์ม',
          ]),
          HeadingBlock('แอปแรกของเรา'),
          ParagraphBlock(
            'ทุกแอป Flutter เริ่มต้นที่ฟังก์ชัน main() ซึ่งจะเรียก runApp() เพื่อนำ Widget ตัวแรกขึ้นไปแสดงบนหน้าจอ',
          ),
          CodeBlock(r'''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('สวัสดี Flutter! 👋'),
        ),
      ),
    );
  }
}'''),
          CalloutBlock(
            CalloutKind.tip,
            'Flutter ใช้ภาษา Dart ซึ่งอ่านง่าย คล้าย JavaScript และ Java ถ้าเคยเขียนภาษาใดภาษาหนึ่งมาก่อนจะเรียนรู้ได้เร็วมาก',
          ),
          DemoBlock(
            title: 'Hot Reload จำลอง',
            hint: 'ลองพิมพ์ข้อความใหม่ แล้วดูหน้าจอเปลี่ยนทันที เหมือนตอนกด Hot Reload จริงๆ',
            child: HelloDemo(),
          ),
        ],
        keyPoints: [
          'Flutter คือเครื่องมือสร้าง UI จาก Google',
          'เขียนด้วยภาษา Dart',
          'แอปเริ่มทำงานที่ main() แล้วเรียก runApp()',
          'Hot Reload ช่วยให้เห็นผลการแก้โค้ดทันที',
        ],
        quiz: [
          QuizQuestion(
            question: 'Flutter ใช้ภาษาโปรแกรมอะไรในการเขียน?',
            options: ['Java', 'Dart', 'Swift', 'Python'],
            answer: 1,
            explanation: 'Flutter ใช้ภาษา Dart ซึ่งพัฒนาโดย Google เช่นเดียวกับ Flutter',
          ),
          QuizQuestion(
            question: 'ฟังก์ชันใดใช้สั่งให้แอป Flutter เริ่มแสดงผล?',
            options: ['startApp()', 'runApp()', 'showApp()', 'openApp()'],
            answer: 1,
            explanation: 'main() จะเรียก runApp() พร้อมส่ง Widget ตัวแรกเข้าไปแสดงผล',
          ),
          QuizQuestion(
            question: 'Hot Reload มีประโยชน์อย่างไร?',
            options: [
              'ทำให้ไฟล์แอปเล็กลง',
              'เห็นผลการแก้โค้ดทันทีโดยไม่ต้องเริ่มแอปใหม่',
              'ช่วยแก้บั๊กให้อัตโนมัติ',
              'ทำให้แอปทำงานออฟไลน์ได้',
            ],
            answer: 1,
            explanation: 'Hot Reload อัปเดตโค้ดใหม่เข้าไปในแอปที่กำลังรันอยู่ทันที ทำให้พัฒนาได้เร็วมาก',
          ),
        ],
      ),
      Lesson(
        id: 'everything-is-widget',
        title: 'ทุกอย่างคือ Widget',
        summary: 'เข้าใจ Widget Tree โครงสร้างต้นไม้ของหน้าจอ',
        icon: Icons.account_tree_rounded,
        minutes: 4,
        blocks: [
          ParagraphBlock(
            'ใน Flutter ทุกสิ่งที่เห็นบนหน้าจอคือ Widget ไม่ว่าจะเป็นข้อความ ปุ่ม รูปภาพ หรือแม้แต่การเว้นระยะ (Padding) และการจัดกึ่งกลาง (Center) ก็เป็น Widget ทั้งหมด',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'Widget ซ้อนกันเหมือนกล่องในกล่อง 📦 กล่องใหญ่ (Scaffold) มีกล่องเล็ก (Center) อยู่ข้างใน และในกล่องเล็กก็มีของ (Text) อยู่อีกที',
          ),
          HeadingBlock('Widget Tree คืออะไร?'),
          ParagraphBlock(
            'เมื่อนำ Widget มาซ้อนกัน จะเกิดเป็นโครงสร้างคล้ายต้นไม้ เรียกว่า Widget Tree โดย Widget ที่อยู่ข้างในจะถูกส่งผ่าน property ชื่อ child (ลูก 1 ตัว) หรือ children (ลูกหลายตัว)',
          ),
          CodeBlock(r'''
Scaffold(
  appBar: AppBar(title: const Text('My App')),
  body: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.flutter_dash, size: 48),
        Text('Hello Widget!'),
      ],
    ),
  ),
)'''),
          DemoBlock(
            title: 'สำรวจ Widget Tree',
            hint: 'แตะชื่อ Widget ทางซ้าย เพื่อดูว่ามันคือส่วนไหนบนหน้าจอ',
            child: WidgetTreeDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'child ใช้เมื่อมีลูกตัวเดียว ส่วน children ใช้เมื่อมีลูกหลายตัว (ส่งเป็น List)',
          ),
        ],
        keyPoints: [
          'ทุกอย่างบนหน้าจอคือ Widget',
          'Widget ที่ซ้อนกันเรียกว่า Widget Tree',
          'child = ลูกตัวเดียว, children = ลูกหลายตัว',
        ],
        quiz: [
          QuizQuestion(
            question: 'ข้อใด "ไม่ใช่" Widget ใน Flutter?',
            options: ['Text', 'Padding', 'Center', 'ไม่มี ทุกข้อเป็น Widget'],
            answer: 3,
            explanation: 'ใน Flutter แม้แต่ Padding และ Center ก็เป็น Widget ทั้งหมด',
          ),
          QuizQuestion(
            question: 'ถ้าต้องการใส่ Widget หลายตัวใน Column ต้องใช้ property ใด?',
            options: ['child', 'children', 'items', 'widgets'],
            answer: 1,
            explanation: 'children รับค่าเป็น List ของ Widget ใช้กับ Widget ที่มีลูกได้หลายตัว เช่น Row, Column, Stack',
          ),
        ],
      ),
      Lesson(
        id: 'stateless-stateful',
        title: 'Stateless vs Stateful',
        summary: 'Widget แบบคงที่ กับแบบที่เปลี่ยนแปลงได้',
        icon: Icons.sync_alt_rounded,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'Widget ใน Flutter มี 2 แบบหลักๆ คือ StatelessWidget ที่แสดงผลแบบคงที่ และ StatefulWidget ที่มี "State" หรือข้อมูลที่เปลี่ยนแปลงได้ระหว่างใช้งาน',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'StatelessWidget เหมือน "ป้ายชื่อ" 🏷️ พิมพ์แล้วไม่เปลี่ยน ส่วน StatefulWidget เหมือน "ป้ายคะแนน" 🏀 ที่ตัวเลขเปลี่ยนไปเรื่อยๆ ระหว่างเกม',
          ),
          HeadingBlock('StatelessWidget'),
          CodeBlock(r'''
class Greeting extends StatelessWidget {
  const Greeting({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text('สวัสดี $name');
  }
}''', fileName: 'greeting.dart'),
          HeadingBlock('StatefulWidget + setState()'),
          ParagraphBlock(
            'เมื่อต้องการเปลี่ยนข้อมูล ให้แก้ค่าภายใน setState() แล้ว Flutter จะเรียก build() ใหม่ เพื่อวาดหน้าจอให้ตรงกับข้อมูลล่าสุดโดยอัตโนมัติ',
          ),
          CodeBlock(r'''
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0; // 👈 นี่คือ State

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            setState(() => count++); // สั่งให้วาดใหม่
          },
          child: const Text('เพิ่ม'),
        ),
      ],
    );
  }
}''', fileName: 'counter.dart'),
          DemoBlock(
            title: 'ตัวนับเลข (Counter)',
            hint: 'กดปุ่มแล้วสังเกตว่าตัวเลขเปลี่ยน เพราะ setState() สั่งให้ build() ทำงานใหม่',
            child: CounterDemo(),
          ),
          CalloutBlock(
            CalloutKind.warning,
            'ถ้าแก้ค่าตัวแปรโดยไม่เรียก setState() ข้อมูลจะเปลี่ยนแต่หน้าจอจะไม่อัปเดต!',
          ),
        ],
        keyPoints: [
          'StatelessWidget แสดงผลคงที่ ไม่มีข้อมูลเปลี่ยนแปลงภายใน',
          'StatefulWidget มี State ที่เปลี่ยนแปลงได้',
          'เปลี่ยนค่าใน setState() เพื่อให้หน้าจออัปเดต',
        ],
        quiz: [
          QuizQuestion(
            question: 'ถ้าต้องการสร้างปุ่มกดเพิ่มตัวเลข ควรใช้ Widget แบบใด?',
            options: ['StatelessWidget', 'StatefulWidget', 'ไม่ต้องใช้ Widget', 'MaterialApp'],
            answer: 1,
            explanation: 'ตัวเลขเปลี่ยนไปเมื่อกดปุ่ม จึงต้องมี State ต้องใช้ StatefulWidget',
          ),
          QuizQuestion(
            question: 'setState() ทำหน้าที่อะไร?',
            options: [
              'บันทึกข้อมูลลงเครื่อง',
              'บอก Flutter ว่าข้อมูลเปลี่ยน ให้เรียก build() ใหม่',
              'ปิดแอป',
              'สร้างหน้าจอใหม่',
            ],
            answer: 1,
            explanation: 'setState() แจ้ง Flutter ว่า State เปลี่ยนแล้ว Flutter จึงวาดหน้าจอใหม่ให้',
          ),
          QuizQuestion(
            question: 'ถ้าแก้ค่าตัวแปรโดยไม่เรียก setState() จะเกิดอะไรขึ้น?',
            options: ['แอป crash', 'หน้าจอไม่อัปเดตตาม', 'ค่าตัวแปรไม่เปลี่ยน', 'Flutter เรียก setState() ให้เอง'],
            answer: 1,
            explanation: 'ค่าในตัวแปรเปลี่ยนจริง แต่ Flutter ไม่รู้ว่าต้องวาดใหม่ หน้าจอจึงยังแสดงค่าเดิม',
          ),
        ],
      ),
    ],
  ),

  // ─────────────────────────────── หมวด 2 ───────────────────────────────
  LearningModule(
    id: 'widgets',
    title: 'Widget พื้นฐาน',
    description: 'ข้อความ กล่อง และปุ่ม ชิ้นส่วนที่ใช้บ่อยที่สุด',
    icon: Icons.widgets_rounded,
    colors: [Color(0xFF0D9488), Color(0xFF22C55E)],
    lessons: [
      Lesson(
        id: 'text-icon',
        title: 'Text & Icon',
        summary: 'แสดงข้อความและไอคอนให้สวยงาม',
        icon: Icons.text_fields_rounded,
        minutes: 4,
        blocks: [
          ParagraphBlock(
            'Text ใช้แสดงข้อความ และแต่งหน้าตาได้ผ่าน TextStyle เช่น ขนาด สี และความหนา ส่วน Icon ใช้แสดงไอคอนสำเร็จรูปจาก Material Icons ที่มีให้เลือกหลายพันแบบ',
          ),
          CodeBlock(r'''
Text(
  'Flutter สนุกมาก',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)'''),
          DemoBlock(
            title: 'ปรับแต่ง TextStyle',
            hint: 'เลื่อน slider และเลือกสไตล์ แล้วดูโค้ดเปลี่ยนตามแบบ real-time',
            child: TextStyleDemo(),
          ),
          HeadingBlock('Icon'),
          CodeBlock(r'''
const Icon(
  Icons.favorite,
  color: Colors.pink,
  size: 32,
)'''),
          CalloutBlock(
            CalloutKind.tip,
            'ค้นหาไอคอนทั้งหมดได้ที่ fonts.google.com/icons แล้วเรียกใช้ผ่าน Icons.ชื่อไอคอน',
          ),
        ],
        keyPoints: [
          'Text แสดงข้อความ แต่งด้วย TextStyle',
          'fontSize = ขนาด, fontWeight = ความหนา, color = สี',
          'Icon แสดงไอคอนผ่าน Icons.ชื่อไอคอน',
        ],
        quiz: [
          QuizQuestion(
            question: 'ถ้าต้องการให้ข้อความเป็นตัวหนา ต้องตั้งค่าอะไร?',
            options: ['fontSize: 20', 'fontWeight: FontWeight.bold', 'color: Colors.black', 'bold: true'],
            answer: 1,
            explanation: 'ความหนาของตัวอักษรกำหนดด้วย fontWeight เช่น FontWeight.bold',
          ),
          QuizQuestion(
            question: 'property ใดใช้กำหนดขนาดตัวอักษร?',
            options: ['size', 'fontSize', 'textSize', 'height'],
            answer: 1,
            explanation: 'fontSize ใน TextStyle ใช้กำหนดขนาดตัวอักษร',
          ),
        ],
      ),
      Lesson(
        id: 'container',
        title: 'Container กล่องสารพัดประโยชน์',
        summary: 'กำหนดขนาด สี ขอบมน และเงา',
        icon: Icons.crop_square_rounded,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'Container คือกล่องที่ใช้บ่อยที่สุดใน Flutter กำหนดขนาด (width, height), ระยะห่างด้านใน (padding), ระยะห่างด้านนอก (margin) และตกแต่งด้วย BoxDecoration ได้',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'Container เหมือน "กล่องของขวัญ" 🎁 เราเลือกขนาดกล่อง สีกระดาษห่อ ความมนของมุม และจะใส่ของ (child) อะไรไว้ข้างในก็ได้',
          ),
          DemoBlock(
            title: 'ออกแบบกล่องของคุณ',
            hint: 'ปรับค่าต่างๆ แล้วดูผลลัพธ์ พร้อมโค้ดที่ใช้สร้างจริง',
            child: ContainerDemo(),
          ),
          HeadingBlock('padding กับ margin ต่างกันอย่างไร?'),
          BulletsBlock([
            'padding = ระยะห่าง "ด้านใน" ระหว่างขอบกล่องกับเนื้อหา',
            'margin = ระยะห่าง "ด้านนอก" ระหว่างกล่องกับสิ่งรอบข้าง',
          ]),
          CodeBlock(r'''
Container(
  margin: const EdgeInsets.all(16),  // ด้านนอก
  padding: const EdgeInsets.all(12), // ด้านใน
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: const Text('ฉันอยู่ในกล่อง'),
)'''),
          CalloutBlock(
            CalloutKind.warning,
            'ถ้าใช้ decoration แล้ว ห้ามใส่ color ที่ Container โดยตรง ให้ย้ายไปใส่ใน BoxDecoration แทน ไม่อย่างนั้นจะเกิด error',
          ),
        ],
        keyPoints: [
          'Container กำหนดขนาด ระยะห่าง และการตกแต่งได้',
          'ตกแต่งด้วย BoxDecoration (สี, ขอบมน, เงา, gradient)',
          'padding = ด้านใน, margin = ด้านนอก',
        ],
        quiz: [
          QuizQuestion(
            question: 'ต้องการทำมุมกล่องให้มน ต้องใช้อะไร?',
            options: ['borderRadius ใน BoxDecoration', 'radius: 16', 'Container.round()', 'shape: rounded'],
            answer: 0,
            explanation: 'ใช้ BoxDecoration(borderRadius: BorderRadius.circular(16)) เพื่อทำมุมมน',
          ),
          QuizQuestion(
            question: 'padding กับ margin ต่างกันอย่างไร?',
            options: [
              'เหมือนกันทุกอย่าง',
              'padding คือระยะด้านใน, margin คือระยะด้านนอก',
              'padding คือระยะด้านนอก, margin คือระยะด้านใน',
              'margin ใช้ได้กับ Text เท่านั้น',
            ],
            answer: 1,
            explanation: 'padding เว้นระยะระหว่างขอบกับเนื้อหาข้างใน ส่วน margin เว้นระยะรอบนอกกล่อง',
          ),
        ],
      ),
      Lesson(
        id: 'buttons',
        title: 'ปุ่มแบบต่างๆ',
        summary: 'ElevatedButton, FilledButton, TextButton และอีกมากมาย',
        icon: Icons.smart_button_rounded,
        minutes: 4,
        blocks: [
          ParagraphBlock(
            'Flutter มีปุ่มสำเร็จรูปหลายแบบให้เลือกตามความสำคัญ ทุกปุ่มใช้หลักการเดียวกัน คือ onPressed (ทำอะไรเมื่อกด) และ child (หน้าตาของปุ่ม)',
          ),
          CodeBlock(r'''
FilledButton(
  onPressed: () {
    print('กดปุ่มแล้ว!');
  },
  child: const Text('กดฉันสิ'),
)'''),
          DemoBlock(
            title: 'กดปุ่มดูสิ!',
            hint: 'ลองกดปุ่มแต่ละแบบ แล้วสังเกตหน้าตาและเอฟเฟกต์ที่ต่างกัน',
            child: ButtonsDemo(),
          ),
          HeadingBlock('เลือกใช้ปุ่มแบบไหนดี?'),
          BulletsBlock([
            'FilledButton ปุ่มหลักที่สำคัญที่สุด เช่น "บันทึก"',
            'OutlinedButton ปุ่มรอง เช่น "ยกเลิก"',
            'TextButton ปุ่มที่ไม่ต้องเด่น เช่น "ข้าม"',
            'IconButton ปุ่มไอคอนเล็กๆ เช่น ❤️ กดถูกใจ',
          ]),
          CalloutBlock(
            CalloutKind.tip,
            'ถ้าใส่ onPressed: null ปุ่มจะถูกปิดใช้งาน (disabled) และเปลี่ยนเป็นสีเทาให้อัตโนมัติ',
          ),
        ],
        keyPoints: [
          'ทุกปุ่มมี onPressed และ child',
          'เลือกชนิดปุ่มตามความสำคัญของปุ่ม',
          'onPressed: null = ปุ่มถูกปิดใช้งาน',
        ],
        quiz: [
          QuizQuestion(
            question: 'property ใดกำหนดสิ่งที่เกิดขึ้นเมื่อกดปุ่ม?',
            options: ['onTap', 'onClick', 'onPressed', 'onPush'],
            answer: 2,
            explanation: 'ปุ่มใน Flutter ใช้ onPressed รับฟังก์ชันที่จะทำงานเมื่อถูกกด',
          ),
          QuizQuestion(
            question: 'ถ้าตั้ง onPressed เป็น null จะเกิดอะไรขึ้น?',
            options: ['แอป crash', 'ปุ่มหายไป', 'ปุ่มถูกปิดใช้งาน (disabled)', 'ปุ่มกดได้ตามปกติ'],
            answer: 2,
            explanation: 'Flutter ถือว่าปุ่มที่ไม่มี onPressed เป็นปุ่ม disabled และแสดงเป็นสีเทา',
          ),
        ],
      ),
    ],
  ),

  // ─────────────────────────────── หมวด 3 ───────────────────────────────
  LearningModule(
    id: 'layout',
    title: 'จัดวาง Layout',
    description: 'Row, Column, Stack และ ListView จัดหน้าจอให้เป๊ะ',
    icon: Icons.dashboard_customize_rounded,
    colors: [Color(0xFFF97316), Color(0xFFEC4899)],
    lessons: [
      Lesson(
        id: 'row-column',
        title: 'Row & Column',
        summary: 'เรียง Widget ในแนวนอนและแนวตั้ง',
        icon: Icons.view_column_rounded,
        minutes: 6,
        blocks: [
          ParagraphBlock(
            'Row ใช้เรียง Widget ในแนวนอน ⬅️➡️ ส่วน Column ใช้เรียงในแนวตั้ง ⬆️⬇️ ทั้งสองตัวคือหัวใจของการจัด Layout ใน Flutter',
          ),
          HeadingBlock('แกนหลัก vs แกนรอง'),
          BulletsBlock([
            'mainAxisAlignment จัดตำแหน่งตาม "แกนหลัก" (Row = แนวนอน, Column = แนวตั้ง)',
            'crossAxisAlignment จัดตำแหน่งตาม "แกนรอง" ที่ตั้งฉากกับแกนหลัก',
          ]),
          CalloutBlock(
            CalloutKind.analogy,
            'นึกถึงการเข้าแถว 🧍🧍🧍 Row คือยืนเรียงหน้ากระดาน Column คือยืนต่อแถวเรียงหนึ่ง แกนหลักคือทิศที่แถวยาวออกไป',
          ),
          DemoBlock(
            title: 'ทดลองจัดตำแหน่ง',
            hint: 'สลับ Row/Column และเลือกการจัดตำแหน่ง เพื่อดูว่ากล่องขยับอย่างไร',
            child: RowColumnDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'spaceBetween, spaceAround และ spaceEvenly ช่วยกระจายช่องว่างระหว่าง Widget ให้โดยไม่ต้องคำนวณเอง',
          ),
        ],
        keyPoints: [
          'Row = แนวนอน, Column = แนวตั้ง',
          'mainAxisAlignment จัดตามแกนหลัก',
          'crossAxisAlignment จัดตามแกนรอง',
        ],
        quiz: [
          QuizQuestion(
            question: 'ถ้าต้องการวางไอคอน 3 ตัวเรียงกันในแนวนอน ควรใช้อะไร?',
            options: ['Column', 'Row', 'Stack', 'Center'],
            answer: 1,
            explanation: 'Row เรียงลูกทุกตัวในแนวนอน',
          ),
          QuizQuestion(
            question: 'ใน Column, mainAxisAlignment จะจัดตำแหน่งในแนวใด?',
            options: ['แนวนอน', 'แนวตั้ง', 'แนวทแยง', 'ไม่มีผลอะไร'],
            answer: 1,
            explanation: 'แกนหลักของ Column คือแนวตั้ง mainAxisAlignment จึงจัดตำแหน่งในแนวตั้ง',
          ),
          QuizQuestion(
            question: 'ต้องการกระจายช่องว่างให้เท่ากันทั้งหมด รวมถึงขอบทั้งสองด้าน ใช้ค่าใด?',
            options: ['spaceBetween', 'spaceEvenly', 'center', 'start'],
            answer: 1,
            explanation: 'spaceEvenly ทำให้ทุกช่องว่าง (รวมขอบ) เท่ากัน ส่วน spaceBetween ไม่เว้นที่ขอบ',
          ),
        ],
      ),
      Lesson(
        id: 'stack',
        title: 'Stack วางซ้อนเป็นชั้นๆ',
        summary: 'วาง Widget ทับกันเหมือนเลเยอร์',
        icon: Icons.layers_rounded,
        minutes: 4,
        blocks: [
          ParagraphBlock(
            'Stack ใช้วาง Widget ซ้อนทับกันเป็นชั้นๆ ตัวที่อยู่ท้ายสุดของ children จะอยู่ชั้นบนสุด เหมาะกับการทำป้ายแจ้งเตือน (Badge) ข้อความทับรูปภาพ หรือปุ่มลอย',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'เหมือนวางกระดาษซ้อนกันบนโต๊ะ 📄 แผ่นที่วางทีหลังจะอยู่บนสุดเสมอ',
          ),
          CodeBlock(r'''
Stack(
  alignment: Alignment.topRight,
  children: [
    Container(width: 200, height: 130), // ชั้นล่าง
    const Icon(Icons.favorite),          // ชั้นบน
  ],
)'''),
          DemoBlock(
            title: 'ย้ายตำแหน่งชั้นบน',
            hint: 'แตะช่องในตาราง 3×3 เพื่อเลือก Alignment ของชั้นบน',
            child: StackDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'ถ้าต้องการกำหนดตำแหน่งแบบละเอียด ใช้ Positioned(top: 10, left: 20, child: ...) ภายใน Stack ได้',
          ),
        ],
        keyPoints: [
          'Stack วาง Widget ซ้อนกันเป็นชั้น',
          'ตัวสุดท้ายใน children อยู่บนสุด',
          'ใช้ alignment หรือ Positioned กำหนดตำแหน่ง',
        ],
        quiz: [
          QuizQuestion(
            question: 'ใน Stack Widget ตัวไหนจะอยู่ชั้นบนสุด?',
            options: ['ตัวแรกใน children', 'ตัวสุดท้ายใน children', 'ตัวที่ใหญ่ที่สุด', 'ตัวที่เล็กที่สุด'],
            answer: 1,
            explanation: 'Stack วาดลูกตามลำดับ ตัวที่วาดทีหลังจึงทับตัวก่อนหน้า',
          ),
          QuizQuestion(
            question: 'Widget ใดใช้กำหนดตำแหน่งด้วยระยะ top/left ภายใน Stack?',
            options: ['Padding', 'Align', 'Positioned', 'Center'],
            answer: 2,
            explanation: 'Positioned กำหนดระยะจากขอบ top, left, right, bottom ภายใน Stack ได้',
          ),
        ],
      ),
      Lesson(
        id: 'expanded',
        title: 'Expanded & Flexible',
        summary: 'แบ่งพื้นที่ตามสัดส่วนแบบยืดหยุ่น',
        icon: Icons.open_in_full_rounded,
        minutes: 4,
        blocks: [
          ParagraphBlock(
            'Expanded ใช้ภายใน Row หรือ Column เพื่อให้ Widget ขยายเต็มพื้นที่ที่เหลืออยู่ ถ้ามีหลายตัว สามารถกำหนดสัดส่วนด้วย flex ได้',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'เหมือนแบ่งพิซซ่า 🍕 ถ้า flex เป็น 1 : 2 : 1 คนตรงกลางได้ไป 2 ชิ้นจากทั้งหมด 4 ชิ้น',
          ),
          CodeBlock(r'''
Row(
  children: [
    Expanded(flex: 1, child: Container(color: Colors.red)),
    Expanded(flex: 2, child: Container(color: Colors.green)),
    Expanded(flex: 1, child: Container(color: Colors.blue)),
  ],
)'''),
          DemoBlock(
            title: 'แบ่งพื้นที่ด้วย flex',
            hint: 'ปรับค่า flex ของแต่ละกล่อง แล้วดูสัดส่วนเปลี่ยนไป',
            child: ExpandedDemo(),
          ),
          CalloutBlock(
            CalloutKind.warning,
            'Expanded ต้องอยู่ภายใน Row, Column หรือ Flex เท่านั้น ถ้าใช้ที่อื่นจะเกิด error',
          ),
        ],
        keyPoints: [
          'Expanded ขยายเต็มพื้นที่ที่เหลือ',
          'flex กำหนดสัดส่วนการแบ่งพื้นที่',
          'ใช้ได้เฉพาะใน Row, Column, Flex',
        ],
        quiz: [
          QuizQuestion(
            question: 'มี Expanded 2 ตัว คือ flex: 1 และ flex: 3 ตัวแรกจะได้พื้นที่เท่าไร?',
            options: ['1/2', '1/3', '1/4', '3/4'],
            answer: 2,
            explanation: 'รวมทั้งหมด 1 + 3 = 4 ส่วน ตัวแรกได้ 1 ส่วน จึงเป็น 1/4',
          ),
          QuizQuestion(
            question: 'Expanded ใช้ได้ภายใน Widget ใด?',
            options: ['Row และ Column', 'Stack', 'Container', 'Text'],
            answer: 0,
            explanation: 'Expanded ทำงานร่วมกับ Flex layout คือ Row, Column และ Flex เท่านั้น',
          ),
        ],
      ),
      Lesson(
        id: 'list-view',
        title: 'ListView รายการเลื่อนได้',
        summary: 'แสดงรายการยาวๆ ที่เลื่อนดูได้',
        icon: Icons.list_alt_rounded,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'เมื่อมีข้อมูลเยอะจนล้นหน้าจอ ให้ใช้ ListView ซึ่งเลื่อน (scroll) ได้อัตโนมัติ และถ้าข้อมูลมีจำนวนมาก ควรใช้ ListView.builder ที่สร้างเฉพาะรายการที่มองเห็นบนหน้าจอ ทำให้แอปลื่นไหล',
          ),
          CodeBlock(r'''
final fruits = ['🍎 แอปเปิล', '🍌 กล้วย', '🍇 องุ่น'];

ListView.builder(
  itemCount: fruits.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(fruits[index]),
    );
  },
)'''),
          DemoBlock(
            title: 'รายการผลไม้',
            hint: 'กดเพิ่มเพื่อเพิ่มรายการ และปัดรายการไปทางซ้ายหรือขวาเพื่อลบ',
            child: ListViewDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'ListTile คือ Widget สำเร็จรูปสำหรับแถวในรายการ มีทั้ง leading (ด้านหน้า), title, subtitle และ trailing (ด้านหลัง)',
          ),
        ],
        keyPoints: [
          'ListView แสดงรายการที่เลื่อนได้',
          'ListView.builder สร้างเฉพาะรายการที่มองเห็น',
          'itemCount = จำนวนรายการ, itemBuilder = วิธีสร้างแต่ละรายการ',
        ],
        quiz: [
          QuizQuestion(
            question: 'ถ้ามีข้อมูล 1,000 รายการ ควรใช้แบบใด?',
            options: ['Column', 'ListView.builder', 'Row', 'Stack'],
            answer: 1,
            explanation: 'ListView.builder สร้างเฉพาะรายการที่อยู่บนหน้าจอ จึงประหยัดหน่วยความจำและลื่นไหล',
          ),
          QuizQuestion(
            question: 'property ใดของ ListView.builder บอกจำนวนรายการ?',
            options: ['length', 'itemCount', 'count', 'size'],
            answer: 1,
            explanation: 'itemCount บอก ListView ว่ามีรายการทั้งหมดกี่รายการ',
          ),
        ],
      ),
    ],
  ),

  // ─────────────────────────────── หมวด 4 ───────────────────────────────
  LearningModule(
    id: 'interaction',
    title: 'โต้ตอบกับผู้ใช้',
    description: 'รับข้อความ เปลี่ยนหน้า และสร้าง Animation',
    icon: Icons.touch_app_rounded,
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    lessons: [
      Lesson(
        id: 'text-field',
        title: 'TextField รับข้อความ',
        summary: 'สร้างช่องกรอกข้อมูลและอ่านค่าที่ผู้ใช้พิมพ์',
        icon: Icons.keyboard_rounded,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'TextField คือช่องให้ผู้ใช้พิมพ์ข้อความ อ่านค่าที่พิมพ์ได้ 2 วิธี คือ onChanged (ได้ค่าทุกครั้งที่พิมพ์) หรือ TextEditingController (ดึงค่าเมื่อต้องการ)',
          ),
          CodeBlock(r'''
final controller = TextEditingController();

TextField(
  controller: controller,
  decoration: const InputDecoration(
    labelText: 'ชื่อของคุณ',
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {
    print('กำลังพิมพ์: $value');
  },
)

// อ่านค่าเมื่อต้องการ
print(controller.text);'''),
          DemoBlock(
            title: 'แบบฟอร์มทักทาย',
            hint: 'พิมพ์ชื่อแล้วดูข้อความทักทาย ลองตั้งรหัสผ่านและกดรูปตาเพื่อซ่อน/แสดง',
            child: TextFieldDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'ใช้ obscureText: true เพื่อซ่อนข้อความในช่องรหัสผ่าน',
          ),
          CalloutBlock(
            CalloutKind.warning,
            'อย่าลืมเรียก controller.dispose() ในเมธอด dispose() ของ State เพื่อคืนหน่วยความจำ',
          ),
        ],
        keyPoints: [
          'TextField คือช่องรับข้อความ',
          'onChanged ได้ค่าทุกครั้งที่พิมพ์',
          'TextEditingController อ่าน/ตั้งค่าข้อความได้ทุกเมื่อ',
          'obscureText: true สำหรับรหัสผ่าน',
        ],
        quiz: [
          QuizQuestion(
            question: 'property ใดใช้ซ่อนข้อความในช่องรหัสผ่าน?',
            options: ['hideText', 'obscureText', 'password', 'secure'],
            answer: 1,
            explanation: 'obscureText: true จะแสดงเป็นจุดแทนตัวอักษรจริง',
          ),
          QuizQuestion(
            question: 'ถ้าต้องการอ่านค่าทุกครั้งที่ผู้ใช้พิมพ์ ใช้อะไร?',
            options: ['onPressed', 'onChanged', 'onTap', 'onSaved'],
            answer: 1,
            explanation: 'onChanged ถูกเรียกทุกครั้งที่ข้อความในช่องเปลี่ยน',
          ),
        ],
      ),
      Lesson(
        id: 'navigation',
        title: 'Navigator เปลี่ยนหน้า',
        summary: 'ไปหน้าใหม่และส่งข้อมูลกลับมา',
        icon: Icons.swap_horiz_rounded,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'แอปส่วนใหญ่มีหลายหน้า Flutter ใช้ Navigator จัดการหน้าจอแบบ "กองซ้อน" โดย push คือวางหน้าใหม่ทับด้านบน และ pop คือเอาหน้าบนสุดออกเพื่อกลับไปหน้าเดิม',
          ),
          CalloutBlock(
            CalloutKind.analogy,
            'เหมือนกองจาน 🍽️ วางจานใบใหม่ไว้ด้านบน (push) และหยิบจานใบบนสุดออก (pop)',
          ),
          CodeBlock(r'''
// ไปหน้าใหม่ และรอผลลัพธ์
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const PickFruitPage()),
);

// ในหน้าใหม่: กลับไปพร้อมส่งค่า
Navigator.pop(context, '🍎');'''),
          DemoBlock(
            title: 'ไปหน้าใหม่แล้วกลับมา',
            hint: 'กดปุ่มเพื่อเปิดหน้าใหม่ เลือกผลไม้ แล้วดูว่าค่าถูกส่งกลับมาอย่างไร',
            child: NavigationDemo(),
          ),
          CalloutBlock(
            CalloutKind.tip,
            'ปุ่มย้อนกลับบน AppBar และปุ่ม Back ของ Android จะเรียก pop ให้อัตโนมัติ',
          ),
        ],
        keyPoints: [
          'Navigator.push เปิดหน้าใหม่',
          'Navigator.pop ปิดหน้าปัจจุบัน',
          'ส่งค่ากลับได้ด้วย Navigator.pop(context, ค่า)',
        ],
        quiz: [
          QuizQuestion(
            question: 'คำสั่งใดใช้เปิดหน้าใหม่?',
            options: ['Navigator.pop', 'Navigator.push', 'Navigator.open', 'Navigator.go'],
            answer: 1,
            explanation: 'Navigator.push วางหน้าใหม่ไว้บนสุดของกองหน้าจอ',
          ),
          QuizQuestion(
            question: 'คำสั่งใดใช้ปิดหน้าปัจจุบันและกลับไปหน้าก่อน?',
            options: ['Navigator.back', 'Navigator.close', 'Navigator.pop', 'Navigator.exit'],
            answer: 2,
            explanation: 'Navigator.pop เอาหน้าบนสุดออก จึงกลับไปหน้าก่อนหน้า',
          ),
          QuizQuestion(
            question: 'จะส่งค่ากลับไปยังหน้าก่อนหน้าได้อย่างไร?',
            options: ['Navigator.pop(context, ค่า)', 'return ค่า', 'setState(ค่า)', 'ส่งกลับไม่ได้'],
            answer: 0,
            explanation: 'ค่าที่ส่งใน pop จะเป็นผลลัพธ์ของ await Navigator.push ในหน้าก่อนหน้า',
          ),
        ],
      ),
      Lesson(
        id: 'animation',
        title: 'Animation แบบง่ายๆ',
        summary: 'ทำให้ UI เคลื่อนไหวด้วย AnimatedContainer',
        icon: Icons.animation,
        minutes: 5,
        blocks: [
          ParagraphBlock(
            'Flutter มี Implicit Animation ที่ใช้ง่ายมาก แค่เปลี่ยนค่าใน setState() แล้ว Widget ที่ขึ้นต้นด้วย Animated... จะค่อยๆ เปลี่ยนไปยังค่าใหม่ให้เอง ไม่ต้องคำนวณทีละเฟรม',
          ),
          CodeBlock(r'''
AnimatedContainer(
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeInOut,
  width: isBig ? 200 : 100,
  height: isBig ? 200 : 100,
  decoration: BoxDecoration(
    color: isBig ? Colors.purple : Colors.blue,
    borderRadius: BorderRadius.circular(isBig ? 100 : 16),
  ),
)'''),
          DemoBlock(
            title: 'เล่นกับ Animation',
            hint: 'เลือก Curve และความเร็ว แล้วกดปุ่มเพื่อดูการเคลื่อนไหว',
            child: AnimationDemo(),
          ),
          HeadingBlock('Animated Widget ยอดนิยม'),
          BulletsBlock([
            'AnimatedContainer เปลี่ยนขนาด สี และขอบแบบนุ่มนวล',
            'AnimatedOpacity ค่อยๆ จางหายหรือปรากฏ',
            'AnimatedAlign ค่อยๆ เลื่อนตำแหน่ง',
            'AnimatedSwitcher สลับ Widget แบบมีเอฟเฟกต์',
          ]),
          CalloutBlock(
            CalloutKind.tip,
            'Curve คือ "จังหวะ" ของการเคลื่อนไหว เช่น bounceOut จะเด้งตอนจบ ส่วน elasticOut จะยืดหยุ่นเหมือนสปริง',
          ),
        ],
        keyPoints: [
          'Animated... Widget เคลื่อนไหวให้เองเมื่อค่าเปลี่ยน',
          'duration กำหนดระยะเวลา',
          'curve กำหนดจังหวะการเคลื่อนไหว',
        ],
        quiz: [
          QuizQuestion(
            question: 'Widget ใดใช้สร้าง Animation การเปลี่ยนขนาดและสีได้ง่ายที่สุด?',
            options: ['Container', 'AnimatedContainer', 'Transform', 'Opacity'],
            answer: 1,
            explanation: 'AnimatedContainer จะค่อยๆ เปลี่ยนจากค่าเก่าไปค่าใหม่ให้อัตโนมัติ',
          ),
          QuizQuestion(
            question: 'property ใดกำหนดระยะเวลาของ Animation?',
            options: ['time', 'duration', 'delay', 'speed'],
            answer: 1,
            explanation: 'duration รับค่า Duration เช่น Duration(milliseconds: 600)',
          ),
          QuizQuestion(
            question: 'Curves.bounceOut ให้ผลแบบใด?',
            options: ['เคลื่อนที่ด้วยความเร็วคงที่', 'เด้งตอนจบ', 'หยุดกลางทาง', 'เคลื่อนที่ย้อนกลับ'],
            answer: 1,
            explanation: 'bounceOut ทำให้ Widget เด้งเล็กน้อยก่อนหยุดนิ่ง เหมือนลูกบอลตกพื้น',
          ),
        ],
      ),
    ],
  ),
];

/// บทเรียนทั้งหมดเรียงตามลำดับ
final List<Lesson> allLessons = [
  for (final module in modules) ...module.lessons,
];

final List<QuizQuestion> allQuestions = [
  for (final module in modules) ...module.questions,
];

LearningModule moduleOf(Lesson lesson) =>
    modules.firstWhere((module) => module.lessons.contains(lesson));

int lessonNumber(Lesson lesson) => allLessons.indexOf(lesson) + 1;

Lesson? nextLessonAfter(Lesson lesson) {
  final index = allLessons.indexOf(lesson);
  if (index < 0 || index + 1 >= allLessons.length) return null;
  return allLessons[index + 1];
}
