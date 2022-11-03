import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/Screens/Task_Detail.dart';
import 'package:taskify/screens/todo_list_screen.dart';
import 'package:taskify/send_message.dart';
import 'package:taskify/utils/app_colors.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:taskify/utils.dart';
import 'dart:io' show Platform;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppState>(context, listen: false).getChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context, listen: true);

    return buildScaffold(provider);
    // return buildScaffoldOld(provider, context);
  }

  Scaffold buildScaffold(AppState provider) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(0, 255, 255, 255),
            ),
            onPressed: () {},
          ),
          title: const Text(
            'Chats',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff7b39ed),
        ),
        body: provider.chatLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.chatGroups.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        top: Get.height * 0.1, left: 125, right: 0),
                    child: Text(
                      'There are no chats yet',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.chatGroups.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendMessagePage(
                                      groups: provider.chatGroups[index])));
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.1,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 6, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          //alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.people,
                                color: Color(0xff7b39ed),
                              ),
                              Text(
                                provider.chatGroups[index].list,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Container()
                            ],
                          ),
                        ),
                      );
                    }));
  }

  Scaffold buildScaffoldOld(AppState provider, BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.03, left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2024),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  for (DateTime d in provider.toHighlight) {
                    if (day.day == d.day &&
                        day.month == d.month &&
                        day.year == d.year) {
                      String type = provider.getColorofDate(d);
                      print('$d $type');

                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        height: 46,
                        width: 33,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                            color: type == 'High'
                                ? Color.fromARGB(255, 223, 123, 123)
                                : type == 'Medium'
                                    ? Color.fromARGB(255, 241, 207, 65)
                                    : Color.fromARGB(255, 152, 224, 154),
                          ),
                          child: Center(
                            widthFactor: 10,
                            heightFactor: 10,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return null;
                },
              ),

              //changing calendar format
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed on select
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                var datee = DateFormat("yyyy-MM-dd").format(selectDay);
                print(datee);
                provider.filterTasksByDate(datee);
                showTasksDialog(context, datee);
                //print(selectDay);

                // print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Color(0xff7b39ed),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Color(0xff7b39ed),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  showTasksDialog(context, date) {
    AppState provider = Provider.of<AppState>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: context.theme.canvasColor,
                          ),
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 14, left: 10, right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: const Icon(
                                            Icons.close,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 14, left: 10, right: 10),
                                        child: Text(
                                          'Tasks of $date',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                height: 200,
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: provider.allTasksLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : provider.filteredTasks.isEmpty
                                        ? const Center(
                                            child:
                                                Text('There are no tasks yet'),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                provider.filteredTasks.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  // Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TaskDetail(
                                                                taskOld: provider
                                                                        .filteredTasks[
                                                                    index],
                                                                task: provider
                                                                        .filteredTasks[
                                                                    index],
                                                                index: index,
                                                              ))).then((value) {
                                                    getTask();
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 5,
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        margin: EdgeInsets.only(
                                                            left: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: provider
                                                                      .filteredTasks[
                                                                          index]
                                                                      .priority ==
                                                                  'High'
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  223,
                                                                  123,
                                                                  123)
                                                              : provider
                                                                          .filteredTasks[
                                                                              index]
                                                                          .priority ==
                                                                      'Medium'
                                                                  ? Color
                                                                      .fromARGB(
                                                                          255,
                                                                          223,
                                                                          180,
                                                                          123)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          152,
                                                                          224,
                                                                          154),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Text(
                                                        provider
                                                            .filteredTasks[
                                                                index]
                                                            .task,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                      Container(),

                                                      // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                                                      //   provider.updateCheckboxValue(v!, index);
                                                      // })
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(bottom: 10),
                              //   height:
                              //       MediaQuery.of(context).size.height * 0.05,
                              //   width: MediaQuery.of(context).size.width,
                              //   alignment: Alignment.bottomRight,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     crossAxisAlignment: CrossAxisAlignment.end,
                              //     children: [
                              //       GestureDetector(
                              //         onTap: () async {
                              //           Navigator.pop(context);
                              //         },
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Container(
                              //             margin: EdgeInsets.only(right: 20),
                              //             child: const Text(
                              //               'OK',
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.w600,
                              //                   fontSize: 16),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ])),
          );
        });
  }

  getTask() async {
    // await Future.delayed(Duration(milliseconds: 100));
    // // Provider.of<AppState>(context, listen: false).updateShowSubTasks(false);
    // Provider.of<AppState>(context, listen: false).clearTask();
    //
    // Provider.of<AppState>(context, listen: false).getTasks(widget.category, widget.list);
    // Provider.of<AppState>(context, listen: false)
    //     .getCompletedTasks(widget.category, widget.list);
    // Provider.of<AppState>(context, listen: false).getSubTasks();
  }
}
