// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/common/text_styles.dart';
// import '../../../../core/entities/gift_entity.dart';
// import '../../../../core/entities/product_entity.dart';
// import '../../../../di.dart';
// import '../../../dashboard/data/datasources/dashboard_local_datasouce.dart';
// import '../../../highlight/domain/entities/highlight_cache_entity.dart';
// import '../../../inventory/domain/entities/posm_entity.dart';
// import '../../../receive_gift/domain/entities/customer_gift_entity.dart';
//
// class ReportContent extends StatelessWidget {
//   final Map<String, dynamic> report;
//
//   const ReportContent({Key key, this.report}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final receive = (report['receive'] as List<CustomerGiftEntity>).length;
//     final inventory = (report['inventory'] as List<InventoryEntity>).length;
//     print(report['inventory']);
//     final price = (report['price'] as List).length;
//     final rival = (report['rival'] as List).length;
//     final highlight = (report['highlight'] as HighlightCacheEntity) != null;
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           receive > 0 || inventory > 0 || price > 0 || rival > 0 || highlight
//               ? Text(
//                   'Dữ liệu hiện có',
//                   style: Subtitle1black,
//                 )
//               : Text(
//                   'Không có dữ liệu',
//                   style: Subtitle1black,
//                 ),
//           receive > 0
//               ? Column(children: [
//                   ...[
//                     Text(
//                       'Quay Quà',
//                       style: TextStyle(fontSize: 15),
//                     ),
//                     Text('${sl<DashBoardLocalDataSource>().fetchSetGiftCurrent().gifts.map((e) => '${e.name} : ${e.amountCurrent}').toList()}'),
//                   ],
//                   ...(report['receive'] as List<CustomerGiftEntity>)
//                       .map((e) => Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Container(
//                               width: double.maxFinite,
//                               padding:
//                                   const EdgeInsets.only(top: 5.0, bottom: 5.0),
//                               decoration: BoxDecoration(
//                                 color: Colors.amberAccent,
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text('Thời gian: ${DateFormat('hh:mm a dd-MM-yyyy')
//                                   .format(DateTime.fromMillisecondsSinceEpoch(e.customer.deviceCreatedAt*1000))}'),
//                                   Text('Khách hàng : ${e.customer.name}'),
//                                   Text('SĐT : ${e.customer.phoneNumber}'),
//                                   Text(
//                                       'Giới tính : ${e.customer.gender == '1' ? 'Nam' : 'Nữ'}'),
//                                   Text('Bia mua : ${e.products.map((e) {
//                                     final a = ProductEntity.fromJson(
//                                         {'id': e['sku_id'], 'buy': e['qty']});
//                                     return '${a.productName} : ${a.buyQty}';
//                                   }).toList()}'),
//                                   Text('Quà: ${e.gifts.map((e) {
//                                     final a = GiftEntity.fromJson({
//                                       'id': e['sku_id'],
//                                       'receive': e['qty']
//                                     });
//                                     return '${a.name} : ${a.amountReceive}';
//                                   }).toList()}'),
//                                   e.voucherQty > 0
//                                       ? Text(
//                                           'Mã giảm giá : ${e.voucherPhone}, Số lượng: ${e.voucherQty}')
//                                       : Container(),
//                                   e.customerImage.length > 0
//                                       ? Container(
//                                     height: 50,
//                                         width: 50,
//                                         child: Image.file(File(e.customerImage.first),
//                                             fit: BoxFit.cover),
//                                       )
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                           ))
//                       .toList()
//                 ])
//               : Container(),
//           inventory > 0
//               ? Column(children: [
//                   ...[Text('Bia Tồn', style: TextStyle(fontSize: 15))],
//                   ...(report['inventory'] as List<InventoryEntity>)
//                       .map((e) => Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Container(
//                                   padding: const EdgeInsets.only(
//                                       top: 5.0, bottom: 5.0),
//                                   decoration: BoxDecoration(
//                                     color: Colors.cyan,
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   child: Column(children: [
//                                     ...[Text('Tồn đầu')],
//                                     ...e.inInventory.map((e) {
//                                       final a = ProductEntity.fromJson({
//                                         'id': e['sku_id'],
//                                       });
//                                       return e['qty'] > 0
//                                           ? Text(
//                                               '${a.productName} : ${e['qty']}')
//                                           : Container();
//                                     }).toList(),
//                                   ]),
//                                 ),
//                               ),
//                               !e.outInventory
//                                       .every((element) => element['qty'] == 0)
//                                   ? Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Container(
//                                         padding: const EdgeInsets.only(
//                                             top: 5.0, bottom: 5.0),
//                                         decoration: BoxDecoration(
//                                           color: Colors.teal,
//                                           borderRadius:
//                                               BorderRadius.circular(12.0),
//                                         ),
//                                         child: Column(children: [
//                                           ...[Text('Tồn cuối')],
//                                           ...e.outInventory.map((e) {
//                                             final a = ProductEntity.fromJson({
//                                               'id': e['sku_id'],
//                                             });
//                                             return e['qty'] > 0
//                                                 ? Text(
//                                                     '${a.productName} : ${e['qty']}')
//                                                 : Container();
//                                           }).toList(),
//                                         ]),
//                                       ),
//                                     )
//                                   : Container(),
//                             ],
//                           ))
//                       .toList()
//                 ])
//               : Container(),
//           highlight
//               ? Column(
//                   children: [
//                     ...[
//                       Text('Thông tin cuối ngày',
//                           style: TextStyle(fontSize: 15))
//                     ],
//                     ...[
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Container(
//                           padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//                           width: double.maxFinite,
//                           decoration: BoxDecoration(
//                             color: Colors.orangeAccent,
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           child: Column(
//                             children: [
//                               (report['highlight'] as HighlightCacheEntity)
//                             ].map((e) {
//                               final a =
//                                   report['highlight'] as HighlightCacheEntity;
//                               return Column(
//                                 children: [
//                                   Text('Vấn đề gặp phải: ${a.workContent}'),
//                                   Row(
//                                     children: a.workImages
//                                         .map(
//                                           (e) => Container(
//                                             height: 50,
//                                             width: 50,
//                                             margin:
//                                             const EdgeInsets.only(left: 10),
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5)),
//                                               child: Image.file(File(e),
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                   Text('Thông tin đối thủ: ${a.rivalContent}'),
//                                   Row(
//                                     children: a.rivalImages
//                                         .map((e) => Container(
//                                       height: 50,
//                                       width: 50,
//                                       margin:
//                                       const EdgeInsets.only(left: 10),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5)),
//                                         child: Image.file(File(e),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),)
//                                         .toList(),
//                                   ),
//                                   Text('Hiện trạng kho: ${a.posmContent}'),
//                                   Row(
//                                     children: a.posmImages
//                                         .map((e) => Container(
//                                       height: 50,
//                                       width: 50,
//                                       margin:
//                                       const EdgeInsets.only(left: 10),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5)),
//                                         child: Image.file(File(e),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),)
//                                         .toList(),
//                                   ),
//                                   Text('Hiện trạng quà tặng: ${a.giftContent}'),
//                                   Row(
//                                     children: a.giftImages
//                                         .map((e) => Container(
//                                       height: 50,
//                                       width: 50,
//                                       margin:
//                                       const EdgeInsets.only(left: 10),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5)),
//                                         child: Image.file(File(e),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),)
//                                         .toList(),
//                                   ),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ]
//                   ],
//                 )
//               : Container(),
//           price > 0
//               ? Column(children: [
//                   ...[Text('Giá bia bán', style: TextStyle(fontSize: 15))],
//                   ...([report['price'] as List])
//                       .map(
//                         (e) => Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Container(
//                                 padding: const EdgeInsets.only(
//                                     top: 5.0, bottom: 5.0),
//                                 width: double.maxFinite,
//                                 decoration: BoxDecoration(
//                                   color: Colors.greenAccent,
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 child: Column(
//                                     children: e.map((e) {
//                                   final a = ProductEntity.fromJson(
//                                       {'id': e['sku_id']});
//                                   return Text(
//                                       '${a.productName} : ${e['price']} VNĐ');
//                                 }).toList()))),
//                       )
//                       .toList(),
//                 ])
//               : Container(),
//           rival > 0
//               ? Column(children: [
//                   ...[Text('Giá bia đối thủ', style: TextStyle(fontSize: 15))],
//                   ...([report['rival'] as List])
//                       .map(
//                         (e) => Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Container(
//                                 padding: const EdgeInsets.only(
//                                     top: 5.0, bottom: 5.0),
//                                 width: double.maxFinite,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white70,
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 child: Column(
//                                     children: e.map((e) {
//                                   final a = sl<DashBoardLocalDataSource>()
//                                       .fetchAvailableRivalProduct()
//                                       .firstWhere((element) =>
//                                           element.id == e['sku_id']);
//                                   return Text('${a.name} : ${e['price']} VNĐ');
//                                 }).toList()))),
//                       )
//                       .toList(),
//                 ])
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
