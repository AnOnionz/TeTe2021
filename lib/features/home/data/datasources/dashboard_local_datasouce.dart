import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/date_time.dart';
import '../../../../features/home/domain/entities/today_data_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

abstract class DashBoardLocalDataSource {
  DataTodayEntity get dataToday;
  List<ProductEntity> fetchProduct();
  Future<void> deleteDataToday();
  Future<void> cacheDataToday({bool? checkIn, DataLocalEntity? inventoryIn, DataLocalEntity? inventoryOut, DataLocalEntity? samplingUse, DataLocalEntity? sale, DataLocalEntity? samplingInventory});
  Future<void> cacheProducts({required List<ProductEntity> products});
  // Future<void> cacheGiftsStrongbow({required List<GiftEntity> gifts});
}

class DashBoardLocalDataSourceImpl implements DashBoardLocalDataSource {
  // ignore: close_sinks
  // final StreamController<KpiEntity> _streamController = StreamController.broadcast();
  // String todayStr = DateFormat.yMd().format(MyDateTime.day);
  final FlutterSecureStorage secureStorage;
  DashBoardLocalDataSourceImpl({required this.secureStorage});

  @override
  DataTodayEntity get dataToday {
    Box<DataTodayEntity> box = Hive.box(
        AuthenticationBloc.loginEntity!.id.toString() +
            MyDateTime.today +
            dataDay);
    DataTodayEntity defaultData =
        DataTodayEntity(isCheckIn: false, inventoryIn: null, inventoryOut: null, samplingUse: null, sale: null, samplingInventory: null,);
    final result = box.get(MyDateTime.today, defaultValue: defaultData);
    if (result == defaultData) {
      box.put(MyDateTime.today, result!);
    }
    return result!;
  }

  @override
  Future<void> cacheDataToday(
      {bool? checkIn, DataLocalEntity? inventoryIn, DataLocalEntity? inventoryOut, DataLocalEntity? samplingUse, DataLocalEntity? samplingInventory, DataLocalEntity? sale}) async {
    final data = dataToday;
    data.isCheckIn = checkIn ?? data.isCheckIn;
    data.inventoryIn = inventoryIn ?? data.inventoryIn;
    data.inventoryOut = inventoryOut ?? data.inventoryOut;
    data.samplingUse = samplingUse ?? data.samplingUse;
    data.samplingInventory = samplingInventory ?? data.samplingInventory;
    data.sale = sale ?? data.sale;
    await data.save();
    print('DATA TODAY UPDATED');
    print(data);
  }

  @override
  Future<void> deleteDataToday() async {
    final data = dataToday;
    await data.delete();
  }

