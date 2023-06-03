class User{
  String name;
  User(this.name);

  @override
  String toString() => name;
}

//there is two ways of storing object; 1.creating obj and it's adapter and writing everything custom 2. using annotation and hive generator