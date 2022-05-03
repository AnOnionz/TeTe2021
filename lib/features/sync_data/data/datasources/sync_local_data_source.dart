import 'dart:async';
import 'package:hive/hive.dart';
import '../../../../features/sales/data/datasources/sale_local_data_source.dart';
import '../../../../features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import '../../../../features/sampling_use/data/datasources/sampling_local_data_source.dart';
import '../../../../features/inventory/data/datasources/inventory_local_data_source.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';

 abstract class SyncLocalDataSource{
   SyncEntity getSync();
   int get nonSync;
   bool get hasDataNonSync;

 }

 class SyncLocalDataSourceImpl implements SyncLocalDataSource{
   final InventoryLocalDataSource inventory;
   final SamplingInventoryLocalDataSource samplingInventory;
   final SamplingUseLocalDataSource samplingUse;
   final SaleLocalDataSource sale;

  SyncLocalDataSourceImpl({required this.inventory, required this.samplingInventory, required this.samplingUse, required this.sale});

   @override
   SyncEntity getSync() {
    final isInventoryIn = inventory.getSyncIn();
    final isInventoryOut = inventory.getSyncOut();
    final isSamplingInventory = samplingInventory.getSync();
    final isSamplingUse = samplingUse.getSync();
    final isSale = sale.getSync();

    return SyncEntity(isInventoryIn: isInventoryIn, isInventoryOut: isInventoryOut, isSamplingInventory: isSamplingInventory, isSamplingUse: isSamplingUse, isSale: isSale);
    }

   @override
   bool get hasDataNonSync  {
     final sync = getSync();
     return sync.isInventoryIn || sync.isInventoryOut || sync.isSamplingInventory || sync.isSamplingUse || sync.isSale;
   }

  @override
  int get nonSync {
    final sync = getSync();
    return (sync.isInventoryIn ? 1 : 0) +
          (sync.isInventoryOut ? 1 : 0) +
          (sync.isSamplingUse ? 1 : 0 )+
          (sync.isSamplingInventory ? 1 : 0) +
          (sync.isSale ? 1 : 0 );
  }
 }