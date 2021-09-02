import 'dart:convert';

class ProductSearchObject{
  int? EmployeeId;
  int? DepartmentId;

  ProductSearchObject({
    this.EmployeeId,
    this.DepartmentId
});

  factory ProductSearchObject.fromJson(Map<String, dynamic> json){
    return ProductSearchObject(
        EmployeeId : int.parse(json["EmployeeId"].toString()),
        DepartmentId : int.parse(json["DepartmentId"].toString())
    );
  }

  Map<String, dynamic> toJson() => {
    "EmployeeId" : EmployeeId,
    "DepartmentId" : DepartmentId
  };

}