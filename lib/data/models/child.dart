import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Child extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String childName;
  @HiveField(2)
  final int childYear;
  @HiveField(3)
  final String? diagnosis;
  @HiveField(4)
  final String? notes;
  @HiveField(5)
  final String? parentName;
  @HiveField(6)
  final String? parentPhone;
  @HiveField(7)
  final int defaultPrice;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final bool isActive;

  Child({
    required this.id,
    required this.childName,
    required this.childYear,
    this.diagnosis,
    this.notes,
    this.parentName,
    this.parentPhone,
    this.defaultPrice = 1000,
    required this.createdAt,
    this.isActive = true,
  });

//Из Firestore → в Dart-объект
factory Child.fromFirestore(DocumentSnapshot doc)  {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return Child(
    id: doc.id,
    childName: data['childName'] ?? '',
    childYear: data['childYear'] ?? 0,
    diagnosis: data['diagnosis'],
    notes: data['notes'],
    parentName: data['parentName'],
    parentPhone: data['parentPhone'],
    defaultPrice: data['defaultPrice'] ?? 1000,
    createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    isActive: data['isActive'] ?? true,
  );
}

  /// Преобразование в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'childName': childName,
      'childYear': childYear,
      'diagnosis': diagnosis,
      'notes': notes,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'defaultPrice': defaultPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
  Child copyWith({
    String? childName,
    int? childYear,
    String? diagnosis,
    String? notes,
    String? parentName,
    String? parentPhone,
    int? defaultPrice,
    bool? isActive,
  }) {
    return Child(
      id: id,
      childName: childName ?? this.childName,
      childYear: childYear ?? this.childYear,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}


