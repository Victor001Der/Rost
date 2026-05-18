import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rost/data/models/child.dart';

class ChildRepository {
  Future<List<Child>> getChildren() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('children_cache').get();
      print('✅ Данные из Firestore: ${snapshot.docs.length} детей'); // ← логи
      return snapshot.docs.map((doc) => Child.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Firestore недоступен, беру из Hive: $e'); // ← логи
      final box = Hive.box<Child>('children_cache');
      print('📦 Данные из Hive: ${box.values.length} детей'); // ← логи
      return box.values.toList();
    }
  }


  //добавление ребенка
  Future<void> addChild(Child child) async {
    await FirebaseFirestore.instance
        .collection('children_cache')
        .add(child.toMap());

    final box = Hive.box<Child>('children_cache');
    await box.put(child.id, child);
  }

  //Удаление ребенка
  Future<void> deleteChild(String id) async {
    await FirebaseFirestore.instance.collection('children_cache').doc(id).delete();

    final box = Hive.box<Child>('children_cache');
    await box.delete(id);
  }
}
