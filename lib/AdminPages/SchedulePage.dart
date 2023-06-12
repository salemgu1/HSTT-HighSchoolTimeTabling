import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetabler/MaxSat/Schedule.dart';

import '../teacherPages/teacherSchedulePage.dart';

Map<int, String> daysHash = {
  1: 'Sunday',
  2: 'Monday',
  3: 'Tuesday',
  4: 'Wednesday',
  5: 'Thursday',
};

class SchedulePage extends StatefulWidget {
  final List<Teacher> teachers;
  final List<Classroom> classrooms;

  SchedulePage({required this.teachers, required this.classrooms});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Teacher> teachers = [];
  List<Classroom> classrooms = [];
  List<Schedule> filteredSchedule =
      []; // Filtered schedule based on search query
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    print("initState");
    super.initState();
    teachers = widget.teachers;
    classrooms = widget.classrooms;
    filteredSchedule = buildSchedule(teachers, classrooms, students);
  }

  void filterSchedule(String query) {
    setState(() {
      print("filterSchedule");
      filteredSchedule =
          buildSchedule(teachers, classrooms, students).where((item) {
        final teacherName = item.teacher.name.toLowerCase();
        final searchLowercase = query.toLowerCase();
        return teacherName.contains(searchLowercase);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
    ];

    String? selectedDay;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSchedule,
              decoration: InputDecoration(
                labelText: 'Search by Teacher Name',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: daysOfWeek.length,
              itemBuilder: (context, index) {
                final day = daysOfWeek[index];
                final lessonsInDay = filteredSchedule
                    .where((item) => daysHash[item.day] == day)
                    .toList();
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                    ),
                    // if (selectedDay == day)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lessonsInDay.length,
                        itemBuilder: (context, index) {
                          final item = lessonsInDay[index];
                          return Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.person),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${item.teacher.name}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      const SizedBox(width: 8),
                                      Text('${item.classroom.name}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time),
                                      const SizedBox(width: 8),
                                      Text('${daysHash[item.day]}'),
                                      const SizedBox(width: 8),
                                      Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                                      Text(
                                          '${item.hour}:00 to ${item.hour + 1}:00'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Future<List<Schedule>> getSchedule(String username) async {
//   List<Schedule> result = buildSchedule(teachers, classrooms, students);
//   List<Schedule> sch = [];
//   for (Schedule s in result) {
//     if (s.teacher.name == username) {
//       sch.add(s);
//     }
//   }
//   // print(sch);
//   return sch;
// }
}
