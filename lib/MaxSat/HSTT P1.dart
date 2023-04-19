//
//
//
// /*we defined a :
// 	5 subjects ,
// 	5 teachers ,
// 	4 hours of learning ,
// 	3 classes ,
// 	10 students
//  just to make a SAT solution to provide a partial time table . */
//
//
// /*
//
// Each subject must be taught by a specific teacher.
// Each class must have a specific set of subjects.
// Each subject must be taught in a specific room.
// Each class must have a specific number of students.
// Each student must be in a specific class.
// Each teacher must teach a specific number of hours per week.
//
// */
// import 'dart:core';
// import 'dart:core';
//
// import '../logic_solver/logic_solver.dart';
//
// // Define a list of subjects
// List<String> subjects = ["Math", "Science", "English", "History", "Art"];
//
// // Define a list of teachers
// List<String> teachers = ["Mr. Smith", "Mrs. Johnson", "Ms. Williams", "Mr. Brown", "Mrs. Davis"];
//
// // Define a list of rooms
// List<String> rooms = ["Room 1", "Room 2", "Room 3", "Room 4"];
//
// // Define a list of time slots
// List<String> timeslots = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM"];
//
// // Define a list of classes
// List<String> classes = ["Class A", "Class B", "Class C"];
//
// // Define a list of students
// List<String> students = ["Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hannah", "Ivan", "Jasmine"];
//
// // Define a map that assigns subjects to teachers
// Map<String, String> subjectTeachers = {
//   "Math": "Mr. Smith",
//   "Science": "Mrs. Johnson",
//   "English": "Ms. Williams",
//   "History": "Mr. Brown",
//   "Art": "Mrs. Davis"
// };
//
// // Define a map that assigns subjects to rooms
// Map<String, String> subjectRooms = {
//   "Math": "Room 1",
//   "Science": "Room 2",
//   "English": "Room 3",
//   "History": "Room 4",
//   "Art": "Room 1"
// };
//
// // Define a map that assigns classes to sets of subjects
// Map<String, Set<String>> classSubjects = {
//   "Class A": {"Math", "Science", "English"},
//   "Class B": {"Math", "Science", "English", "History"},
//   "Class C": {"Math", "Science", "English", "History", "Art"}
// };
//
// // Define a map that assigns classes to numbers of students
// Map<String, int> classSizes = {
//   "Class A": 5,
//   "Class B": 6,
//   "Class C": 9
// };
//
// // Define a map that assigns students to classes
// Map<String, String> studentClasses = {
//   "Alice": "Class A",
//   "Bob": "Class A",
//   "Charlie": "Class A",
//   "David": "Class A",
//   "Eve": "Class A",
//   "Frank": "Class B",
//   "Grace": "Class B",
//   "Hannah": "Class B",
//   "Ivan": "Class B",
//   "Jasmine": "Class C"
// };
// Map<String, String> days = {
//
// };
//
// Map<String, int> teacherHours = {
//   "Mr. Smith": 10,
//   "Mrs. Johnson": 10,
//   "Ms. Williams": 8,
//   "Mr. Brown": 8,
//   "Mrs. Davis": 8
// };
//
//
// // Add constraints to ensure that each teacher teaches a specific number of hours per day
// Map<String, int> teacherHoursPerDay = {
//   "Mr. Smith": 2,
//   "Mrs. Johnson": 2,
//   "Ms. Williams": 2,
//   "Mr. Brown": 2,
//   "Mrs. Davis": 2
// };
//
//
//
// // creat a solver instance :
//
// Solver solver = new Solver();
//
// // Create variables for each subject-teacher-room-timeslot-class combination
//
// Map<String, Map<String, Map<String, Map<String, Map<String, Variable>>>>> variables = {};
// void algorithm() {
//   for (String subject in subjects) {
//     variables[subject] = {};
//     for (String teacher in teachers) {
//       variables[subject]![teacher] = {};
//       for (String room in rooms) {
//         variables[subject]![teacher]![room] = {};
//         for (String timeslot in timeslots) {
//           variables[subject]![teacher]![room]![timeslot] = {};
//           for (String clas in classes) {
//             variables[subject]![teacher]![room]![timeslot]![clas] =
//                 solver.newVariable();
//           }
//         }
//       }
//     }
//     // Add constraints to ensure that each subject is taught by the correct teacher, each class has the correct set of subjects, each subject is taught in the correct room, and each class has the correct number of students
//     for (String subject in subjects) {
//       String? teacher = subjectTeachers[subject];
//       for (String clas in classes) {
//         for (String room in rooms) {
//           for (String timeslot in timeslots) {
//             Variable? variable = variables[subject]![teacher]![room]![timeslot]![clas];
//             solver.add(Null);
//           }
//         }
//       }
//     }
//     for (String clas in classes) {
//       Set<String>? subjectsForClass = classSubjects[clas];
//       for (String subject in subjects) {
//         List<Variable> variablesForSubject;
//         // = [for (String teacher in teachers) for (String room in rooms) for (String timeslot in timeslots)];
//         if (subjectsForClass!.contains(subject)) {
//           solver.add(Null);
//         } else {
//           // solver.add() for (Variable variable in variablesForSubject])]);
//         }
//       }
//     }
//
//     for (String subject in subjects) {
//       String? room = subjectRooms[subject];
//       for (String clas in classes) {
//         for (String teacher in teachers) {
//           for (String timeslot in timeslots) {
//             Variable? variable = variables[subject]![teacher]![room]![timeslot]![clas];
//             solver.add(Null);
//           }
//         }
//       }
//     }
//
//     for (String clas in classes) {
//       int? classSize = classSizes[clas];
//       for (String student in students) {
//         String? studentClass = studentClasses[student];
//         if (studentClass == clas) {
//           List<Variable> variablesForStudent;
//           // = [for (String subject in subjects) for (String teacher in teachers) for (String room in rooms) for (String timeslot in timeslots) ];
//           solver.add(Null);
//         }
//       }
//     }
//
//     // Add constraints to ensure that each teacher teaches a specific number of hours per week
//
//     for (String teacher in teachers) {
//       int? hours = teacherHours[teacher];
//       for (String subject in subjects) {
//         for (String clas in classes) {
//           List<Variable> variablesForTeacher;
//           // = [for (String room in rooms) for (String timeslot in timeslots)];
//           solver.add(Null);
//         }
//       }
//     }
//
//     for (String day in days.values) {
//       for (String teacher in teachers) {
//         int? hours = teacherHoursPerDay[teacher];
//         for (String subject in subjects) {
//           for (String clas in classes) {
//             List<Variable> variablesForTeacher;
//             // = [for (String room in rooms)];
//             solver.add(Null);
//           }
//         }
//       }
//     }
//   }
//
//
//   // next constrints well be :
//
//
//   //1- ensure that each room is used for a specific number of hours per day
//
//   //2- ensure that each timeslot is used for a specific number of hours per day
//
//   //3- ensure that each subject is taught for a specific number of hours per week
//
//   //4- ensure that each subject is taught for a specific number of hours per day
//
//   //5- ensure that each class has a specific number of hours per week
//
//   //6- ensure that each class has a specific number of hours per day
//
//
//   //7- ensure that each student has a specific number of hours per week
// }



