// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoItemAdapter extends TypeAdapter<ToDoItem> {
  @override
  final int typeId = 0;

  @override
  ToDoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      isCompleted: fields[3] as bool,
      dateTime: fields[4] as DateTime,
      priority: fields[5] as Priority,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
