// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildAdapter extends TypeAdapter<Child> {
  @override
  final int typeId = 0;

  @override
  Child read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Child(
      id: fields[0] as String,
      childName: fields[1] as String,
      childYear: fields[2] as int,
      diagnosis: fields[3] as String?,
      notes: fields[4] as String?,
      parentName: fields[5] as String?,
      parentPhone: fields[6] as String?,
      defaultPrice: fields[7] as int,
      createdAt: fields[8] as DateTime,
      isActive: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Child obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.childName)
      ..writeByte(2)
      ..write(obj.childYear)
      ..writeByte(3)
      ..write(obj.diagnosis)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.parentName)
      ..writeByte(6)
      ..write(obj.parentPhone)
      ..writeByte(7)
      ..write(obj.defaultPrice)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
