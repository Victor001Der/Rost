import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rost/data/models/child.dart';

class ChildRepository {
  Future<List<Child>> getChildren() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('children').get();
      return snapshot.docs.map((doc) => Child.fromFirestore(doc)).toList();
    } catch (e) {
      final box = await Hive.openBox<Child>('children');
      return box.values.toList();
    }
  }

  //добавление ребенка
  Future<void> addChild(Child child) async {
    await FirebaseFirestore.instance
        .collection('children')
        .add(child.toMap());

    final box = Hive.box<Child>('children');
    await box.put(child.id, child);
  }

  //Удаление ребенка
  Future<void> deleteChild(String id) async {
    await FirebaseFirestore.instance.collection('children').doc(id).delete();

    final box = Hive.box<Child>('children');
    await box.delete(id);
  }
}
