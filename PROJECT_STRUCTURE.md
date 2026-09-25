# โครงสร้างโปรเจกต์ Flutter Learn

แอป **Flutter Learn** เป็นแอปสอน Flutter ที่มีบทเรียน เดโมให้ลองกดเล่น และควิซ

## 📁 `lib/` — โค้ดหลักของแอป

| ไฟล์/Folder | หน้าที่ |
|---|---|
| [main.dart](lib/main.dart) | จุดเริ่มแอป โหลด `SharedPreferences` แล้วสร้าง `AppState` จากนั้นสั่ง `runApp` |
| [app.dart](lib/app.dart) | สร้าง `MaterialApp` ตั้งธีมสว่าง/มืด และกำหนดหน้าแรกเป็น `MainShell` |
| [data/](lib/data/) | **ข้อมูลเนื้อหา** [curriculum.dart](lib/data/curriculum.dart) คือหลักสูตรทั้งหมด (หมวด → บทเรียน → เนื้อหา) ส่วน [glossary.dart](lib/data/glossary.dart) คือคำศัพท์ |
| [models/](lib/models/) | **โครงสร้างข้อมูล** [lesson.dart](lib/models/lesson.dart) นิยาม `LearningModule`, `Lesson` และ `LessonBlock` ชนิดต่างๆ (ย่อหน้า, หัวข้อ, bullet, callout, โค้ด, เดโม) |
| [screens/](lib/screens/) | **หน้าจอเต็มหน้า** `main_shell` คือโครงที่มีแถบเมนูล่าง 4 แท็บ ได้แก่ หน้าแรก / บทเรียน / ควิซ / โปรไฟล์ และมีหน้าย่อย เช่น `module_screen`, `lesson_screen`, `quiz_play_screen`, `glossary_screen` |
| [widgets/](lib/widgets/) | **ชิ้นส่วน UI ที่ใช้ซ้ำ** เช่น การ์ดหมวด (`module_card`), แถวบทเรียน (`lesson_tile`), กล่องโค้ด (`code_view`) และตัววาดแต่ละ block ของบทเรียน (`lesson_block_view`) |
| [demos/](lib/demos/) | **เดโมให้ลองเล่นในบทเรียน** แต่ละไฟล์คือ widget เล็กๆ หนึ่งตัวที่สาธิตแนวคิดเดียว เช่น counter, Row/Column, Stack, ListView, animation, navigation ถูกฝังในบทเรียนผ่าน `DemoBlock` |
| [state/](lib/state/) | **สถานะของแอป** [app_state.dart](lib/state/app_state.dart) เป็น `ChangeNotifier` เก็บบทที่เรียนจบ คะแนนควิซสูงสุด และธีม โดยบันทึกลงเครื่องด้วย SharedPreferences |
| [theme/](lib/theme/) | สี ฟอนต์ และธีมสว่าง/มืด ([app_theme.dart](lib/theme/app_theme.dart) ใช้ google_fonts) |
| [utils/](lib/utils/) | ตัวช่วยทั่วไป [dart_highlighter.dart](lib/utils/dart_highlighter.dart) ทำ syntax highlight ให้โค้ด Dart ที่แสดงในบทเรียน |

### ข้อมูลไหลอย่างไร

```
data (เนื้อหา)
  └─ ถูกนิยามรูปร่างด้วย models
       └─ แสดงผลใน screens โดยใช้ชิ้นส่วนจาก widgets และ demos
            └─ ความคืบหน้าของผู้เรียนเก็บใน state
```

## 📁 `test/`

[widget_test.dart](test/widget_test.dart) เก็บ unit/widget test รันด้วย `flutter test`

## 📁 Folder ของแต่ละแพลตฟอร์ม (ปกติแทบไม่ต้องแตะ)

- **`android/`** เป็นโปรเจกต์ Android (Gradle, Kotlin `MainActivity`, ไอคอนใน `res/mipmap-*`, `AndroidManifest.xml`) จะเข้าไปแก้ก็ตอนเปลี่ยนชื่อแอป ไอคอน หรือ permission
- **`ios/`** เป็นโปรเจกต์ Xcode (`Runner`, `Info.plist`, `AppIcon`) ต้องใช้ Mac ถึงจะ build ได้
- **`web/`, `windows/`, `macos/`, `linux/`** เป็นตัว runner สำหรับแต่ละแพลตฟอร์ม ถ้าไม่ได้ทำแอปลงแพลตฟอร์มไหนก็ลบ folder นั้นทิ้งได้
- โฟลเดอร์ย่อย `ephemeral/` ข้างในแต่ละแพลตฟอร์มเป็นไฟล์ที่ Flutter สร้างขึ้นเองอัตโนมัติ ไม่ต้องแก้

## 📁 Folder ที่ระบบสร้างให้ (ไม่ต้องสนใจ และไม่ควร commit)

- **`build/`** เก็บผลลัพธ์จากการ build
- **`.dart_tool/`** เป็น cache ของ Dart/pub
- **`.idea/`** และ `flutter_learn.iml` เป็นไฟล์ตั้งค่าของ Android Studio/IntelliJ

## 📄 ไฟล์สำคัญที่ root

- [pubspec.yaml](pubspec.yaml) ระบุชื่อแอป เวอร์ชัน และ dependency (`google_fonts`, `shared_preferences`) เทียบได้กับ `package.json`
- `pubspec.lock` ล็อกเวอร์ชันของ dependency ที่ติดตั้งจริง
- [analysis_options.yaml](analysis_options.yaml) เป็นกฎของ linter (`flutter_lints`)
- `.metadata` คือข้อมูลที่ Flutter ใช้ตอนอัปเกรดโปรเจกต์

## ➕ ถ้าจะเพิ่มบทเรียนใหม่

1. เพิ่มเนื้อหาใน [lib/data/curriculum.dart](lib/data/curriculum.dart)
2. ถ้าบทนั้นมีเดโม ให้สร้างไฟล์ใหม่ใน [lib/demos/](lib/demos/) แล้วใส่ลงบทเรียนผ่าน `DemoBlock`
