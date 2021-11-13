import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tete2021/features/inventory/domain/usecases/inventory_out_usecase.dart';
import 'package:tete2021/features/notifications/data/datasources/noti_remote_data_source.dart';
import 'package:tete2021/features/notifications/data/repository/noti_repository_impl.dart';
import 'package:tete2021/features/notifications/domain/repositories/noti_repository.dart';
import 'package:tete2021/features/notifications/domain/usecase/noti_usecase.dart';
import 'package:tete2021/features/notifications/presentation/blocs/notify_cubit.dart';
import 'package:tete2021/features/notifications/presentation/screens/notification_page.dart';
import 'package:tete2021/features/sales/data/datasources/sale_local_data_source.dart';
import 'package:tete2021/features/sales/data/datasources/sale_use_remote_datasource.dart';
import 'package:tete2021/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:tete2021/features/sales/domain/repositories/sale_repository.dart';
import 'package:tete2021/features/sales/domain/usecases/sale_usecase.dart';
import 'package:tete2021/features/sales/presentation/blocs/sale_cubit.dart';
import 'package:tete2021/features/sales/presentation/screens/sale_use_page.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_remote_datasource.dart';
import 'package:tete2021/features/sampling_inventory/data/repositories/sampling_inventory_repository_impl.dart';
import 'package:tete2021/features/sampling_inventory/domain/repositories/sampling_inventory_repository.dart';
import 'package:tete2021/features/sampling_inventory/domain/usecases/sampling_inventory_usecase.dart';
import 'package:tete2021/features/sampling_inventory/presentation/blocs/sampling_inventory_cubit.dart';
import 'package:tete2021/features/sampling_use/data/datasources/sampling_local_data_source.dart';
import 'package:tete2021/features/sampling_use/data/datasources/sampling_use_remote_datasource.dart';
import 'package:tete2021/features/sampling_use/data/repositories/sampling_use_repository_impl.dart';
import 'package:tete2021/features/sampling_use/domain/repositories/sampling_use_repository.dart';
import 'package:tete2021/features/sampling_use/domain/usecases/sampling_use_usecase.dart';
import 'package:tete2021/features/sampling_use/presentation/blocs/sampling_use_cubit.dart';
import 'package:tete2021/features/sync_data/presentation/screens/sync_data_page.dart';
import '../../../../core/api/myDio.dart';
import '../../../../core/platform/camera_page.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../../../features/attendance/domain/usecases/usecase_check_inout.dart';
import '../../../../features/attendance/domain/usecases/usecase_check_sp.dart';
import '../../../../features/attendance/presentation/blocs/attendance_bloc.dart';
import '../../../../features/attendance/presentation/blocs/map_bloc.dart';
import '../../../../features/attendance/presentation/screens/attendance_page.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/home/data/datasources/dashboard_remote_datasource.dart';
import '../../../../features/home/data/repositories/dashboard_repository_impl.dart';
import '../../../../features/home/domain/entities/features.dart';
import '../../../../features/home/domain/repositories/dashboard_repository.dart';
import '../../../../features/home/domain/usecases/save_to_local_usecase.dart';
import '../../../../features/home/presentation/blocs/dashboard_bloc.dart';
import '../../../../features/home/presentation/blocs/tab_bloc.dart';
import '../../../../features/inventory/data/datasources/inventory_local_data_source.dart';
import '../../../../features/inventory/data/datasources/inventory_remote_datasource.dart';
import '../../../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../features/inventory/domain/usecases/inventory_in_usecase.dart';
import '../../../../features/inventory/presentation/blocs/inventory_cubit.dart';
import '../../../../features/inventory/presentation/screens/inventory_page.dart';
import '../../../../features/login/data/datasources/login_remote_datasource.dart';
import '../../../../features/login/data/repositories/login_repository_impl.dart';
import '../../../../features/login/domain/repositories/login_repository.dart';
import '../../../../features/login/domain/usecases/login_usecase.dart';
import '../../../../features/login/domain/usecases/logout_usecase.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../features/login/presentation/blocs/login_bloc.dart';
import '../../../../features/sampling_inventory/presentation/screens/sampling_inventory_page.dart';
import '../../../../features/sampling_use/presentation/screens/sampling%20_use_page.dart';
import '../../../../features/sync_data/data/datasources/sync_local_data_source.dart';
import '../../../../features/sync_data/data/repositories/sync_repository_impl.dart';
import '../../../../features/sync_data/domain/repositories/sync_repository.dart';
import '../../../../features/sync_data/domain/usecases/sync_usecase.dart';
import '../../../../features/sync_data/presentation/blocs/sync_data_bloc.dart';


