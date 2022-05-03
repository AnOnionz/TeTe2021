import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import '../../../../features/home/presentation/blocs/dashboard_bloc.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/sampling_inventory/domain/usecases/sampling_inventory_usecase.dart';

part 'sampling_inventory_state.dart';

class SamplingInventoryCubit extends Cubit<SamplingInventoryState> {
  final SamplingInventoryUseCase samplingInventory;
  SamplingInventoryCubit({required this.samplingInventory}) : super(SamplingInventoryInitial());

  void saveSamplingInventory (List<ProductEntity> products) async {
    emit(SamplingInventoryLoading());
    final data = DataLocalEntity(data: products, isSync: false);
    final execute = await samplingInventory(SamplingInventoryParam(samplingInventory: data));
    emit(execute.fold((l) {
      displayError(l);
      return SamplingInventoryFailure();
    }, (r) {
      displaySuccess(message: "Lưu thành công");
      return SamplingInventorySuccess();
    }));
    Modular.get<DashboardBloc>().add(RefreshDashboard());
  }


}
