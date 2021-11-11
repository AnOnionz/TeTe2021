// class KpiEntity {
//   final int dayOf;
//   final int sell;
//
//   KpiEntity({required this.dayOf,required this.sell});
//
//   factory KpiEntity.fromJson(Map<String, dynamic> json){
//         return KpiEntity(
//           dayOf: json['days'],
//           sell: json['kpi'],
//         );
//   }
//   Map<String, dynamic> toJson(){
//     return {
//       'days': dayOf,
//       'kpi': sell,
//     };
//   }
//
// }