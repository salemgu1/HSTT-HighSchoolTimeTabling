import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetabler/MaxSat/SchedulePage.dart';

Map<int, String> daysHash = {
  1: 'Sunday',
  2: 'Monday',
  3: 'Tuesday',
  4: 'Wednesday',
  5: 'Thursday',
};


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Schedule> filteredSchedule = []; // Filtered schedule based on search query
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSchedule = schedule; // Initially display all schedule items
  }

  void filterSchedule(String query) {
    setState(() {
      filteredSchedule = schedule.where((item) {
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
