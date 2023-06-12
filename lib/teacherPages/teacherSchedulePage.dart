import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetabler/MaxSat/Schedule.dart';

Map<int, String> daysHash = {
  1: 'Sunday',
  2: 'Monday',
  3: 'Tuesday',
  4: 'Wednesday',
  5: 'Thursday',
};


class TeacherSchedulePage extends StatefulWidget {
  final List<Teacher> teachers;
  final List<Classroom> classrooms;

  TeacherSchedulePage({required this.teachers,required this.classrooms});

  @override
  _TeacherSchedulePageState createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
  List<Teacher> teachers = [];
  List<Classroom> classrooms = [];
  // String  teacherId = "";
  List<Schedule> filteredSchedule = []; // Filtered schedule based on search query
  TextEditingController searchController = TextEditingController();

@override
void initState() {
  print("initState");
  super.initState();
  teachers = widget.teachers;
  classrooms = widget.classrooms;
  // teacherId = widget.teacherId;
  filteredSchedule = buildSchedule(teachers, classrooms, students);
}


  void filterSchedule(String query) {
    setState(() {
      print("filterSchedule");
      filteredSchedule = buildSchedule(teachers, classrooms, students).where((item) {
        final teacherName = item.teacher.name.toLowerCase();
        final searchLowercase = query.toLowerCase();
        return teacherName.contains(searchLowercase);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: filteredSchedule.length,
              itemBuilder: (context, index) {
                final item = filteredSchedule[index];

                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(
                          '${item.teacher.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }


}
