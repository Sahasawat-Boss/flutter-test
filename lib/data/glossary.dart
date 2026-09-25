class GlossaryTerm {
  const GlossaryTerm(this.term, this.meaning);

  final String term;
  final String meaning;
}

const List<GlossaryTerm> glossary = [
  GlossaryTerm('Widget', 'ชิ้นส่วนพื้นฐานของ UI ใน Flutter ทุกอย่างบนหน้าจอคือ Widget'),
  GlossaryTerm('Widget Tree', 'โครงสร้างของ Widget ที่ซ้อนกันเป็นลำดับชั้นคล้ายต้นไม้'),
  GlossaryTerm('State', 'ข้อมูลที่เปลี่ยนแปลงได้ระหว่างที่แอปทำงาน เช่น ตัวเลขในตัวนับ'),
  GlossaryTerm('StatelessWidget', 'Widget ที่ไม่มี State ของตัวเอง แสดงผลตามข้อมูลที่ได้รับมาเท่านั้น'),
  GlossaryTerm('StatefulWidget', 'Widget ที่มี State และวาดตัวเองใหม่ได้เมื่อข้อมูลเปลี่ยน'),
  GlossaryTerm('setState()', 'คำสั่งบอก Flutter ว่า State เปลี่ยนแล้ว ให้เรียก build() ใหม่'),
  GlossaryTerm('build()', 'เมธอดที่คืนค่า Widget เพื่อบอกว่าหน้าจอควรมีหน้าตาอย่างไร'),
  GlossaryTerm('BuildContext', 'ตำแหน่งของ Widget ใน Widget Tree ใช้เข้าถึง Theme, Navigator และอื่นๆ'),
  GlossaryTerm('Hot Reload', 'อัปเดตโค้ดเข้าแอปที่กำลังรันทันที โดย State เดิมยังอยู่'),
  GlossaryTerm('Hot Restart', 'เริ่มแอปใหม่ทั้งหมดอย่างรวดเร็ว State จะถูกรีเซ็ต'),
  GlossaryTerm('Dart', 'ภาษาโปรแกรมที่ใช้เขียน Flutter พัฒนาโดย Google'),
  GlossaryTerm('pubspec.yaml', 'ไฟล์ตั้งค่าโปรเจกต์ กำหนดชื่อแอป เวอร์ชัน และ package ที่ใช้'),
  GlossaryTerm('Package', 'โค้ดสำเร็จรูปที่คนอื่นเขียนไว้ให้ใช้ ค้นหาได้ที่ pub.dev'),
  GlossaryTerm('MaterialApp', 'Widget ตั้งต้นของแอป กำหนด Theme หน้าแรก และระบบนำทาง'),
  GlossaryTerm('Scaffold', 'โครงหน้าจอพื้นฐาน มีช่องสำหรับ AppBar, body, ปุ่มลอย และแถบเมนูล่าง'),
  GlossaryTerm('const', 'บอกว่าค่านี้คงที่ ช่วยให้ Flutter ไม่ต้องสร้าง Widget ซ้ำ แอปจึงเร็วขึ้น'),
  GlossaryTerm('Navigator', 'ตัวจัดการการเปลี่ยนหน้าจอแบบกองซ้อน (push / pop)'),
  GlossaryTerm('Route', 'หน้าจอหนึ่งหน้าในระบบนำทางของ Flutter'),
  GlossaryTerm('Future / async / await', 'ใช้จัดการงานที่ต้องรอผล เช่น โหลดข้อมูลจากอินเทอร์เน็ต'),
  GlossaryTerm('Null Safety', 'ระบบของ Dart ที่ป้องกันค่า null โดยไม่ตั้งใจ ตัวแปรที่เป็น null ได้ต้องใส่ ? ต่อท้ายชนิด'),
  GlossaryTerm('Key', 'ตัวระบุ Widget ช่วยให้ Flutter รู้ว่า Widget ไหนเป็นตัวเดิมเมื่อรายการเปลี่ยน'),
  GlossaryTerm('Theme', 'ชุดสไตล์กลางของแอป เช่น สีและฟอนต์ ใช้ร่วมกันทุกหน้า'),
];

const List<String> dailyTips = [
  'ใส่ const หน้า Widget ที่ไม่เปลี่ยนแปลง จะช่วยให้แอปเร็วขึ้น',
  'กด r ใน terminal เพื่อ Hot Reload และกด R เพื่อ Hot Restart',
  'ใช้ Flutter DevTools เพื่อดู Widget Tree และหาปัญหาเรื่อง Layout',
  'เจอแถบลายเหลือง-ดำ แปลว่า Widget ล้นพื้นที่ ลองใช้ Expanded หรือ SingleChildScrollView',
  'ค้นหา package ดีๆ ที่ pub.dev ก่อนลงมือเขียนเองทุกอย่าง',
  'กด Ctrl + . ใน VS Code เพื่อครอบ Widget ด้วย Widget อื่นได้ทันที',
  'แยก Widget ใหญ่ออกเป็น Widget เล็กๆ จะอ่านง่ายและดูแลง่ายขึ้น',
  'ใช้ Theme.of(context) ดึงสีและฟอนต์จาก Theme แทนการกำหนดค่าเองทุกที่',
];
