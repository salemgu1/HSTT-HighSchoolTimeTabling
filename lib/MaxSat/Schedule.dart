import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Map<int, String> daysHash = {
  1: 'Sunday',
  2: 'Monday',
  3: 'Tuesday',
  4: 'Wednesday',
  5: 'Thursday',
};

class Teacher {
  String name;
  List<String> subjects; // the list of subjects the teacher can teach
  Map<String,List<int>> availableHours;
  // List<int> availableHours; // the list of hours the teacher is available to teach
  Teacher(this.name, this.subjects, this.availableHours);
}

class Classroom {
  String name;
  String
      capacity; // the maximum number of students the classroom can accommodate
  Classroom(this.name, this.capacity);
}

class StudentSchedule {
  String name;
  List<String> subjects; // the list of subjects the student wants to study
  List<int>
      exhaustedHours; // the list of hours the student is exhausted and cannot attend class
  StudentSchedule(this.name, this.subjects, this.exhaustedHours);
}

class Schedule {
  Teacher teacher;
  Classroom classroom;
  String subject;
  int day;
  int hour;
  Schedule(this.teacher, this.classroom, this.subject, this.day, this.hour);
}

List<Schedule> buildSchedule(List<Teacher> teachers, List<Classroom> classrooms,
    List<StudentSchedule> students) {
      print("buildSchedulebuildSchedulebuildSchedulebuildSchedule");
      for (var teacher in teachers) {
        print(teacher.name);
        print(teacher.availableHours);
      }
  List<Schedule> schedule = [];
  List<String> subjects = []; // list of all unique subjects
  teachers.forEach((teacher) => subjects.addAll(teacher.subjects));
  students.forEach((student) => subjects.addAll(student.subjects));

  subjects = subjects.toSet().toList(); // remove duplicates

  for (int d = 1; d <= 5; d++) {
    for (int h = 8; h <= 14; h++) {
      for (String subject in subjects) {
        List<Teacher> availableTeachers = teachers.where((teacher) => teacher.subjects.contains(subject) && teacher.availableHours.containsKey(daysHash[d]) && (teacher.availableHours[daysHash[d]])!.contains(h)).toList();
        List<Classroom> availableClassrooms = classrooms
            .where((classroom) =>
                int.parse(classroom.capacity) >=
                    getNumberOfStudentsInClass(subject, students) &&
                !isClassroomBooked(classroom.name, schedule, d, h))
            .toList();
        
        if (availableTeachers.isNotEmpty && availableClassrooms.isNotEmpty) {
          Teacher selectedTeacher = availableTeachers[0];
          Classroom selectedClassroom = availableClassrooms[0];
          schedule
              .add(Schedule(selectedTeacher, selectedClassroom, subject, d, h));
        }
      }
    }
  }
  return schedule;
}

int getNumberOfStudentsInClass(String subject, List<StudentSchedule> students) {
  int count = 0;
  students.forEach(
      (student) => count += student.subjects.contains(subject) ? 1 : 0);
  return count;
}

bool isClassroomBooked(
    String classroomName, List<Schedule> schedule, int day, int hour) {
  for (Schedule s in schedule) {
    if (s.classroom.name == classroomName && s.day == day && s.hour == hour) {
      return true;
    }
  }
  return false;
}

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.schedule),
        title: Text('${schedule.teacher.name} - ${schedule.subject}'),
        subtitle: Text(
            '${schedule.classroom.name} - Day ${schedule.day} - Hour ${schedule.hour}'),
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  final List<Schedule> schedule;

  const ScheduleScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (BuildContext context, int index) {
          return ScheduleCard(schedule: schedule[index]);
        },
      ),
    );
  }
}

//

