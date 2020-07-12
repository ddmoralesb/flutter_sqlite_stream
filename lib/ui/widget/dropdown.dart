import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  List<ListItem> items;
  ListItem selectedItem;
  final String hint;
  final IconData icon;
  final ValueChanged<dynamic> onChanged;

  DropDown({Key key,
    @required this.icon,
    @required this.onChanged,
    @required this.hint,
    this.items,
  });

  @override
  State<StatefulWidget> createState() {
    return _DropDown();
  }
}

class ListItem {
  dynamic key;
  dynamic value;
  ListItem({
    this.key,
    this.value
  });

  @override
  String toString() {
    return value!=null?value.toString():null;
  }
}

List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List<ListItem> listItems) {
  List<DropdownMenuItem<ListItem>> items = [];
  if(listItems!=null){
    for (int i=0;i<listItems.length;i++) {
      items.add(
        DropdownMenuItem(
          child: Text("${listItems[i].value}"),
          value: listItems[i],
        ),
      );
    }
  }
  return items;
}


class _DropDown extends State<DropDown>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
                border: null,
              ),
              child:
              Column(
                children: [
                  InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon:Container(
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.lightBlue,Colors.blueAccent,]
                          ),
                        ),
                        child: Icon(widget.icon,color: Colors.white,),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          hint: Text(widget.hint),
                          iconSize: 0,
                          isDense: true,
                          value: widget.selectedItem,
                          items: buildDropDownMenuItems(widget.items),
                          onChanged: (value) {
                            setState(() {
                              widget.selectedItem = value;
                              if(widget.onChanged!=null){
                                widget.onChanged(value);
                              }
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}