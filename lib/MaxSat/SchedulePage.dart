import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Teacher {
  String name;
  List<String> subjects; // the list of subjects the teacher can teach
  // Map<String,List<int>> availableHours;
  List<int> availableHours; // the list of hours the teacher is available to teach
  Teacher(this.name, this.subjects, this.availableHours);
}

class Classroom {
  String name;
  int capacity; // the maximum number of students the classroom can accommodate
  Classroom(this.name, this.capacity);
}

class Student {
  String name;
  List<String> subjects; // the list of subjects the student wants to study
  List<int> exhaustedHours; // the list of hours the student is exhausted and cannot attend class
  Student(this.name, this.subjects, this.exhaustedHours);
}

class Schedule {
  Teacher teacher;
  Classroom classroom;
  String subject;
  int day;
  int hour;
  Schedule(this.teacher, this.classroom, this.subject, this.day, this.hour);
}

List<Schedule> buildSchedule(List<Teacher> teachers, List<Classroom> classrooms, List<Student> students) {
  List<Schedule> schedule = [];
  List<String> subjects = []; // list of all unique subjects
  teachers.forEach((teacher) => subjects.addAll(teacher.subjects));
  students.forEach((student) => subjects.addAll(student.subjects));
  subjects = subjects.toSet().toList(); // remove duplicates

  for (int d = 1; d <= 5; d++) { // loop through each day
    for (int h = 1; h <= 8; h++) { // loop through each hour
      for (String subject in subjects) { // loop through each subject
        List<Teacher> availableTeachers = teachers.where((teacher) => teacher.subjects.contains(subject) && teacher.availableHours.contains(h)).toList();
        List<Classroom> availableClassrooms = classrooms.where((classroom) => classroom.capacity >= getNumberOfStudentsInClass(subject, students) && !isClassroomBooked(classroom.name, schedule, d, h)).toList();

        if (availableTeachers.isNotEmpty && availableClassrooms.isNotEmpty) {
          Teacher selectedTeacher = availableTeachers[0];
          Classroom selectedClassroom = availableClassrooms[0];
          schedule.add(Schedule(selectedTeacher, selectedClassroom, subject, d, h));
        }
      }
    }
  }
  return schedule;
}

int getNumberOfStudentsInClass(String subject, List<Student> students) {
  int count = 0;
  students.forEach((student) => count += student.subjects.contains(subject) ? 1 : 0);
  return count;
}

