import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/sales/domain/usecases/sale_usecase.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  final SaleUseCase sale;
  SaleCubit({required this.sale}) : super(SaleInitial());

  void saveSale(List<ProductEntity> products) async {
    emit(SaleLoading());
    final data = DataLocalEntity(data: products, isSync: false);
    final execute = await sale(SaleParam(sale: data));
    emit(execute.fold((l) {
      displayError(l);
      return SaleFailure();
    }, (r) {
      displaySuccess(message: "Lưu thành công");
      return SaleSuccess();
    }));
  }
}
