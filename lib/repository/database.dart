import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamexample/model/person.dart';

class DBProvider {
	static const String table="Person";
	static const String tableId="id";
	static const String tableName="name";
	static const String tableAge="age";
	static const String tableParent="idParent";

	static const String DBNAME="person.db";
	static const int DBVERSION=1;
	// Create a singleton
	DBProvider._();

	static final DBProvider db = DBProvider._();
	Database _database;

	Future<Database> get database async {
		if (_database != null) {
			return _database;
		}

		_database = await initDB();
		return _database;
	}

	initDB() async {
        // Get the location of our apps directory. This is where files for our app, and only our app, are stored.
		// Files in this directory are deleted when the app is deleted.
		Directory documentsDir = await getApplicationDocumentsDirectory();
		String path = join(documentsDir.path, DBNAME);

		if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
			ByteData data = await rootBundle.load(join('assets', DBNAME));
			List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
			await new File(path).writeAsBytes(bytes);
		}

		return await openDatabase(path, version: DBVERSION, readOnly: false);
	}

	newPerson(Person person) async {
		final db = await database;
		var res = await db.insert('$table', person.toJson());

		return res;
	}

	getPersons() async {
		final db = await database;
		var res = await db.query('$table');
		List<Person> persons = res.isNotEmpty ? res.map((person) => Person.fromJson(person)).toList() : [];

		return persons;
	}

	getPerson(int id) async {
		final db = await database;
		var res = await db.query('$table', where: '$tableId = ?', whereArgs: [id]);

		return res.isNotEmpty ? Person.fromJson(res.first) : null;
	}

	getGrandPhathers() async{
			final db = await database;
			var res = await db.query('$table', where: '$tableParent IS NULL');
			List<Person> persons = res.isNotEmpty ? res.map((person) => Person.fromJson(person)).toList() : [];
			return persons;
		}

	updatePerson(Person person) async {
		final db = await database;
		var res = await db.update('$table', person.toJson(), where: '$tableId = ?', whereArgs: [person.id]);

		return res;
	}

	Future<int> deletePerson(int id) async {
		final db = await database;
		return db.delete('$table', where: '$tableId = ?', whereArgs: [id]);
	}

  getChildren(Person person) async{
		List<Person> persons=[];
		if(person!=null){
			final db = await database;
			var res = await db.query(
					'$table',
					where: '$tableParent = ?',
					whereArgs: [person.id]);
			persons= res.isNotEmpty ? res.map((person) => Person.fromJson(person)).toList() : [];
		}
		return persons;
	}
}