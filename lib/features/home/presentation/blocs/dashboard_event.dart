part of 'dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}
class CheckOutlet extends DashboardEvent {}
class RefreshDashboard extends DashboardEvent {}
class SaveServerDataToLocalData extends DashboardEvent {}
class SyncRequired extends DashboardEvent {
  final String message;

  SyncRequired({required this.message});
}
class AccessInternet extends DashboardEvent {}
class InternalServer extends DashboardEvent {
  final int? willPop;

  InternalServer({this.willPop});
}
class RequiredCheckInOrCheckOut extends DashboardEvent {
  final String message;
  final int willPop;

  RequiredCheckInOrCheckOut({required this.message,required this.willPop});
}
class RequireUpdateNewVersion extends DashboardEvent{

}
class OtherOutlet extends DashboardEvent {
}




