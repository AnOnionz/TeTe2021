 import 'dart:async';
import 'package:bloc/bloc.dart';
 import 'package:dartz/dartz.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';
import '../../../../features/sync_data/domain/usecases/sync_usecase.dart';



 part 'sync_data_event.dart';
 part 'sync_data_state.dart';

 class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataState> {
   final SyncUseCase synchronous;

   SyncDataBloc({required this.synchronous}) : super(SyncDataInitial());

   @override
   Stream<SyncDataState> mapEventToState(
     SyncDataEvent event,
   ) async* {
     if(event is SyncStart){
       yield SyncDataLoading();
       final sync = await synchronous(NoParams());
       yield* _eitherSyncToState(sync);
     }
   }
 }
 Stream<SyncDataState> _eitherSyncToState(Either<Failure, SyncEntity> either,) async*{
   yield either.fold((fail) {
       displayError(fail);
       return SyncDataFailure(failure: fail);
   }, (success) => SyncDataSuccess(syncEntity: success));
 }
