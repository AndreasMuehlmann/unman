import 'package:flutter/material.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UnMan());
}

class UnMan extends StatefulWidget {
  const UnMan({Key? key}) : super(key: key);

  @override
  State<UnMan> createState() => _UnManState();
}

class _UnManState extends State<UnMan> {
  @override
  Widget build(BuildContext context) {
    //get rid of this
    const Color theme = Color.fromARGB(255, 30, 30, 30);
    const Color oppositeTheme = Color.fromARGB(255, 255, 255, 255);

    const Color themeColorLight = Color.fromARGB(255, 230, 115, 115);
    const Color themeColor = Color.fromARGB(255, 240, 70, 50);
    const Color themeColorDark = Color.fromARGB(255, 200, 45, 45);

    const Color accentColorLight = Color.fromARGB(255, 250, 180, 80);
    const Color accentColor = Color.fromARGB(255, 245, 150, 0);
    const Color accentColorDark = Color.fromARGB(255, 235, 120, 0);

    return MaterialApp(
      /*

      USE THIS

      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.red[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      */

      home: Scaffold(
        backgroundColor: theme,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: const Text('UnMan'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.lock, color: themeColor, size: 200),
            TextField(
              cursorColor: themeColor,
              style: TextStyle(color: theme),
              obscureText: true,
              decoration: InputDecoration(
                fillColor: accentColorDark,
                filled: true,
                hintText: 'Enter the masterpassword',
                hintStyle: TextStyle(color: theme),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeColorDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*

USE SUBCLASSES

class PasswordTextField extends StatelessWidget {
  const PasswordTextField ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextField(
      cursorColor: themeColor,
      style: TextStyle(color: theme),
      obscureText: true,
      decoration: InputDecoration(
        fillColor: accentColorDark,
        filled: true,
        hintText: 'Enter the masterpassword',
        hintStyle: TextStyle(color: theme),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeColorDark),
        ),
      ),
    );
  }
}
*/

class Account {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? info;

  Account(this.id, this.name, this.email, this.password, [this.info]);

  factory Account.fromMap(Map<String, dynamic> json) => Account(
        json['id'],
        json['name'],
        json['email'],
        json['password'],
        json['info'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'info': info,
    };
  }
}

class UnManDbHelper {
  UnManDbHelper._privateConstructor();
  static final UnManDbHelper instance = UnManDbHelper._privateConstructor();

  final String _name = 'unmandb';

  static Database? _database;

  Future<Database?> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path + _name);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contact(
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING NOT NULL, 
        email STRING NOT NULL,
        password STRING NOT NULL
        info STRING,
      )
    ''');
  }

  Future<List<Account>> getAccounts() async {
    var db = await instance.database;
    var accounts = await db!.query(_name, orderBy: 'name');
    List<Account> accountList =
        accounts.map((c) => Account.fromMap(c)).toList();
    return accountList;
  }
}
