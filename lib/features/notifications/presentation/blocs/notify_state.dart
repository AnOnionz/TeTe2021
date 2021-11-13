part of 'notify_cubit.dart';

@immutable
abstract class NotifyState {}

class NotifyInitial extends NotifyState {}
class NotifyLoading extends NotifyState {}
class NotifyFailure extends NotifyState {}
class NotifySuccess extends NotifyState {
  final List<NotifyEntity> notifies;

  NotifySuccess({required this.notifies});
}
