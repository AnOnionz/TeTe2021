import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/home/domain/usecases/fetch_outlet_usecase.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';

part 'fetch_outlet_state.dart';

class FetchOutletCubit extends Cubit<FetchOutletState> {
  final FetchOutletUseCase findOutlet;
  FetchOutletCubit({required this.findOutlet}) : super(FetchOutletInitial());

  void find(String code) async {
    emit(FetchOutletLoading());
    final execute = await findOutlet(FetchOutletParams(code: code));
    emit(execute.fold((l) {
      displayError(l);
      return FetchOutletFailure(message: l.message);
    }, (r) => FetchOutletSuccess(outlet: r)));
  }
}