bool isClassroomBooked(String classroomName, List<Schedule> schedule, int day, int hour) {
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
        subtitle: Text('${schedule.classroom.name} - Day ${schedule.day} - Hour ${schedule.hour}'),
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
// Future<List<ParseObject>> getTeacherDFromDb() async {
//   QueryBuilder<ParseObject> queryTeacher =
//   QueryBuilder<ParseObject>(ParseObject('Teacher'));
//   final ParseResponse apiResponse = await queryTeacher.query();
//
//   if (apiResponse.success && apiResponse.results != null) {
//     return apiResponse.results as List<ParseObject>;
//   } else {
//     return [];
//   }
// }

// getTeachers() async {
//   final teathersDB = await getTeacherDFromDb();
//   for (int i = 0; i < teathersDB.length; i++) {
//     getTeacherHours(teathersDB[i]["available_hours"]);
//     teachers.add(Teacher(teathersDB[i]["id_number"], [teathersDB[i]["Subject"]], [1, 2, 3, 4, 5, 6, 7, 8]));
//   }
// }
//
// getTeacherHours(availableHours){
//   List<int> emptyList = [];
//   for (int i = 0; i < availableHours.length; i++) {
//     arr.add(availableHours);
//   }
// }


List<Teacher> teachers = [
  Teacher("1234", ["Science"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem2", ["English"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem3", [ "Social Studies"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem4", ["math"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem5", ["arabic"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem6", ["Hebrew"], [1, 2, 3, 4, 5, 6, 7, 8]),
  Teacher("salem7", ["history"], [1, 2, 3, 4, 5, 6, 7, 8])
];

List<Classroom> classrooms = [
  Classroom("Room 1", 30),
  Classroom("Room 2", 25),
  Classroom("Room 3", 20),
  Classroom("Room 4", 35),
  Classroom("Room 5", 35),
  Classroom("Room 6", 35),
  Classroom("Room 7", 35)
];


List<Student> students = [
  Student("salem", ["arabic", "English"], [1, 2]),
  Student("Alice", ["Hebrew", "English"], [1, 2]),
  Student("Bob", ["Science", "Social Studies"], [5, 6]),
  Student("Charlie", ["math", "Social Studies"], [3, 4]),
  Student("David", ["English", "Science"], [7, 8]),


];

List<Schedule> schedule = buildSchedule(teachers, classrooms, students);
List<Schedule> sch = [];

Set<Schedule> uniqueSchedule = Set<Schedule>.from(schedule);
List<Schedule> result = List<Schedule>.from(uniqueSchedule);


getschedule(teacherName){
  List<Schedule> sch = [];
  for(Schedule s in result){
    if(s.teacher.name==teacherName){
      sch.add(s);
    }
  }
  // print(sch);
  return sch;
}



// class SchedulePage extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return MaterialApp(
//       title: 'My App',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Main Screen'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // for (Schedule s in schedule) {
//               //         print("Teacher ${s.teacher.name} will teach ${s.subject} in ${s.classroom.name} on day ${s.day} at hour ${s.hour}");
//               // }
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       ListView.builder(
//                         itemCount: schedule.length,
//                         itemBuilder: (context, index) {
//                           for (Schedule s in schedule) {
//                             print("Teacher ${s.teacher.name} will teach ${s.subject} in ${s.classroom.name} on day ${s.day} at hour ${s.hour}");
//                           }
//                           return Card(
//                             child: ListTile(
//                               title: Text('Teacher: ${result[index].teacher.name}'),
//                               subtitle: Text('Subject: ${result[index].subject}\nClassroom: ${result[index].classroom.name}\nDay: ${result[index].day}\nHour: ${result[index].hour}:00 to ${result[index].hour+1}:00'),
//                             ),
//                           );
//                         },
//                       ),
//                 ),
//               );
//             },
//             child: Text('View Schedule'),
//           ),
//         ),
//       ),
//     );
//   }
// }


//
// void main() {
//   List<Teacher> teachers = [
//     Teacher("Mr. A", ["Math"], [1, 2, 3, 4, 5, 6, 7, 8]),
//     Teacher("Ms. B", ["English"], [2, 3, 4, 5, 6]),
//     Teacher("Mr. C", ["Math"], [1, 2, 3, 7, 8]),
//     Teacher("Ms. D", ["Science"], [4, 5, 6])
//   ];
//
//   List<Classroom> classrooms = [
//     Classroom("Room 1", 30),
//     Classroom("Room 2", 25),
//     Classroom("Room 3", 20),
//     Classroom("Room 4", 35)
//   ];
//
//   List<Student> students = [
//     Student("Alice", ["Math", "English"], [1, 2]),
//     Student("Bob", ["Science", "Social Studies"], [5, 6]),
//     Student("Charlie", ["Math", "Social Studies"], [3, 4]),
//     Student("David", ["English", "Science"], [7, 8])
//   ];
//
//   List<Schedule> schedule = buildSchedule(teachers, classrooms, students);
//   List<Schedule> sch = [];
//
//   Set<Schedule> uniqueSchedule = Set<Schedule>.from(schedule);
//   List<Schedule> result = List<Schedule>.from(uniqueSchedule);
//
//
//
//
//   List<Schedule> getSchedule(){
//     return schedule;
//   }
//
//
//   for (Schedule s in result) {
//     print("Teacher ${s.teacher.name} will teach ${s.subject} in ${s.classroom.name} on day ${s.day} at hour ${s.hour}");
//   }
// }
//
//
//
//   // List<Teacher> teachers = [
//   //   Teacher("Mr. A", "Math", [9,10,11,12,13,14,15,16]),
//   //   Teacher("Mr. B", "Arabic", {"Sunday": [9,10,11,12,13,14,15,16],"Monday": [11,12,13,14,15,16],"Tuesday": [12,13,14,15,16],"Wednesday": [9,10,11,12,13,14,15,16],"Thursday":[13,14,15,16]}),
//   //   Teacher("Mr. C", "English", {"Sunday": [9,10,11,12,13,14,15,16],"Monday": [11,12,13,14,15,16],"Tuesday": [12,13,14,15,16],"Wednesday": [9,10,11,12,13,14,15,16],"Thursday":[13,14,15,16]}),
//   //   Teacher("Mr. D", "Hebrew", {"Sunday": [9,10,11,12,13,14,15,16],"Monday": [11,12,13,14,15,16],"Tuesday": [12,13,14,15,16],"Wednesday": [9,10,11,12,13,14,15,16],"Thursday":[13,14,15,16]}),
//   //   Teacher("Mr. E", "History", {"Sunday": [9,10,11,12,13,14,15,16],"Monday": [11,12,13,14,15,16],"Tuesday": [12,13,14,15,16],"Wednesday": [9,10,11,12,13,14,15,16],"Thursday":[13,14,15,16]})
//   // ];
//
//   List<Classroom> classrooms = [
//     Classroom("Room 1", 10),
//     Classroom("Room 2", 15),
//     Classroom("Room 3", 20),
//     Classroom("Room 5", 14),
//     Classroom("Room 6", 16),
//     Classroom("Room 7", 16),
//     Classroom("Room 8", 13),
//     Classroom("Room 9", 12),
//     Classroom("Room 10", 10)
//   ];
//
//   List<Student> students = [
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob",["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice",["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice",["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob",["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//     Student("Alice", ["Math", "English","Arabic","Hebrew","History"], [1, 2]),
//     Student("Bob", ["Math", "English","Arabic","Hebrew","History"], [5, 6]),
//     Student("Charlie", ["Math", "English","Arabic","Hebrew","History"], [3, 4]),
//     Student("David", ["Math", "English","Arabic","Hebrew","History"], [7, 8]),
//   ];
//
//
//

