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
      List<Holiday> list = NHolidayJp.getByYear(year);
      tmpArr.addAll(list.map((item) {
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
