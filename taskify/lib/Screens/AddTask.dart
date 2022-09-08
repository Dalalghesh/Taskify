import 'package:flutter/material.dart';
import 'package:taskify/util.dart';

class AddTask extends StatelessWidget {
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
              'Add Task',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Task label:',
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
              'Task description:',
              maxLines: 3,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              child: TextFormField(
                minLines: 1,
                maxLines: 2, // allow user to enter 5 line in textfield
                keyboardType: TextInputType
                    .multiline, // user keyboard will have a button to move cursor to next line
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Pririty:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            DropdownButton<String>(
              //style: Theme.of(context).inputDecorationTheme.border,
              focusColor: Color.fromARGB(255, 69, 31, 156),
              borderRadius: BorderRadius.circular(25),
              isExpanded: true,
              hint: Text('Select priority', style: TextStyle(fontSize: 15)),
              items: <String>['High', 'Medium', 'Low'].map((String value) {
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
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    //navigate to check email view
                    Util.routeToWidget(context, AddTask());
                  },
                  child: Text(
                    'Add',
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
