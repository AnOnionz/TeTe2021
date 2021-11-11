part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {
}
class DashboardHasSync extends DashboardState {
  final String message;

  DashboardHasSync({required this.message});
}
class DashboardInitial extends DashboardState {}
class DashboardSaving extends DashboardState {}
class DashboardSaved extends DashboardState {
}
class DashboardRefresh extends DashboardState {}
class DashboardChangeOutlet extends DashboardState {}
class DashboardFailure extends DashboardState {
  final Failure failure;

  DashboardFailure({required this.failure});

}

