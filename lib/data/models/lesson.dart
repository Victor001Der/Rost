import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'lesson.g.dart';

@HiveType(typeId: 1)
class Lesson extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String childId;
  @HiveField(2)
  final String childName;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final int? price;
  @HiveField(5)
  final String? notes;
  @HiveField(6)
  final DateTime createdAt;


  Lesson({
    required this.id,
    required this.childId,
    required this.childName,
    required this.date,
    this.price = 1000,
    this.notes,
    required this.createdAt,
  });

//Из Firestore → в Dart-объект
  factory Lesson.fromFirestore(DocumentSnapshot doc)  {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Lesson(
      id: doc.id,
      childId: data['childId'],
      childName: data['childName'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'],
      price: data['price'] ?? 1000,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Преобразование в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'childName': childName,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  Lesson copyWith({
    String? childId,
   String? childName,
   DateTime? date,
    String? notes,
    int? price,
  }) {
    return Lesson(
      id: id,
      childId: childId  ?? this.childId,
      childName: childName ?? this.childName,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      price: price ?? this.price,
      createdAt: createdAt,
    );
  }
}