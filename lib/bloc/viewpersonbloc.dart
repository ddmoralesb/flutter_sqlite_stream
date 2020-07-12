
import 'dart:async';

import 'package:streamexample/bloc/bloc_provider.dart';
import 'package:streamexample/bloc/connection.dart';
import 'package:streamexample/repository/database.dart';
import 'package:streamexample/model/person.dart';

class ViewPersonBloc implements BlocBase {

  UpdateConnection updateConnection=UpdateConnection();
  DeleteConnection deleteConnection=DeleteConnection();

  @override
  void dispose() {
    updateConnection.close();
    deleteConnection.close();
  }
}

class UpdateConnection extends Connection{
  @override
  void actionToDo(Person person) async{
    await DBProvider.db.updatePerson(person);
  }
  @override
  Future<List<Person>> doData() async {
    return [];
  }
}

class DeleteConnection extends Connection{
  Person person;
  int deleted;
  @override
  void actionToDo(Person person) async{
    this.deleted=await DBProvider.db.deletePerson(person.id);
    if(this.deleted==0){
      this.person=person;
    }
  }
  @override
  Future<List<Person>> doData() async {
    return this.deleted==0?[this.person]:[];
  }
}