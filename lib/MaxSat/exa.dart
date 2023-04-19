class TimeSystem {
  List<Teacher> teachers;
  List<Class> classes;
  List<Student> students;
  List<Schedule> schedules = [];

  TimeSystem(this.teachers, this.classes, this.students);

  void generateSchedules() {
    // Create a schedule for each teacher
    for (Teacher teacher in teachers) {
      Schedule schedule = Schedule(teacher);
      schedules.add(schedule);
    }

    // Assign classes to schedules based on teacher availability
    for (Class scheduledClass in classes) {
      // Find a teacher who is available during the class hours
      Teacher availableTeacher = teachers.firstWhere((teacher) =>
      teacher.subject == scheduledClass.name &&
          teacher.availableHours.any((availableHours) =>
          availableHours.day == scheduledClass.day &&
              availableHours.hours.contains(scheduledClass.hours)));

      // Assign the class to the teacher's schedule
      Schedule schedule = schedules.firstWhere(
              (schedule) => schedule.teacher == availableTeacher);
      schedule.assignClass(scheduledClass);

      // Assign students to the class and update their schedules
      List<Student> availableStudents = students
          .where((student) =>
          student.exhaustedSchedules.every((exhaustedSchedule) =>
          exhaustedSchedule.day != scheduledClass.day ||
              !exhaustedSchedule.hours.contains(scheduledClass.hours)))
          .toList();
      if (availableStudents.length > scheduledClass.maxStudents) {
        availableStudents = availableStudents.sublist(
            0, scheduledClass.maxStudents); // limit to maximum students
      }
      scheduledClass.students = availableStudents;
      schedule.assignStudents(availableStudents);
      availableStudents.forEach((student) => student.exhaustedSchedules
          .add(ExhaustedSchedule(scheduledClass.day, scheduledClass.hours)));
    }
  }

  void cancelClass(Class scheduledClass) {
    // Remove the class from its assigned teacher's schedule
    Schedule schedule = schedules.firstWhere(
            (schedule) => schedule.scheduledClass == scheduledClass);
    schedule.scheduledClass = null;
    schedule.scheduledStudents.forEach((student) => student.exhaustedSchedules
        .removeWhere((exhaustedSchedule) =>
    exhaustedSchedule.day == scheduledClass.day &&
        exhaustedSchedule.hours.contains(scheduledClass.hours)));
  }
}

class Teacher {
  String name;
  String subject;
  List<AvailableHours> availableHours;

  Teacher(this.name, this.subject, this.availableHours);
}

class AvailableHours {
  String day;
  List<int> hours;

  AvailableHours(this.day, this.hours);
}

class Class {
  String name;
  String day;
  List<int> hours;
  int maxStudents;
  List<Student> students = [];

  Class(this.name, this.day, this.hours, this.maxStudents);
}

class Student {
  String name;
  List<ExhaustedSchedule> exhaustedSchedules = [];

  Student(this.name);
}

class ExhaustedSchedule {
  String day;
  List<int> hours;

  ExhaustedSchedule(this.day, this.hours);
}

class Schedule {
  Teacher teacher;
  Class? scheduledClass;
  List<Student> scheduledStudents = [];

  Schedule(this.teacher);

  void assignClass(Class scheduledClass) {
    this.scheduledClass = scheduledClass;
  }

  void assignStudents(List<Student> scheduledStudents) {
    this.scheduledStudents = scheduledStudents;
  }
}

void main() {
  // Create some teachers
  Teacher t1 = Teacher(
      "John Smith",
      "Math",
      [
        AvailableHours("Monday", [1, 2, 3]),
        AvailableHours("Tuesday", [2, 3, 4]),
        AvailableHours("Wednesday", [1, 2, 3]),
        AvailableHours("Thursday", [2, 3, 4]),
        AvailableHours("Friday", [1, 2, 3])
      ]);

  Teacher t2 = Teacher(
      "Jane Doe",
      "English",
      [
        AvailableHours("Monday", [3, 4]),
        AvailableHours("Tuesday", [1, 2]),
        AvailableHours("Wednesday", [3, 4]),
        AvailableHours("Thursday", [1, 2]),
        AvailableHours("Friday", [3, 4])
      ]);

  Teacher t3 = Teacher(
      "Bob Johnson",
      "History",
      [
        AvailableHours("Monday", [2, 3]),
        AvailableHours("Tuesday", [3, 4]),
        AvailableHours("Wednesday", [2, 3]),
        AvailableHours("Thursday", [3, 4]),
        AvailableHours("Friday", [2, 3])
      ]);

  List<Teacher> teachers = [t1, t2, t3];

  // Create some classes
  Class c1 = Class("Math 101", "Monday", [1, 2], 20);
  Class c2 = Class("English 101", "Tuesday", [2, 3], 25);
  Class c3 = Class("History 101", "Wednesday", [3, 4], 30);

  List<Class> classes = [c1, c2, c3];

  // Create some students
  Student s1 = Student("Alice");
  Student s2 = Student("Bob");
  Student s3 = Student("Charlie");
  Student s4 = Student("Dave");

  List<Student> students = [s1, s2, s3, s4];

  // Create a TimeSystem instance and generate schedules
  TimeSystem timeSystem = TimeSystem(teachers, classes, students);
  timeSystem.generateSchedules();

  // Print out the schedules
  for (Schedule schedule in timeSystem.schedules) {
    if (schedule.scheduledClass != null) {
      print(
          "${schedule.teacher.name} is teaching ${schedule.scheduledClass!.name} on ${schedule.scheduledClass!.day} from ${schedule.scheduledClass!.hours[0]}-${schedule.scheduledClass!.hours[1]} with ${schedule.scheduledStudents.length} students");
    } else {
      print("${schedule.teacher.name} has no class scheduled");
    }
  }

  // Cancel a class and update schedules
  timeSystem.cancelClass(c1);

  // Print out the updated schedules
  for (Schedule schedule in timeSystem.schedules) {
    if (schedule.scheduledClass != null) {
      print(
          "${schedule.teacher.name} is teaching ${schedule.scheduledClass!.name} on ${schedule.scheduledClass!.day} from ${schedule.scheduledClass!.hours[0]}-${schedule.scheduledClass!.hours[1]} with ${schedule.scheduledStudents.length} students");
    } else {
      print("${schedule.teacher.name} has no class scheduled");
    }
  }
}

