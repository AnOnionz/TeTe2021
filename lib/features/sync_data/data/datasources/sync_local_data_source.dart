import 'dart:async';
import 'package:hive/hive.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import 'package:tete2021/features/sampling_use/data/datasources/sampling_local_data_source.dart';
import '../../../../features/inventory/data/datasources/inventory_local_data_source.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';

 abstract class SyncLocalDataSource{
   SyncEntity getSync();
   bool get hasDataNonSync;

 }

 class SyncLocalDataSourceImpl implements SyncLocalDataSource{
   final InventoryLocalDataSource inventory;
   final SamplingInventoryLocalDataSource samplingInventory;
   final SamplingUseLocalDataSource samplingUse;

  SyncLocalDataSourceImpl({required this.inventory, required this.samplingInventory, required this.samplingUse});

   @override
   SyncEntity getSync() {
    final isInventoryIn = inventory.getSyncIn();
    final isInventoryOut = inventory.getSyncOut();
    final isSamplingInventory = samplingInventory.getSync();
    final isSamplingUse = samplingUse.getSync();

    return SyncEntity(isInventoryIn: isInventoryIn, isInventoryOut: isInventoryOut, isSamplingInventory: isSamplingInventory, isSamplingUse: isSamplingUse);
    }

   @override
   bool get hasDataNonSync  {
     final sync = getSync();
     return sync.isInventoryIn || sync.isInventoryOut || sync.isSamplingInventory || sync.isSamplingUse ;
   }

 }