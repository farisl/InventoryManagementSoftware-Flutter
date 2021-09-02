import 'dart:convert';

class ImportDetail{
  final int id;
  final int? importId;
  final int? productId;
  final int? quantity;
  final double? discount;
  final double? price;
  final String? productName;


  ImportDetail({
    required this.id,
    this.importId,
    this.productId,
    this.quantity,
    this.discount,
    this.price,
    this.productName
  });

  factory ImportDetail.fromJson(Map<String, dynamic> json){
    return ImportDetail(
        id : int.parse(json["id"].toString()),
        importId : int.parse(json["importId"].toString()),
        productId : int.parse(json["productId"].toString()),
        quantity : int.parse(json["quantity"].toString()),
        discount : double.parse(json["discount"].toString()),
        price : double.parse(json["price"].toString()),
        productName : json["productName"].toString()
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "importId" : importId,
    "productId" : productId,
    "quantity" : quantity,
    "discount" : discount,
    "price" : price,
    "productName" : productName
  };

}