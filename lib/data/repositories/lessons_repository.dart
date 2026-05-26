import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rost/data/models/lesson.dart';

class LessonsRepository {
  Future<List<Lesson>> getLessons() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('lessons_cache').get();
      print('✅ Данные из Firestore: ${snapshot.docs.length} занятий'); // ← логи
      return snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Firestore недоступен, беру из Hive: $e'); // ← логи
      final box = Hive.box<Lesson>('lessons_cache');
      print('📦 Данные из Hive: ${box.values.length} занятий'); // ← логи
      return box.values.toList();
    }
  }

  // Получить занятия за конкретную дату
  Future<List<Lesson>> getLessonsByDate(DateTime date) async {
    final lessons = await getLessons();
    return lessons.where((lesson) {
      return lesson.date.year == date.year &&
          lesson.date.month == date.month &&
          lesson.date.day == date.day;
    }).toList();
  }

  //добавление занятия
  Future<void> addLesson(Lesson lesson) async {
    await FirebaseFirestore.instance
        .collection('lessons_cache')
        .add(lesson.toMap());

    final box = Hive.box<Lesson>('lessons_cache');
    await box.put(lesson.id, lesson);
  }

  //Удаление занятия
  Future<void> deleteLesson(String id) async {
    await FirebaseFirestore.instance
        .collection('lessons_cache')
        .doc(id)
        .delete();

    final box = Hive.box<Lesson>('lessons_cache');
    await box.delete(id);
  }
}
