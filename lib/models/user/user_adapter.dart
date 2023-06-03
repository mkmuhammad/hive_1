import 'package:hive/hive.dart';
import 'package:hive_1/models/user/user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  User read(BinaryReader reader) {
    return User(reader.read());
  }

  //type id is allowed between 0 to 223
  //Every type has a unique typeId which is used to find the correct adapter when a value is brought back from disk.
  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.name);
  }
}
