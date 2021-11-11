import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'attendance_type.dart';

class AttendanceEntity extends Equatable{
  final String outletCode;
  final AttendanceType type;
  final List<String> spCode;
  final LocationData position;
  final File image;

  const AttendanceEntity({required this.type,required this.spCode, required this.outletCode, required this.image, required this.position,});

  @override
  List<Object> get props => [type, spCode, outletCode, position, image];
}