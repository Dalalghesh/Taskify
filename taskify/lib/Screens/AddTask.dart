import 'package:flutter/material.dart';
import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';

void main() {
  runApp(AddTask());
}

Widget build(BuildContext context) {
  return MaterialApp(
    home: AddTask(),
  );
}

class AddTask extends StatefulWidget {
  @override
  _AddTask createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  DateTime dateTime = new DateTime.now();
  final formKey = GlobalKey<FormState>(); //key for form
  late DateTime selectedDateTime;
  bool pressed = false;
  bool buttonenabled = false;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Util.routeToWidget(context, InviteFriend());
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "/Users/raghad/Desktop/Taskify/taskify/assets/AddTasks.png",
                      height: 200,
                      width: 200,
                    )),
                SizedBox(
                  height: 16,
                ),

                //-----------------------List name-----------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Task Name:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: Assignment',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Please enter a name";
                      else
                        return null;
                    },
                    style: Theme.of(context).textTheme.subtitle1),
                //-----------------------End of list name-----------------------

                SizedBox(
                  height: 8,
                ),
                //-----------------------Categorey-----------------------

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Categorey:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),

                Container(
                  child: DropdownButtonFormField(
                      //style
                      decoration: InputDecoration(
                          hintText: 'Home',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          )),

                      //style: Theme.of(context).inputDecorationTheme.border,
                      // focusColor: Color.fromARGB(255, 69, 31, 156),
                      //  borderRadius: BorderRadius.circular(25),
                      isExpanded: true,
                      hint: Text('Select any category',
                          style: TextStyle(fontSize: 15)),
                      //style

                      items: <String>['Home', 'University', 'Work', 'Grocery']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null)
                          return "Please choose category";
                        else
                          return null;
                      }),
                ),
                //-----------------------End of Categorey-----------------------
                SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Priority:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Container(
                  child: DropdownButtonFormField(
                      //style
                      decoration: InputDecoration(
                          hintText: 'Home',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          )),

                      //style: Theme.of(context).inputDecorationTheme.border,
                      // focusColor: Color.fromARGB(255, 69, 31, 156),
                      //  borderRadius: BorderRadius.circular(25),
                      isExpanded: true,
                      hint: Text('Choose priority',
                          style: TextStyle(fontSize: 15)),
                      //style

                      items:
                          <String>['High', 'Medium', 'Low'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null)
                          return "Please choose priority";
                        else
                          return null;
                      }),
                ),

                SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Deadline:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                /* ElevatedButton(
                    child: Text(
                        '${dateTime.day}/${dateTime.month}/${dateTime.year}'),
                    onPressed: () async {
                      final date = await pickDate();
                    }),*/

                SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        //navigate to check email view
                        if (formKey.currentState!.validate()) {
                          final snackBar =
                              SnackBar(content: Text("Created successfully"));
                          Util.routeToWidget(context, InviteFriend());
                          _scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
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
        ));
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(1900),
      );
}