Future<List<Teacher>> getTeachersBySchoolIdFromDb() async {
  String schoolId = await getSchoolIdFromCurrentUser();
  QueryBuilder<ParseObject> queryTeacher =
      QueryBuilder<ParseObject>(ParseObject('Teacher'));
  queryTeacher.whereEqualTo('school_id', schoolId); // Add this line to filter by school ID
  final ParseResponse apiResponse = await queryTeacher.query();
  Map<String, List<int>> hours = {
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
  };
  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> teacherData = apiResponse.results as List<ParseObject>;

    List<Teacher> teachers = [];

    for (var teacher in teacherData) {
      String teacherId = teacher.get('id_number');
      List<String> teacherSubject = [];
      teacherSubject.add(teacher.get('Subject'));
      List<int> teacherAvailableHours = [8, 9, 10, 11,12, 13, 14];
      if (teacher.get('available_hours') == null) {
        print("teacherIdteacherd");

        Map<String, List<int>> hours = {
          'Sunday': teacherAvailableHours,
          'Monday': teacherAvailableHours,
          'Tuesday': teacherAvailableHours,
          'Wednesday': teacherAvailableHours,
          'Thursday': teacherAvailableHours,
        };
        teachers.add(
          Teacher(teacherId, teacherSubject, hours),
        );
      } else {
        Map<String, String> convertedMap = {};

        teacher.get('available_hours').forEach((key, value) {
          convertedMap[key] = value.toString();
        });
        print("teacherIdteacherIdteacherIdteacherId");
        print(teacherId);
        teachers.add(
          Teacher(teacherId, teacherSubject, reformatHours(convertedMap)),
        );
      }
    }

    return teachers;
  } else {
    return []; // or throw an exception here if needed
  }
}

Future<String> getSchoolIdFromCurrentUser() async {
  final ParseUser? currentUser = await ParseUser.currentUser();
  if (currentUser != null) {
    final String? schoolId = currentUser.get('SchoolId');
    if (schoolId != null) {
      return schoolId;
    } else {
      throw Exception('School ID not found for current user.');
    }
  } else {
    throw Exception('No current user found.');
  }
}



Map<String,List<int>> reformatHours(Map<String, String> hours) {
  print("reformatHours");
  print(hours);
  Map<String, List<int>> hoursList = {};
  List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  for (var i = 0; i < days.length; i++) {
    if(hours[days[i]] != null){
      if(!hours[days[i]]!.contains("start")){
        print("start");
        hours[days[i]] = hours[days[i]]! +  "start: 08:00 AM";
      }
      if(!hours[days[i]]!.contains("end")){
        print("end");

        hours[days[i]] = hours[days[i]]! +  "end: 14:00 AM";
      }
      hoursList[days[i]] = getHours(hours[days[i]]!);
    }else{
      hoursList[days[i]] = [8, 9, 10, 11, 13, 14];
    }
  }
  print("hoursListhoursListhoursListhoursListhoursListhoursListhoursListhoursListhoursList");
  print(hoursList);
  return hoursList;
}

List<int> getHours(String hours) {

    String timeString = hours;
    // print(timeString);

    RegExp regExp = RegExp(r'\d{1,2}:\d{2}');

    Iterable<Match> matches = regExp.allMatches(timeString);

    List<String?> hours1 = matches.map((match) => match.group(0)).toList();
    List<int> hoursFormat = hours1.map((h) => int.parse(h![0] + h[1])).toList();
    List<int> hoursList = [];
    var end = 0;
    var start = 0;
    if(hoursFormat[1]!=null){
      end = hoursFormat[1];
    }else{
      end = 14;
    }
    if(hoursFormat[0]!=null){
      start = hoursFormat[0];
    }else{
      start = 0;
    }

    for(var i=start; i<=end;i++){
      hoursList.add(i);
    }
    return hoursList;
}


Future<List<Classroom>> getClassroomsFromDb() async {
  String schoolId = await getSchoolIdFromCurrentUser();
  QueryBuilder<ParseObject> queryRoom =
      QueryBuilder<ParseObject>(ParseObject('Room'));
  queryRoom.whereEqualTo('schoolId', schoolId); // Add this line to filter by school ID
  final ParseResponse apiResponse = await queryRoom.query();

  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> roomData = apiResponse.results as List<ParseObject>;

    List<Classroom> rooms = [];

    for (var room in roomData) {
      String roomId = room.get('room_id');
      String sets = room.get('sets');
      rooms.add(Classroom(roomId, sets));
    }


    return rooms;
  } else {
    return []; // or throw an exception here if needed
  }
}


List<StudentSchedule> students = [
  StudentSchedule("salem", ["arabic", "English"], [1, 2]),
  StudentSchedule("Alice", ["Hebrew", "English"], [1, 2]),
  StudentSchedule("Bob", ["Science", "Social Studies"], [5, 6]),
  StudentSchedule("Charlie", ["math", "Social Studies"], [3, 4]),
  StudentSchedule("David", ["English", "Science"], [7, 8]),
];