import '../application.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => const FlutterSecureStorage()),
    Bind.lazySingleton((i) => AuthenticationBloc(
        storage: i.get<FlutterSecureStorage>(),
        local: i.get<DashBoardLocalDataSource>())),
    Bind.lazySingleton((i) => LoginBloc(
          local: i.get<DashBoardLocalDataSource>(),
          login: i.get<LoginUseCase>(),
          logout: i.get<LogoutUseCase>(),
          authenticationBloc: i.get<AuthenticationBloc>(),
        )),
    Bind.lazySingleton(
        (i) => LoginUseCase(repository: i.get<LoginRepository>())),
    Bind.lazySingleton(
        (i) => LogoutUseCase(repository: i.get<LoginRepository>())),
    Bind.lazySingleton((i) => LoginRepositoryImpl(
        networkInfo: i.get<NetworkInfo>(),
        loginRemoteDataSource: i.get<LoginRemoteDataSource>())),
    Bind.lazySingleton((i) => LoginRemoteDataSourceImpl(cDio: i.get<CDio>())),
    Bind.lazySingleton((i) => InternetConnectionChecker()),
    // home
    Bind.factory((i) => TabBloc()),
    Bind.lazySingleton((i) => DashboardBloc(
        saveDataToLocal: i.get<SaveDataToLocalUseCase>(),
        authenticationBloc: i.get<AuthenticationBloc>(),
        local: i.get<DashBoardLocalDataSource>(),
        checkStatus: i.get<UseCaseCheckSP>())),
    Bind.lazySingleton((i) => SaveDataToLocalUseCase(repository: i.get<DashboardRepository>(), networkInfo: i.get<NetworkInfo>())),

    Bind.lazySingleton((i) => DashboardRepositoryImpl(
      attendanceRemoteDataSource: i.get<AttendanceRemoteDataSource>(),
        local: i.get<DashBoardLocalDataSource>(),
        remote: i.get<DashBoardRemoteDataSource>(),
        networkInfo: i.get<NetworkInfo>())),
    Bind.lazySingleton((i) => DashBoardLocalDataSourceImpl(
        secureStorage: i.get<FlutterSecureStorage>())),
    Bind.lazySingleton(
        (i) => DashBoardRemoteDataSourceImpl(cDio: i.get<CDio>())),
    // attendance
    Bind.factory((i) => MapBloc()),
    Bind.factory((i) => CheckAttendanceBloc(
      syncLocal: i.get<SyncLocalDataSource>(),
        useCaseCheckSP: i.get<UseCaseCheckSP>(),
        dashBoardLocalDataSource: i.get<DashBoardLocalDataSource>())),
    Bind.factory((i) =>
        AttendanceBloc(useCaseCheckInOrOut: i.get<UseCaseCheckInOrOut>())),
    Bind.lazySingleton(
        (i) => UseCaseCheckSP(repository: i.get<AttendanceRepository>())),
    Bind.lazySingleton(
        (i) => UseCaseCheckInOrOut(repository: i.get<AttendanceRepository>())),
    Bind.lazySingleton((i) => AttendanceRepositoryImpl(
        remote: i.get<AttendanceRemoteDataSource>(),
        dashBoardLocalDataSource: i.get<DashBoardLocalDataSource>())),
    Bind.lazySingleton(
        (i) => AttendanceRemoteDataSourceImpl(cDio: i.get<CDio>())),
    // inventory
    Bind.factory((i) => InventoryCubit(inventoryIn: i.get<InventoryInUseCase>(), inventoryOut: i.get<InventoryOutUseCase>())),
    Bind.lazySingleton((i) => InventoryInUseCase(repository: i.get<InventoryRepository>())),
    Bind.lazySingleton((i) => InventoryOutUseCase(repository: i.get<InventoryRepository>())),
    Bind.lazySingleton((i) => InventoryRepositoryImpl(remote: i.get<InventoryRemoteDataSource>(), local: i.get<InventoryLocalDataSource>(), dashBoardLocal: i.get<DashBoardLocalDataSource>(), networkInfo: i.get<NetworkInfo>())),
    Bind.lazySingleton((i) => InventoryRemoteDataSourceImpl(cDio: i.get<CDio>())),
    Bind.lazySingleton((i) => InventoryLocalDataSourceImpl()),
    // samplingUse
    Bind.factory((i) => SamplingUseCubit(samplingUse: i.get<SamplingUseUseCase>())),
    Bind.lazySingleton((i) => SamplingUseUseCase(repository: i.get<SamplingUseRepository>(), samplingInventoryRepository: i.get<SamplingInventoryRepository>())),
    Bind.lazySingleton((i) => SamplingUseRepositoryImpl(remote: i.get<SamplingUseRemoteDataSource>(), local: i.get<SamplingUseLocalDataSource>(), dashBoardLocal: i.get<DashBoardLocalDataSource>(), networkInfo: i.get<NetworkInfo>())),
    Bind.lazySingleton((i) => SamplingUseRemoteDataSourceImpl(cDio: i.get<CDio>())),
    Bind.lazySingleton((i) => SamplingUseLocalDataSourceImpl()),
    // samplingUse
    Bind.factory((i) => SamplingInventoryCubit(samplingInventory: i.get<SamplingInventoryUseCase>())),
    Bind.lazySingleton((i) => SamplingInventoryUseCase(repository: i.get<SamplingInventoryRepository>())),
    Bind.lazySingleton((i) => SamplingInventoryRepositoryImpl(remote: i.get<SamplingInventoryRemoteDataSource>(), local: i.get<SamplingInventoryLocalDataSource>(), dashBoardLocal: i.get<DashBoardLocalDataSource>(), networkInfo: i.get<NetworkInfo>())),
    Bind.lazySingleton((i) => SamplingInventoryRemoteDataSourceImpl(cDio: i.get<CDio>())),
    Bind.lazySingleton((i) => SamplingInventoryLocalDataSourceImpl()),
    // sale
    Bind.factory((i) => SaleCubit(sale: i.get<SaleUseCase>())),
    Bind.lazySingleton((i) => SaleUseCase(repository: i.get<SaleRepository>())),
    Bind.lazySingleton((i) => SaleRepositoryImpl(remote: i.get<SaleRemoteDataSource>(), local: i.get<SaleLocalDataSource>(), dashBoardLocal: i.get<DashBoardLocalDataSource>(), networkInfo: i.get<NetworkInfo>())),
    Bind.lazySingleton((i) => SaleRemoteDataSourceImpl(cDio: i.get<CDio>())),
    Bind.lazySingleton((i) => SaleLocalDataSourceImpl()),
    // sync
    Bind.factory((i) => SyncDataBloc(synchronous: i.get<SyncUseCase>())),
    Bind.lazySingleton((i) => SyncUseCase(repository: i.get<SyncRepository>())),
    Bind.lazySingleton((i) => SyncRepositoryImpl(dashBoardLocalDataSource: i.get<DashBoardLocalDataSource>(), local: i.get<SyncLocalDataSource>(), inventoryRepository: i.get<InventoryRepository>(),networkInfo: i.get<NetworkInfo>(), saleRepository: i.get<SaleRepository>(), samplingUseRepository: i.get<SamplingUseRepository>(), samplingInventoryRepository: i.get<SamplingInventoryRepository>())),
    Bind.lazySingleton((i) => SyncLocalDataSourceImpl(sale: i.get<SaleLocalDataSource>(), inventory: i.get<InventoryLocalDataSource>(), samplingInventory: i.get<SamplingInventoryLocalDataSource>(), samplingUse: i.get<SamplingUseLocalDataSource>())),
    // notify
    Bind.factory((i) => NotifyCubit(notify: i.get<NotifyUseCase>())),
    Bind.lazySingleton((i) => NotifyUseCase(repository: i.get<NotifyRepository>())),
    Bind.lazySingleton((i) => NotifyRepositoryImpl(networkInfo: i.get<NetworkInfo>(), remote: i.get<NotifyRemoteDataSource>())),
    Bind.lazySingleton((i) => NotifyRemoteDataSourceImpl(cDio: i.get<CDio>())),


  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const MyApplication()),
    ChildRoute('/attendance', child: (_, args) =>  const AttendancePage()),
    ChildRoute('/image', child: (_, args) => const CameraPage()),
    ChildRoute('/inventory_in', child: (_, args) => InventoryPage(type: InventoryType.start,)),
    ChildRoute('/inventory_out', child: (_, args) => InventoryPage(type: InventoryType.end,)),
    ChildRoute('/sale', child: (_, args) => const SalePage()),
    ChildRoute('/sampling_use', child: (_, args) => const SamplingUsePage(type: SamplingType.use)),
    ChildRoute('/sampling_inventory', child: (_, args) => const SamplingInventoryPage(type: SamplingType.inventory)),
    ChildRoute('/sync', child: (_, args) => const SyncDataPage()),

  ];
}
