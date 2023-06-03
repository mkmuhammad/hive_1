import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_1/models/person/person.dart';
import 'package:hive_1/models/pet/pet.dart';
import 'package:hive_1/models/user/user.dart';
import 'package:hive_1/models/user/user_adapter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter(colors: true, printTime: true));

void main() async {
  //registering adapter is better to be before opening any box
  Hive.registerAdapter(UserAdapter());

  Hive.registerAdapter(PersonAdapter());

  Hive.registerAdapter(PetAdapter());

  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, widget) {
          logger.i('rebuilds');
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
              primaryColor: Colors.grey,
              useMaterial3: true,
            ),
            themeMode: box.get('darkMode', defaultValue: false) ? ThemeMode.dark : ThemeMode.light,
            home: const MyHomePage(title: 'Flutter Home Page'),
            builder: EasyLoading.init(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? boxText = '';

  Future<Box?> _getTheBox(String name) async {
    try {
      var box = Hive.box(name);
      EasyLoading.showSuccess('');
      return box;
    } catch (e) {
      logger.e(e.toString());
      EasyLoading.showError('box not exist');
      return null;
    }
  }

  Future<bool> _openTheBox(String name) async {
    try {
      await Hive.openBox(name);
      EasyLoading.showSuccess('');
      return true;
    } catch (e) {
      EasyLoading.showError('box not exist');
      return false;
    }
  }

  void _getValue(String name, dynamic key) async {
    var box = await _getTheBox(name);
    var text = box != null ? box.get(key) : 'N/A';
    boxText = text;
    setState(() {});
  }

  Future<bool> _closeBox(String name) async {
    try {
      var box = await _getTheBox(name);
      await box!.close();
      EasyLoading.showSuccess('');
      return true;
    } catch (e) {
      EasyLoading.showError('');
      logger.e(e.toString());
      return false;
    }
  }

  Future<bool> _addValueToBox(String name, dynamic key, dynamic value) async {
    try {
      var box = await _getTheBox(name);
      await box!.put(key, value);
      EasyLoading.showSuccess('');
      return true;
    } catch (e) {
      EasyLoading.showError('');
      logger.e(e.toString());
      return false;
    }
  }

  void _putObjWithCustomAdapter(String boxName, dynamic key, User userValue) async {
    try {
      var box = await Hive.openBox<User>(boxName);
      box.put(key, userValue);
      logger.i(box.values);
    } catch (e) {
      EasyLoading.showError('');
      logger.e(e.toString());
    }
  }

  void _putObjWithGeneratedAdapter(String boxName, dynamic key, Person userValue) async {
    try {
      var box = await Hive.openBox<Person>(boxName);
      box.put(key, userValue);
      logger.i(box.values);
    } catch (e) {
      EasyLoading.showError('');
      logger.e(e.toString());
    }
  }

  void _putHiveObjWithGeneratedAdapter(String boxName, Pet userValue) async {
    try {
      var box = await Hive.openBox<Pet>(boxName);
      box.add(userValue);
      logger.i('after adding: ${box.values}');

      userValue.name = 'changing name to : ${userValue.name}2';

      await userValue.save(); //updating

      logger.i('after saving new value: ${box.values}');

      await userValue.delete();

      logger.i('after deleting new value: ${box.values}');

    } catch (e) {
      EasyLoading.showError('');
      logger.e(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              boxText ?? 'no value in the box',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            ///1. first you should open(create) a box with a name you want
            TextButton(
              onPressed: () {
                _openTheBox('firstBox');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Open The Box'),
            ),

            ///2. for using the box you opened before, you should open it first
            TextButton(
              onPressed: () {
                _getTheBox('firstBox');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Get The Box'),
            ),

            ///3. after opening a box you can get values from it
            TextButton(
              onPressed: () {
                _getValue('firstBox', 'name');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Get Value'),
            ),

            ///4. when you're done with your box you should close it and after closing you MUST open it again for further use
            TextButton(
              onPressed: () async {
                await _closeBox('firstBox');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Close The Box'),
            ),

            TextButton(
              onPressed: () async {
                _addValueToBox('firstBox', 'name', 'muhammad');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Put Value to Box'),
            ),

            ValueListenableBuilder<Box>(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, box, widget) {
                  return Switch(
                    value: box.get('darkMode', defaultValue: false),
                    onChanged: (val) {
                      box.put('darkMode', val);
                    },
                  );
                }),

            TextButton(
              onPressed: () async {
                _putObjWithCustomAdapter('userBox', 'david', User('DAVID'));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Put Obj with Custom Adapter'),
            ),

            TextButton(
              onPressed: () async {
                _putObjWithGeneratedAdapter('personBox', 'david', Person('My Person', 21, null));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Put Obj with Generated Adapter'),
            ),

            TextButton(
              onPressed: () async {
                _putHiveObjWithGeneratedAdapter('petBox', Pet('dog'));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Put Hive Obj with Generated Adapter'),
            ),
          ],
        ),
      ),
    );
  }
}
