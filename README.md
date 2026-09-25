# Flutter Learn 💙

แอปสำหรับเรียนรู้ Flutter แบบเข้าใจง่าย ทุกบทเรียนมีคำอธิบายภาษาไทย การเปรียบเทียบกับของใกล้ตัว โค้ดตัวอย่าง และ **เดโมที่กดเล่นได้จริง**

## ฟีเจอร์

- 📚 **13 บทเรียน ใน 4 หมวด**: เริ่มต้น, Widget พื้นฐาน, Layout, การโต้ตอบกับผู้ใช้
- 🎮 **เดโมแบบ interactive** ทุกบท เช่น ปรับ Row/Column, ออกแบบ Container, เล่นกับ Animation พร้อมโค้ดที่เปลี่ยนตามแบบ real-time
- 🧠 **ควิซ** รายบท รายหมวด และควิซรวม พร้อมเฉลยและคำอธิบาย
- 📖 **คลังคำศัพท์** ค้นหาได้
- 🏅 **ความคืบหน้าและเหรียญรางวัล** บันทึกในเครื่อง
- 🌙 **ธีมสว่าง/มืด**

## เริ่มต้นใช้งาน

โปรเจกต์นี้มีเฉพาะซอร์สโค้ด (`lib/`, `test/`) ให้สร้างโฟลเดอร์ของแต่ละแพลตฟอร์มก่อนรันครั้งแรก:

```bash
flutter create . --project-name flutter_learn --org com.example
flutter pub get
flutter run
```

> `flutter create .` จะสร้างเฉพาะไฟล์ที่ยังไม่มี (android/, ios/, web/ ฯลฯ) และไม่เขียนทับโค้ดใน `lib/`

รันเทสต์:

```bash
flutter test
```

### หมายเหตุสำหรับ Android (release build)

แอปโหลดฟอนต์ Prompt ผ่าน `google_fonts` จากอินเทอร์เน็ต ให้เพิ่มสิทธิ์นี้ใน `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## โครงสร้างโปรเจกต์

```
lib/
├── main.dart               จุดเริ่มต้นของแอป
├── app.dart                MaterialApp + Theme
├── data/
│   ├── curriculum.dart     เนื้อหาบทเรียนและควิซทั้งหมด
│   └── glossary.dart       คำศัพท์และเกร็ดความรู้
├── demos/                  เดโมแบบ interactive (1 ไฟล์ต่อ 1 บท)
├── models/lesson.dart      โมเดล Lesson, Module, Quiz
├── screens/                หน้าจอทั้งหมด
├── state/app_state.dart    เก็บความคืบหน้า (ChangeNotifier + SharedPreferences)
├── theme/app_theme.dart    สีและธีม
├── utils/                  ตัวไฮไลต์โค้ด Dart
└── widgets/                Widget ที่ใช้ซ้ำ
```

## เพิ่มบทเรียนใหม่

เปิด `lib/data/curriculum.dart` แล้วเพิ่ม `Lesson(...)` ลงในหมวดที่ต้องการ เนื้อหาประกอบด้วย block เหล่านี้:

| Block | ใช้ทำอะไร |
| --- | --- |
| `ParagraphBlock` | ย่อหน้าข้อความ |
| `HeadingBlock` | หัวข้อย่อย |
| `BulletsBlock` | รายการแบบมีเครื่องหมายถูก |
| `CalloutBlock` | กล่องเปรียบเทียบ (analogy) / เคล็ดลับ (tip) / คำเตือน (warning) |
| `CodeBlock` | โค้ดพร้อมไฮไลต์สีและปุ่มคัดลอก |
| `DemoBlock` | Widget ที่ให้ผู้เรียนลองเล่น |
