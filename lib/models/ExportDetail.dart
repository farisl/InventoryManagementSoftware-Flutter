import 'dart:convert';

class ExportDetail{
  final int id;
  final int? exportId;
  final int? productId;
  final int? quantity;
  final double? discount;
  final double? price;
  final String? productName;


  ExportDetail({
    required this.id,
    this.exportId,
    this.productId,
    this.quantity,
    this.discount,
    this.price,
    this.productName
  });

  factory ExportDetail.fromJson(Map<String, dynamic> json){
    return ExportDetail(
        id : int.parse(json["id"].toString()),
        exportId : int.parse(json["exportId"].toString()),
        productId : int.parse(json["productId"].toString()),
        quantity : int.parse(json["quantity"].toString()),
        discount : double.parse(json["discount"].toString()),
        price : double.parse(json["price"].toString()),
        productName : json["productName"].toString()
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "exportId" : exportId,
    "productId" : productId,
    "quantity" : quantity,
    "discount" : discount,
    "price" : price,
    "productName" : productName
  };

}