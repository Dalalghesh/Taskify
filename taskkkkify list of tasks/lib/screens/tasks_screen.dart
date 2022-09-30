import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:intl/intl.dart';
import '../controller/UserController.dart';

class TaskScreen extends StatefulWidget {
  final String category;
  final String list;

  TaskScreen({Key? key, required this.category, required this.list}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppState>(context, listen: false).clearTask();
    getTask();
  }

  getTask() async {
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));

    Provider.of<AppState>(context, listen: false).getTasks(
        widget.category, widget.list);
    Provider.of<AppState>(context, listen: false).getCompletedTasks(
        widget.category, widget.list);
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build

    return buildColumnNew(context, provider);

    // return Scaffold(
    //   appBar: AppBar(
    //     // elevation: 0,
    //     backgroundColor: Colors.white,
    //     centerTitle: true,
    //     title: Text(widget.list, style: TextStyle(color: Colors.black, fontSize: 18),),
    //   ),
    //
    //   body:buildColumnNew(context, provider)
    //   // body:buildColumnOld(context, provider)
    //
    //
    //
    //
    // );
    // throw UnimplementedError();
  }

  Column buildColumnOld(BuildContext context, AppState provider) {
    return Column(
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2.5,
          child: provider.tasksLoading ? Center(
            child: CircularProgressIndicator(),) :
          provider.tasksList.isEmpty ? Center(child: Text('List is empty',
            style: TextStyle(color: Colors.black, fontSize: 18),)) :

          ListView.builder(
              itemCount: provider.tasksList.length,
              shrinkWrap: true,

              itemBuilder: (context, index) {
                return

                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,

                          )
                        ],
                        borderRadius: BorderRadius.circular(8)
                    ),
                    //alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: provider.tasksList[index].priority == 'High'
                                ? Color.fromARGB(255, 223, 123, 123)
                                : provider.tasksList[index].priority == 'Medium'
                                ? Color.fromARGB(255, 223, 180, 123) :
                            Color.fromARGB(255, 152, 224, 154)
                            ,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(provider.tasksList[index].task,

                          textAlign: TextAlign.left,
                        ),

                        Checkbox(value: provider.tasksList[index].value,
                            onChanged: (v) {
                              provider.updateCheckboxValue(v!, index);
                            })

                      ],
                    ),
                  );
              }),
        ),

        SizedBox(height: 10,),
        Text('Completed',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        SizedBox(height: 10,),

        Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2.5,
          child: provider.completedtasksLoading ? Center(
            child: CircularProgressIndicator(),) :
          provider.completedtasksList.isEmpty ? Center(child: Text(
            'List is empty',
            style: TextStyle(color: Colors.black, fontSize: 18),)) :

          ListView.builder(
              itemCount: provider.completedtasksList.length,
              shrinkWrap: true,

              itemBuilder: (context, index) {
                return

                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,

                          )
                        ],
                        borderRadius: BorderRadius.circular(8)
                    ),
                    //alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: provider.completedtasksList[index]
                                .priority == 'High' ? Color.fromARGB(255, 223,
                                123, 123) : provider.completedtasksList[index]
                                .priority == 'Medium'
                                ? Color.fromARGB(255, 223, 180, 123) :
                            Color.fromARGB(255, 152, 224, 154)
                            ,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(provider.completedtasksList[index].task,

                          textAlign: TextAlign.left,
                        ),
                        Container(),

                        // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                        //   provider.updateCheckboxValue(v!, index);
                        // })

                      ],
                    ),
                  );
              }),
        ),


      ],
    );
  }

  List<TasksCn> tasks = [];

  Widget buildColumnNew(BuildContext context, AppState provider) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.list,
              style: TextStyle(color: Colors.black, fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            // give the app bar rounded corners
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: AppBar(
                  // backgroundColor: Color(0xff7b39ed),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.45,
                            // height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              shape: BoxShape.rectangle,
                              // You can use like this way or like the below line
                              borderRadius: new BorderRadius.circular(20.0),
                              color: Color(0xff7b39ed),
                            ), child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: const Text("Pending")),
                        )),
                      ),
                      Tab(
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.45,
                            // height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              shape: BoxShape.rectangle,
                              // You can use like this way or like the below line
                              borderRadius: new BorderRadius.circular(20.0),
                              color: Color(0xff7b39ed),
                            ), child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: const Text("Completed")),
                        )),
                      ),
                    ],
                  ),
                ),
              ),

              // create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [

                    /// Pending
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 2.5,
                      child: provider.tasksLoading ? Center(
                        child: CircularProgressIndicator(),) :
                      provider.tasksList.isEmpty ? Center(child: Text(
                        'List is empty', style: TextStyle(color: Colors.black,
                          fontSize: 18),)) :

                      Column(
                        children: [
                          ListView.builder(
                              itemCount: provider.tasksList.length,
                              shrinkWrap: true,

                              itemBuilder: (context, index) {
                                Timestamp timestamp = provider.tasksList[index]
                                    .deadline;
                                DateTime dateTime = timestamp.toDate();
                                bool isAfterDeadLine = DateTime.now().isAfter(
                                    dateTime);
                                String dateOnly = DateFormat('dd/MM/yyyy')
                                    .format(dateTime);

                                /// It will be only return date DD/MM/YYYY format
                                return Container(
                                  height: 65,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 3,

                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  //alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(left: 16),
                                        decoration: BoxDecoration(
                                          color: provider.tasksList[index]
                                              .priority == 'High'
                                              ? Color.fromARGB(
                                              255, 223, 123, 123)
                                              : provider.tasksList[index]
                                              .priority == 'Medium'
                                              ? Color.fromARGB(
                                              255, 223, 180, 123) :
                                          Color.fromARGB(255, 152, 224, 154)
                                          ,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text(provider.tasksList[index].task,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text('${dateOnly} ${isAfterDeadLine
                                              ? " - (late)"
                                              : ""}', style: TextStyle(
                                            color: isAfterDeadLine
                                                ? Colors.red
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),)
                                        ],
                                      ),

                                      Checkbox(value: provider.tasksList[index]
                                          .value, onChanged: (v) {
                                        // provider.updateCheckboxValue(v!, index);
                                        setState(() {
                                          provider.tasksList[index].value = v!;
                                        });
                                        if (v! == true) {
                                          tasks.add(TasksCn(index, v));
                                        } else {
                                          tasks.removeWhere((element) =>
                                          element.first == index);
                                        }

                                        print(tasks.length);
                                        print(v!);
                                      })

                                    ],
                                  ),
                                );
                              }),

                          SizedBox(height: 20,),


                          Padding(
                            padding: const EdgeInsets.only(right: 20.0,
                                left: 20.0),
                            child: MaterialButton(
                              color: tasks.length > 0
                                  ? Color(0xff7b39ed)
                                  : Colors.grey,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: tasks.length > 0 ? () {

                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you want to convert selected tasks to Completed?',
                                  confirmBtnText: 'Yes',
                                  cancelBtnText: 'No',
                                  onCancelBtnTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  onConfirmBtnTap: (){
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: "List Added successfully to Completed !",
                                      confirmBtnColor: const Color(0xff7b39ed),
                                      onConfirmBtnTap: () {
                                        tasks.forEach((element) {
                                          provider.updateCheckboxValue(element.second!, element.first);
                                        });
                                        tasks.clear();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      }
                                    );
                                  },
                                  confirmBtnColor: Color(0xff7b39ed),
                                );

                                // tasks.forEach((element) {
                                //   provider.updateCheckboxValue(element.second!, element.first);
                                // });
                                // provider.updateCheckboxValue(v!, index);
                              } : () {},
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  'Convert to Completed',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),


                    ),

                    /// Completed
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 2.5,
                      child: provider.completedtasksLoading ? Center(
                        child: CircularProgressIndicator(),) :
                      provider.completedtasksList.isEmpty ? Center(child: Text(
                        'List is empty', style: TextStyle(color: Colors.black,
                          fontSize: 18),)) :

                      ListView.builder(
                          itemCount: provider.completedtasksList.length,
                          shrinkWrap: true,

                          itemBuilder: (context, index) {
                            return

                              Container(
                                height: 50,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 3,

                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                //alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(left: 16),
                                      decoration: BoxDecoration(
                                        color: provider
                                            .completedtasksList[index]
                                            .priority == 'High'
                                            ? Color.fromARGB(255, 223, 123, 123)
                                            : provider.completedtasksList[index]
                                            .priority == 'Medium'
                                            ? Color.fromARGB(255, 223, 180, 123)
                                            :
                                        Color.fromARGB(255, 152, 224, 154)
                                        ,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      provider.completedtasksList[index].task,

                                      textAlign: TextAlign.left,
                                    ),
                                    Container(),

                                    // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                                    //   provider.updateCheckboxValue(v!, index);
                                    // })

                                  ],
                                ),
                              );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

}
class TasksCn{
  int first ;
  bool? second ;
  TasksCn(this.first , this.second);
}
