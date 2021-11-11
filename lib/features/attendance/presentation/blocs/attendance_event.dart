part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {
}
class CheckAttendance extends AttendanceEvent {
  final AttendanceType type;
  final String spCode;

  CheckAttendance({required this.type,required this.spCode});
}

class Attendance extends AttendanceEvent {
  final AttendanceType type;
  final List<String> spCode;
  final LocationData position;
  final File img;

  Attendance({required this.type, required this.spCode, required this.position, required this.img});
}
