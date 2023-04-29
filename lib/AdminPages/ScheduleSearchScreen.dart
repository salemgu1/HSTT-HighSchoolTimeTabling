import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MaxSat/SchedulePage.dart';

class ScheduleSearchScreen extends StatefulWidget {
  final List<Schedule> schedules;

  ScheduleSearchScreen({ required this.schedules});

  @override
  _ScheduleSearchScreenState createState() => _ScheduleSearchScreenState();
}

class _ScheduleSearchScreenState extends State<ScheduleSearchScreen> {
  List<Schedule> filteredSchedules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by room name',
              ),
              onChanged: (value) {
                setState(() {
                  filteredSchedules = widget.schedules
                      .where((schedule) => schedule.classroom.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSchedules.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredSchedules[index].subject),
                  subtitle: Text(
                      'Teacher: ${filteredSchedules[index].teacher.name}, Room: ${filteredSchedules[index].classroom.name}, Day: ${filteredSchedules[index].day}, Hour: ${filteredSchedules[index].hour}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}