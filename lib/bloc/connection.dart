import 'dart:async';

import 'package:streamexample/model/person.dart';
import 'package:streamexample/repository/database.dart';

abstract class Connection{
  final outController = StreamController<List<Person>>.broadcast();
  Stream<List<Person>> get outputStream => outController.stream;
  StreamSink<List<Person>> get inputStream => outController.sink;
  final inController = StreamController<Person>.broadcast();
  StreamSink<Person> get incomming => inController.sink;

  Connection(){
    inController.stream.listen(_handleAction);
  }

  void actionToDo(Person person);

  void _handleAction(Person person) async {
    actionToDo(person);
    getData();
  }

  Future<List<Person>> doData();

  void getData() async {
    push(await doData());
  }

  void push(List<Person> persons) async{
    inputStream.add(persons);
  }

  close(){
    outController.close();
    inController.close();
  }
}

class AddConnection extends Connection{
  @override
  void actionToDo(Person person) async{
    await DBProvider.db.newPerson(person);
  }
  @override
  Future<List<Person>> doData() async {
    return await DBProvider.db.getPersons();
  }
}

class GetGrandParentsConnection extends Connection{
  @override
  void actionToDo(Person person) async{
  }

  @override
  Future<List<Person>> doData() async {
    List<Person> persons=[];
    persons = await DBProvider.db.getGrandPhathers();
    return persons;
  }
}

class GetConnection extends Connection{
  Person person;

  @override
  void actionToDo(Person person) async{
    this.person=person;
  }

  @override
  Future<List<Person>> doData() async {
    List<Person> persons=[];
    persons = await DBProvider.db.getChildren(this.person);
    return persons;
  }
}