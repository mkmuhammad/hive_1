

import 'package:hive/hive.dart';

part 'pet.g.dart';

//When you store custom objects in Hive you can extend HiveObject to manage your objects easily.
//HiveObject provides the key of your object and useful helper methods like save() or delete()
@HiveType(typeId: 3)
class Pet extends HiveObject{
  @HiveField(0)
  String name;

  Pet(this.name);


  @override
  String toString() => 'Pet: name=$name';
}


