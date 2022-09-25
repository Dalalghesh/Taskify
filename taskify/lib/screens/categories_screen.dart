import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/screens/todo_list_screen.dart';
import 'package:taskify/utils/app_colors.dart';
import "package:googleapis_auth/auth_io.dart";

import 'dart:io' show Platform;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  getCategories()async{
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<AppState>(context, listen: false).getCategories();

  }

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
    AppState provider =     Provider.of<AppState>(context, listen: true);

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
              body: Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.03, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    //const Text('Single Date Picker (With default value)'),
                    // CalendarDatePicker2(
                    //   config: config,
                    //   initialValue: _singleDatePickerValueWithDefaultValue,
                    //   onValueChanged: (values) =>
                    //       setState(() => _singleDatePickerValueWithDefaultValue = values),
                    //   selectableDayPredicate: (day) => !day
                    //       .difference(DateTime.now().subtract(const Duration(days: 3)))
                    //       .isNegative,
                    // ),\
                    SfCalendar(
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(getTasks()),
                    ),
                    const SizedBox(height: 10),

                    // TableCalendar(
                    //   focusedDay: DateTime.now(),
                    //   firstDay: DateTime.now(),
                    //   daysOfWeekHeight: 12,
                    //   lastDay: DateTime.now(),
                    // ),
                    const SizedBox(height: 10),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height/2.3,
                      child:  provider.categoriesLoading ? Center(
                        child: CircularProgressIndicator(),
                      ): GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 1.5

                      ),
                          itemCount: provider.categories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> TodoList(
                              category: provider.categories[index].toString(),
                            )));
                          },
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.all(4),
                            width: MediaQuery.of(context).size.width/2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Colors.grey,
                                ),
                              ],

                            ),
                            alignment: Alignment.center,
                            child: Text(provider.categories[index], style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),),
                          ),
                        );
                      })
                    )


                  ],
                ),
              ),
            ),
    );
  }
}
List<Appointment> getTasks(){
List<Appointment> tasks = [];
final DateTime today = DateTime.now();
final DateTime startTime = DateTime(today.year, today.month, today.day, 9,0,0);
final DateTime endTime = startTime.add(const Duration(hours: 2));

tasks.add(Appointment(startTime: startTime, endTime: endTime,
    color: Colors.blue));

return tasks;
}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments = source;
  }
}



