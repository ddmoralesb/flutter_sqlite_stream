
import 'package:flutter/material.dart';
import 'package:streamexample/bloc/bloc_provider.dart';
import 'package:streamexample/bloc/viewpersonbloc.dart';
import 'package:streamexample/model/person.dart';

class ViewPersonPage extends StatefulWidget {
  ViewPersonPage({
    Key key,
    this.person
  }) : super(key: key);

  final Person person;

  @override
  _ViewPersonPageState createState() => _ViewPersonPageState();
}

class _ViewPersonPageState extends State<ViewPersonPage> {
  ViewPersonBloc _viewPersonBloc;
  TextEditingController _personNameController = new TextEditingController();
  TextEditingController _personAgeController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewPersonBloc = BlocProvider.of<ViewPersonBloc>(context);
    _personNameController.text = widget.person.name;
    _personAgeController.text = "${widget.person.age}";
  }

  void _saveperson() async {
    widget.person.name = _personNameController.text;
    widget.person.age = int.parse(_personAgeController.text);

    // Add the updated person to the save person stream. This triggers the function
    // we set in the listener.
    _viewPersonBloc.updateConnection.incomming.add(widget.person);
  }

  void _deleteperson() {
    // Add the person id to the delete person stream. This triggers the function
    // we set in the listener.
    _viewPersonBloc.deleteConnection.incomming.add(widget.person);

    // Wait for `deleted` to be set before popping back to the main page. This guarantees there's no
    // mismatch between what's stored in the database and what's being displayed on the page.
    // This is usually only an issue with more database heavy actions, but it's a good thing to
    // add regardless.
    _viewPersonBloc.deleteConnection.outputStream.listen((deleted) {
      if (deleted.length==0) {
        // Pop and return true to let the main page know that a person was deleted and that
        // it has to update the persons list.
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveperson,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteperson,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              maxLines: 1,
              controller: _personNameController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              maxLines: 1,
              controller: _personAgeController,
            ),
          ],
        )
      ),
    );
  }
}