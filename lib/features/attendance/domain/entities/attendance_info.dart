import 'package:equatable/equatable.dart';

class AttendanceInfo extends Equatable {
  final int spID;
  final String spCode;
  final String fullName;

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceInfo(
      spID: json['sp_id'],
      spCode: json['sp_code'],
      fullName: json['full_name'],
    );
  }

  const AttendanceInfo({required this.spID, required this.spCode, required this.fullName});

  @override
  List<Object> get props => [spID,spCode, fullName];
}