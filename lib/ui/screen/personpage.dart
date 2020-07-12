import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamexample/bloc/bloc_provider.dart';
import 'package:streamexample/bloc/personbloc.dart';
import 'package:streamexample/bloc/viewpersonbloc.dart';
import 'package:streamexample/model/person.dart';
import 'package:streamexample/ui/screen/viewpersonpage.dart';
import 'package:streamexample/ui/widget/dropdown.dart';

class PersonsPage extends StatefulWidget {
  PersonsPage({
    Key key,
    this.title
  }) : super(key: key);

  final String title;

  @override
  _personsPageState createState() => _personsPageState();
}

class _personsPageState extends State<PersonsPage> {
  PersonsBloc _personsBloc;

  @override
  void initState() {
    super.initState();
    _personsBloc = BlocProvider.of<PersonsBloc>(context);
  }

  void _addperson() async {
    Person person = new Person(
      name: 'newPerson',
      age: 0,
    );
    _personsBloc.addConnection.incomming.add(person);
  }

  void _navigateToperson(Person person) async {
    bool update = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          bloc: ViewPersonBloc(),
          child: ViewPersonPage(
            person: person,
          ),
        ),
      ),
    );
    if (update != null) {
      _personsBloc.addConnection.getData();
    }
  }

  void _grand_parents(value) {
    _personsBloc.getParents.incomming.add(value);
    _personsBloc.getChildren.incomming.add(null);
  }

  void _parents_children(value) {
    _personsBloc.getChildren.incomming.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<List<Person>>(
              stream: _personsBloc.addConnection.outputStream,
              builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
                List<Person> persons = [];
                if (snapshot.hasData) {
                  persons = snapshot.data;
                }
                return Text("total: ${persons.length}",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                );
              },
            ),
            StreamBuilder<List<Person>>(
              stream: _personsBloc.getGrandParents.outputStream,
              builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
                List<Person> persons = [];
                List<ListItem> list=[];
                if (snapshot.hasData) {
                  persons = snapshot.data;
                }
                persons.forEach((person) {
                  list.add(ListItem(
                    key:person.id,
                    value:person,
                  ));
                });
                return DropDown(
                  hint:"Abuelo",
                  icon:Icons.people,
                  items: list,
                  onChanged:(newValue){
                      _navigateToperson(newValue.value);
                    _grand_parents(newValue.value);
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder<List<Person>>(
              stream: _personsBloc.getParents.outputStream,
              builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
                List<Person> persons = [];
                List<ListItem> list=[];
                if (snapshot.hasData) {
                  persons = snapshot.data;
                }
                persons.forEach((person) {
                  list.add(ListItem(
                    key:person.id,
                    value:person,
                  ));
                });
                return DropDown(
                  hint:"Padre",
                  icon:Icons.person,
                  items: list,
                  onChanged:(newValue){
                      _navigateToperson(newValue.value);
                    _parents_children(newValue.value);
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder<List<Person>>(
              stream: _personsBloc.getChildren.outputStream,
              builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
                List<Person> persons = [];
                List<ListItem> list=[];
                if (snapshot.hasData) {
                  persons = snapshot.data;
                }
                persons.forEach((person) {
                  list.add(ListItem(
                    key:person.id,
                    value:person,
                  ));
                });
                return DropDown(
                  hint:"Hijo",
                  icon:Icons.child_care,
                  items: list,
                  onChanged:(newValue){
                      _navigateToperson(newValue.value);
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addperson,
        child: Icon(Icons.add),
      ),
    );
  }


}