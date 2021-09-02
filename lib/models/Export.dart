import 'dart:convert';
import 'package:inventory_management_software/models/Customer.dart';

class Export{
  final int id;
  final DateTime? date;
  final String? dateString;
  final int? inventoryId;
  final int? customerId;
  final int? employeeId;
  final String? customerName;
  final String? productsCount;
  //final Customer? customer;

  Export({
    required this.id,
    this.date,
    this.dateString,
    this.inventoryId,
    this.customerId,
    this.employeeId,
    this.customerName,
    this.productsCount,
    //this.customer
  });

  factory Export.fromJson(Map<String, dynamic> json){
    return Export(
      id : int.parse(json["id"].toString()),
      date : DateTime.parse(json["date"].toString()),
      dateString : json['dateString'],
      inventoryId : int.parse(json["inventoryId"].toString()),
      customerId : int.parse(json["customerId"].toString()),
      employeeId : int.parse(json["employeeId"].toString()),
      customerName : json["customerName"] as String?,
      productsCount : json["productsCount"],
      //customer : Customer.fromJson(json["customer"])
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "date" : date,
    "dateString" : dateString,
    "inventoryId" : inventoryId,
    "customerId" : customerId,
    "employeeId" : employeeId,
    "customerName" : customerName,
    "productsCount" : productsCount,
    //"customer" : customer
  };

}