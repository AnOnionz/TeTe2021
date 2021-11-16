import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import 'package:tete2021/core/usecases/usecase.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/home/presentation/blocs/dashboard_bloc.dart';
import 'package:tete2021/features/notifications/domain/entity/noti_entity.dart';
import 'package:tete2021/features/notifications/domain/usecase/noti_usecase.dart';

part 'notify_state.dart';

class NotifyCubit extends Cubit<NotifyState> {
  final NotifyUseCase notify;
  static bool isNewNotify = false;
  NotifyCubit({required this.notify}) : super(NotifyInitial());

  void fetchNotify(int type) async {
    emit(NotifyLoading());
    final execute = await notify(NotifyParams(type: type));
    emit(execute.fold((l) {
      displayError(l);
      return NotifyFailure();
    }, (r) {
      if(r.isNotEmpty && type == 1){
        isNewNotify = false;
        Modular.get<DashboardBloc>().add(RefreshDashboard());
      }
      if(r.isNotEmpty && type == 0){
        isNewNotify = r.any((element) => element.isNew);
      }
      return NotifySuccess(notifies: r);
    }));
  }
  void refreshData(int type) async {
    final execute = await notify(NotifyParams(type: type));
    emit(execute.fold((l) {
      displayError(l);
      return NotifyFailure();
    }, (r) {
      if(r.isNotEmpty && type == 1){
        isNewNotify = false;
      }
      if(r.isNotEmpty && type == 0){
        isNewNotify = r.any((element) => element.isNew);
      }
      displaySuccess(message: "dữ liệu đã được làm mới");
      return NotifySuccess(notifies: r);
    }));
  }
}
