import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import '../../../../features/home/presentation/blocs/dashboard_bloc.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/sampling_use/domain/usecases/sampling_use_usecase.dart';

part 'sampling_use_state.dart';

class SamplingUseCubit extends Cubit<SamplingUseState> {
  final SamplingUseUseCase samplingUse;
  SamplingUseCubit({required this.samplingUse}) : super(SamplingUseInitial());

  void saveSamplingUse(List<ProductEntity> products) async {
    emit(SamplingUseLoading());
    final data = DataLocalEntity(data: products, isSync: false);
    final execute = await samplingUse(SamplingUseParam(samplingUse: data));
    emit(execute.fold((l) {
      displayError(l);
      return SamplingUseFailure();
    }, (r) {
      displaySuccess(message: "Lưu thành công");
      Modular.to.pop();
      return SamplingUseSuccess();
    }));
    Modular.get<DashboardBloc>().add(RefreshDashboard());
  }
}
