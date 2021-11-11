 import 'package:equatable/equatable.dart';
 import 'package:hive/hive.dart';


 class SyncEntity extends Equatable {
   final bool isInventoryIn;
   final bool isInventoryOut;
   final bool isSamplingInventory;
   final bool isSamplingUse;

   const SyncEntity(
       {required this.isInventoryIn, required this.isInventoryOut, required this.isSamplingInventory, required this.isSamplingUse});

   SyncEntity copyWith({bool? isInventoryIn,
   bool? isInventoryOut,
   bool? isSamplingInventory,
   bool? isSamplingUse,}){
      return SyncEntity(
          isInventoryIn: isInventoryIn ?? this.isInventoryIn,
          isInventoryOut: isInventoryOut ?? this.isInventoryOut,
          isSamplingInventory: isSamplingInventory ?? this.isSamplingInventory,
          isSamplingUse: isSamplingUse ?? this.isSamplingUse,
      ) ;
   }


   @override
  String toString() {
    return 'SyncEntity{isInventoryIn: $isInventoryIn, isInventoryOut: $isInventoryOut, isSamplingInventory: $isSamplingInventory, isSamplingUse: $isSamplingUse}';
  }

   @override
   List<Object> get props =>
       [isInventoryIn, isInventoryOut, isSamplingInventory, isSamplingUse];

 }
