import 'dart:convert';
import 'package:inventory_management_software/models/Supplier.dart';

class Import{
  final int id;
  final DateTime? date;
  final String? dateString;
  final int? inventoryId;
  final int? supplierId;
  final int? employeeId;
  final String? supplierName;
  final String? productsCount;
  //final Supplier? supplier;

  Import({
    required this.id,
    this.date,
    this.dateString,
    this.inventoryId,
    this.supplierId,
    this.employeeId,
    this.supplierName,
    this.productsCount,
    //this.supplier
  });

  factory Import.fromJson(Map<String, dynamic> json){
    return Import(
        id : int.parse(json["id"].toString()),
        date : DateTime.parse(json["date"].toString()),
        dateString : json['dateString'],
        inventoryId : int.parse(json["inventoryId"].toString()),
        supplierId : int.parse(json["supplierId"].toString()),
        employeeId : int.parse(json["employeeId"].toString()),
        supplierName : json["supplierName"] as String?,
        productsCount : json["productsCount"],
        //supplier : Supplier.fromJson(json["supplier"])
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "date" : date,
    "dateString" : dateString,
    "inventoryId" : inventoryId,
    "supplierId" : supplierId,
    "employeeId" : employeeId,
    "supplierName" : supplierName,
    "productsCount" : productsCount,
    //"supplier" : supplier
  };

}