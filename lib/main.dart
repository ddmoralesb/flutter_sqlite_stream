import 'package:flutter/material.dart';
import 'package:streamexample/bloc/bloc_provider.dart';
import 'package:streamexample/bloc/personbloc.dart';
import 'package:streamexample/ui/screen/personpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        bloc: PersonsBloc(),
        child: PersonsPage(title: 'All Persons'),
      ),
    );
  }
}