  @override
  Future<void> cacheProducts({required List<ProductEntity> products}) async {
    Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.loginEntity!.id.toString() + productBox);
    await box.clear();
    for(ProductEntity product in products){
      await box.add(product);
    }
  }

  @override
  List<ProductEntity> fetchProduct() {
    Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.loginEntity!.id.toString() + productBox);
    return box.values.map((e) => e.copy()).toList();
  }

  // @override
  // Stream<KpiEntity> get kpiStream => _streamController.stream;
  //
  // @override
  // bool get isLoadInitData {
  //   Box<ProductEntity> productBox = Hive.box<ProductEntity>(AuthenticationBloc.outletEntity!.id.toString() + PRODUCT_BOX);
  //   Box<GiftEntity> giftBox = Hive.box<GiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + GIFT_BOX);
  //   return giftBox.isEmpty ||
  //       productBox.isEmpty ;
  // }
  //
  // @override
  // List<GiftEntity> fetchGift() {
  //   Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + GIFT_BOX);
  //   return box.values.toList();
  // }
  // // @override
  // // List<GiftEntity> fetchGiftStrongbow() {
  // //   Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + GIFT_STRONGBOW_BOX);
  // //   return box.values.toList();
  // // }
  //
  // @override
  // List<ProductEntity> fetchProduct() {
  //   Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.outletEntity!.id.toString() + PRODUCT_BOX);
  //   return box.values.toList();
  // }

  // @override
  // List<RivalProductEntity> fetchRivalProduct() {
  //   Box<RivalProductEntity> box =
  //       Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
  //   return box.values.toList();
  // }
  // @override
  // List<RivalProductEntity> fetchAvailableRivalProduct() {
  //   Box<RivalProductEntity> box =
  //   Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
  //   box.values.toList().forEach((element) {
  //     element.priceController = TextEditingController();
  //     element.save();
  //   });
  //   return box.values.toList().where((element) => element.isAvailable == true).toList();
  // }
  //
  // @override
  // List<SetGiftEntity> fetchSetGift() {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
  //   return box.values.toList();
  // }
  // @override
  // List<SetGiftEntity> fetchSBSetGift() {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
  //   return box.values.toList();
  // }
  //
  // @override
  // SetGiftEntity? fetchSetGiftCurrent() {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
  //   SetGiftEntity setCurrent = box.get(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT, defaultValue: SetGiftEntity(index: 0, gifts: []));
  //   final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000)).toString();
  //   if (setCurrent != SetGiftEntity(index: 0, gifts: [])) {
  //     setCurrent = SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts);
  //     if(todayStr == lastDay){
  //       setCurrent =  SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts.map((e) => e is Voucher ? e.setOver(): e).toList());
  //     }
  //   }else{
  //     setCurrent = fetchNewSetGift(1)!;
  //   }
  //   return setCurrent;
  // }
  //
  // @override
  // SetGiftEntity? fetchSetGiftSBCurrent() {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
  //   SetGiftEntity? setCurrent = box.get(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW, defaultValue: SetGiftEntity(index: 0, gifts: []));
  //   if (setCurrent != SetGiftEntity(index: 0, gifts: [])) {
  //     setCurrent = SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts);
  //   }else{
  //     setCurrent = AuthenticationBloc.outlet.province =='HN_HCM' ? fetchNewSBSetGift(1) : null;
  //   }
  //   return setCurrent;
  //
  // }
  //
  // @override
  // SetGiftEntity? fetchNewSetGift(int index) {
  //   //Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
  //   final all = fetchSetGift();
  //   SetGiftEntity set = all.firstWhere((element) => element.index == index, orElse: ()=> SetGiftEntity(index: 0, gifts: []));
  //   final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000)).toString();
  //   print("new set:$set");
  //   if(set != SetGiftEntity(index: 0, gifts: [])) {
  //     set = SetGiftEntity(index: set.index, gifts: set.gifts);
  //     cacheChangedSet(true);
  //     if(todayStr == lastDay){
  //       set =  SetGiftEntity(index: set.index, gifts: set.gifts.map((e) => e is Voucher ? e.setOver(): e).toList());
  //     }
  //   }
  //   return set;
  // }
  //
  // @override
  // SetGiftEntity? fetchNewSBSetGift(int index) {
  //   //Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
  //   final all = fetchSBSetGift();
  //   SetGiftEntity set = all.firstWhere((element) => element.index == index, orElse: ()=> SetGiftEntity(index: 0, gifts: []));
  //   print("new set:$set");
  //   if(set != SetGiftEntity(index: 0, gifts: [])) {
  //     set = SetGiftEntity(index: set.index, gifts: set.gifts);
  //     cacheChangedSet(true);
  //   }
  //   return set;
  // }

  // @override
  // Future<void> cacheGifts({required List<GiftEntity> gifts}) async {
  //   Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + GIFT_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   await box.addAll(gifts);
  // }

  // @override
  // Future<void> cacheGiftsStrongbow({required List<GiftEntity> gifts}) async {
  //   Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + GIFT_STRONGBOW_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   await box.addAll(gifts);
  // }

  // @override
  // Future<void> cacheProducts({required List<ProductEntity> products}) async {
  //   Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.outletEntity!.id.toString() + PRODUCT_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   await box.addAll(products);
  // }

  // @override
  // Future<void> cacheRivalProducts({required List<RivalProductEntity> products}) async {
  //   Box<RivalProductEntity> box =
  //       Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   await box.addAll(products);
  // }
  //
  // @override
  // Future<void> cacheSetGiftCurrent({required SetGiftEntity setGiftEntity}) async {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
  //   if (box.containsKey(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT)) {
  //     await box.delete(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT);
  //   }
  //   await box.put(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT, setGiftEntity);
  // }
  //
  // @override
  // Future<void> cacheSetGifts({required List<SetGiftEntity> setGifts}) async {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   setGifts.sort((a, b) {
  //     return a.index.compareTo(b.index);
  //   });
  //   await box.addAll(setGifts);
  //   cacheChangedSet(false);
  // }
  // @override
  // Future<void> cacheSBSetGifts({required List<SetGiftEntity> setGifts}) async {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
  //   if (box.isNotEmpty) {
  //     await box.clear();
  //   }
  //   setGifts.sort((a, b) {
  //     return a.index.compareTo(b.index);
  //   });
  //   await box.addAll(setGifts);
  //   cacheChangedSet(false);
  // }
  //
  // @override
  // Future<void> cacheSetGiftSBCurrent({required SetGiftEntity setGiftEntity}) async {
  //   Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
  //   if (box.containsKey(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW)) {
  //     await box.delete(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW);
  //   }
  //   await box.put(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW, setGiftEntity);
  // }

  // @override
  // int get indexLast {
  //   Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outletEntity!.id.toString() + SET_GIFT_BOX);
  //   return setGiftBox.values.toList().last.index;
  // }
  //
  // @override
  // bool get isSetOver {
  //   SetGiftEntity? setCurrent = fetchSetGiftCurrent();
  //   if(fetchSetGift().isEmpty || setCurrent == null) return true;
  //   int sum = setCurrent.gifts.fold(
  //       0, (previousValue, element) => previousValue + element.amountCurrent!);
  //   return setCurrent.index >= indexLast && sum == 0 ;
  //   }
  // @override
  // bool get isSetSBOver {
  //   SetGiftEntity? setCurrent = fetchSetGiftSBCurrent();
  //   if(fetchSBSetGift().isEmpty || setCurrent == null) return true;
  //   int sum = setCurrent.gifts.fold(
  //       0, (previousValue, element) => previousValue + element.amountCurrent!);
  //   return setCurrent.index >= sbIndexLast && sum == 0;
  // }
  //
  // @override
  // int get sbIndexLast {
  //   Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
  //   return setGiftBox.values.toList().last.index;
  // }
  //
  // @override
  // bool get isChangeSet{
  //   final isChange = sharedPrefer.getBool(AuthenticationBloc.outlet.id.toString() + IS_CHANGE_SET);
  //   if(isChange == false){
  //     return false;
  //   }
  //   return isChange;
  // }

  // @override
  // void cacheChangedSet(bool value) {
  //   sharedPrefer.setBool(AuthenticationBloc.outlet.id.toString() + IS_CHANGE_SET,value);
  // }

  // @override
  // Future<void> cachePosm({required List<String> posm}) async {
  //  await cacheDataToday(listPosm: posm);
  // }

}
