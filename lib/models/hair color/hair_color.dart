
import 'package:hive/hive.dart';

part'hair_color.g.dart';

//we can use enums as we used person and user objects
@HiveType(typeId: 2)
enum HairColor{

  @HiveField(0)
  brown,

  @HiveField(1)
  blond,

  //make black as default enum
  @HiveField(2,defaultValue: true)
  black

}