 part of 'sync_data_bloc.dart';


 abstract class SyncDataState {}

 class SyncDataCloseDialog extends SyncDataState {

 }
 class SyncDataInitial extends SyncDataState {}
 class SyncDataLoading extends SyncDataState {}
 class SyncDataSuccess extends SyncDataState {
  final SyncEntity syncEntity;

  SyncDataSuccess({required this.syncEntity});
 }
 class SyncDataFailure extends SyncDataState {
   final Failure failure;

   SyncDataFailure({required this.failure});

 }
