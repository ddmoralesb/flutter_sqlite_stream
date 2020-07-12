import 'dart:core';
import 'package:streamexample/bloc/bloc_provider.dart';
import 'package:streamexample/bloc/connection.dart';

class PersonsBloc implements BlocBase {
  AddConnection addConnection=AddConnection();
  GetGrandParentsConnection getGrandParents=GetGrandParentsConnection();
  GetConnection getParents=GetConnection();
  GetConnection getChildren=GetConnection();

  PersonsBloc(){
    addConnection.getData();
    getGrandParents.getData();
  }

  @override
  void dispose() {
    addConnection.close();
    getGrandParents.close();
    getParents.close();
    getChildren.close();
  }
}


