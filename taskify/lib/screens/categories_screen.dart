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
import 'package:taskify/utils/app_colors.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:taskify/utils.dart';

import 'dart:io' show Platform;

import 'SearchPage.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  getCategories() async {
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<AppState>(context, listen: false).getCategories();
    Provider.of<AppState>(context, listen: false).getTasksofDate();
  }

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  //static const _scopes =  [CalendarApi.CalendarScope];

  var _credentials;

  @override
  Widget build(BuildContext context) {
    // getCategories();
    AppState provider = Provider.of<AppState>(context, listen: true);

    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: AppColors.deepPurple,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
    );
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (sx) => sx.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.03, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TableCalendar(
                      rowHeight: 42.0,
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
                                height: 36,
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
                                            : Color.fromARGB(
                                                255, 152, 224, 154),
                                    // borderRadius: BorderRadius.all(
                                    //   Radius.circular(8.0),
                                    // ),
                                  ),
                                  child: Center(
                                    widthFactor: 10,
                                    heightFactor: 10,
                                    child: Text(
                                      '${day.day}',
                                      style:
                                          const TextStyle(color: Colors.white),
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
///////////////////////////////////////////////////
                        var datee = DateFormat("yyyy-MM-dd").format(selectDay);
                        print(datee);
                        provider.filterTasksByDate(datee);
                        print(
                            "provider.filteredTasks ${provider.filteredTasks}");
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
                    buildSearchBar(),
                    const SizedBox(height: 10),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 2.9,
                        child: provider.categoriesLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : provider.categories.isEmpty
                                ? Center(
                                    child: Text('There are no categories yet'),
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 2 / 1.5),
                                    itemCount: provider.categories.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TodoList(
                                                        category: provider
                                                            .categories[index]
                                                            .toString(),
                                                      ))).then((value) {
                                            setState(() {
                                              print("ffffffff");
                                              // Navigator.of(context).pop();
                                              getCategories();
                                            });
                                          });
                                        },
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  Icons.widgets,
                                                  color: Color(0xff7b39ed),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  provider.categories[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),

                                          height: 80,
                                          margin: EdgeInsets.all(4),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     blurRadius: 3,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ],
                                          ),
                                          alignment: Alignment.center,
                                          // child: Text(
                                          //   provider.categories[index],
                                          //   style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontSize: 18,
                                          //       fontWeight: FontWeight.w600),
                                          // ),
                                        ),
                                      );
                                    }))
                  ],
                ),
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
            onWillPop: () async {
              return true;
            },
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
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: provider.allTasksLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : provider.filteredTasks.isEmpty
                                        ? Center(
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
                                                                task: provider
                                                                        .filteredTasks[
                                                                    index],
                                                                taskOld: provider
                                                                        .filteredTasks[
                                                                    index],
                                                                index: index,
                                                              ))).then((value) {
                                                    // provider.filteredTasks.clear() ;
                                                    setState(() {
                                                      print("ffffffff");
                                                      Navigator.of(context)
                                                          .pop();
                                                      getCategories();
                                                    });
                                                    // setState(() {
                                                    //   print("ffffffff");
                                                    //   getCategories();
                                                    // });
                                                  });
                                                  //    DateTime date = provider.completedtasksList[index].deadline.toDate();
                                                  // var date1 =   DateFormat("yyyy-MM-dd").format(date);
                                                  //   print(date1);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 5,
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //     color: Colors.grey,
                                                      //     blurRadius: 3,
                                                      //   )
                                                      // ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  //alignment: Alignment.center,
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
                            ],
                          ),
                        ),
                      ),
                    ])),
          );
        });
  }

  Widget buildSearchBar() {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 12, left: 0),
                child: Icon(
                  Icons.search,
                ),
              ),
              const Expanded(
                child: Text(
                  "Search for task...",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  // style: OurTextStyle().title18(fontSize: 12 ,color: ThemeInformation.focusColor),
                ),
              ),
              const SizedBox(width: 8),
              Opacity(
                opacity: 0,
                child: GestureDetector(
                  onTap: () {
                    // Get.bottomSheet(
                    //   FilterBottomSheetWidget(),
                    //   isScrollControlled: true,
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      // color: ThemeInformation.focusColor.withOpacity(0.1),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: const [
                        Text(
                          "Filter", //style: OurTextStyle().title14(fontSize: 13 , color: ThemeInformation.PrimaryColor2)
                        ),
                        Icon(
                          Icons.filter_list,
                          // color: ThemeInformation.PrimaryColor2,
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Appointment> getTasks() {
  List<Appointment> tasks = [];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  tasks.add(Appointment(
      startTime: startTime, endTime: endTime, color: Color(0xff7b39ed)));

  return tasks;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
