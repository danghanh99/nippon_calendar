import 'package:flutter/material.dart';
import 'package:nholiday_jp/nholiday_jp.dart';
import 'package:nippon_calendar/services/notification_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Meeting> meetings = [];
  final CalendarController _calendarController = CalendarController();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    meetings = _getDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              _notificationService.scheduleNotification(
                "title",
                "body",
                13,
                55,
                DateTime.now(),
              );
            },
            child: const Text("Calendar"),
          ),
        ),
        body: SafeArea(
            child: SfCalendar(
          view: CalendarView.month,
          maxDate: DateTime(2050, 12, 31, 0, 0, 0),
          minDate: DateTime(2000, 01, 01, 0, 0, 0),
          dataSource: MeetingDataSource(meetings),
          controller: _calendarController,
          showDatePickerButton: true,
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
          ),
        )));
  }

  List<Meeting> _getDataSource() {
    List<Meeting> tmpArr = <Meeting>[];
    for (int year = 2000; year <= 2050; year++) {
      //month
      if (year >= DateTime.now().year) {
        List<Holiday> list1 = NHolidayJp.getByMonth(year, 1);
        List<Holiday> list2 = NHolidayJp.getByMonth(year, 2);
        List<Holiday> list3 = NHolidayJp.getByMonth(year, 3);
        List<Holiday> list4 = NHolidayJp.getByMonth(year, 4);
        List<Holiday> list5 = NHolidayJp.getByMonth(year, 5);
        List<Holiday> list6 = NHolidayJp.getByMonth(year, 6);
        List<Holiday> list7 = NHolidayJp.getByMonth(year, 7);
        List<Holiday> list8 = NHolidayJp.getByMonth(year, 8);
        List<Holiday> list9 = NHolidayJp.getByMonth(year, 9);
        List<Holiday> list10 = NHolidayJp.getByMonth(year, 10);
        List<Holiday> list11 = NHolidayJp.getByMonth(year, 11);
        List<Holiday> list12 = NHolidayJp.getByMonth(year, 12);

        NotificationService().callScheduleMonth(list1.length, 1, year);
        NotificationService().callScheduleMonth(list2.length, 2, year);
        NotificationService().callScheduleMonth(list3.length, 3, year);
        NotificationService().callScheduleMonth(list4.length, 4, year);
        NotificationService().callScheduleMonth(list5.length, 5, year);
        NotificationService().callScheduleMonth(list6.length, 6, year);
        NotificationService().callScheduleMonth(list7.length, 7, year);
        NotificationService().callScheduleMonth(list8.length, 8, year);
        NotificationService().callScheduleMonth(list9.length, 9, year);
        NotificationService().callScheduleMonth(list10.length, 10, year);
        NotificationService().callScheduleMonth(list11.length, 11, year);
        NotificationService().callScheduleMonth(list12.length, 12, year);
      }

      //month

      List<Holiday> list = NHolidayJp.getByYear(year);
      tmpArr.addAll(list.map((item) {
        if (year >= DateTime.now().year) {
          NotificationService().scheduleNotification(
            "Calendar",
            "You will have a day off ${item.name} after 3 days",
            10,
            0,
            DateTime(
              year,
              item.month,
              item.date,
            ).subtract(const Duration(days: 3)),
          );
        }

        return Meeting(
          item.name,
          DateTime(year, item.month, item.date, 9, 0, 0),
          DateTime(year, item.month, item.date, 9, 0, 0)
              .add(const Duration(hours: 2)),
          Colors.green,
          true,
        );
      }).toList());
      tmpArr;
    }
    return tmpArr;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
