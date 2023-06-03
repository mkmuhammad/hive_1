
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person{
  //Field numbers can be in the range 0-255.

  @HiveField(0) //for fields we want to store
  late String name;

  @HiveField(1,defaultValue: 20)
  late int age;

  @HiveField(2)
  List<Person>? friends;


  Person(this.name, this.age, this.friends);

  @override
  String toString() => 'Person: name=$name, age=$age, friends=${friends.toString()}';
}