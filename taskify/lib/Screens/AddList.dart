import 'package:flutter/material.dart';
import 'package:taskify/Screens/AddTask.dart';
import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';

class AddList extends StatelessWidget {
  //const SendInstructionsView({Key? key}) : super(key: key);
  bool buttonenabled = false;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Create List',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'List Name:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 50,
              child: TextFormField(
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Categorey:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButton<String>(
              //style: Theme.of(context).inputDecorationTheme.border,
              focusColor: Color.fromARGB(255, 69, 31, 156),
              borderRadius: BorderRadius.circular(25),
              isExpanded: true,
              hint: Text('Select any category', style: TextStyle(fontSize: 15)),
              items: <String>['Home', 'University', 'Work', 'Grocery']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            SizedBox(
              height: 16,
            ),
            CheckboxListTile(
              title: Text("Do you want it to be shared?"),
              value: buttonenabled,
              onChanged: (_) {},
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    //navigate to check email view
                    Util.routeToWidget(context, InviteFriend());
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
