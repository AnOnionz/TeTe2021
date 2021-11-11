part of 'attendance_bloc.dart';

@immutable
class AttendanceState  {

}
@immutable
class CheckAttendanceState  {
}
class CheckAttendanceInitial extends CheckAttendanceState{}
class CheckAttendanceLoading extends CheckAttendanceState{}
class CheckAttendanceSuccess extends CheckAttendanceState{
  final AttendanceInfo info;

  CheckAttendanceSuccess({required this.info});
}
class CheckAttendanceFailure extends CheckAttendanceState{}
class AttendanceInitial extends AttendanceState{}
class AttendanceLoading extends AttendanceState{}
class AttendanceSuccess extends AttendanceState{}
class AttendanceFailure extends AttendanceState{}

