// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hair_color.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HairColorAdapter extends TypeAdapter<HairColor> {
  @override
  final int typeId = 2;

  @override
  HairColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HairColor.brown;
      case 1:
        return HairColor.blond;
      case 2:
        return HairColor.black;
      default:
        return HairColor.black;
    }
  }

  @override
  void write(BinaryWriter writer, HairColor obj) {
    switch (obj) {
      case HairColor.brown:
        writer.writeByte(0);
        break;
      case HairColor.blond:
        writer.writeByte(1);
        break;
      case HairColor.black:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HairColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
