import 'dart:convert';

class Department{
  int? id;
  String? name;

  Department({
    this.id,
    this.name
  });

  factory Department.fromJson(Map<String, dynamic> json){
    return Department(
        id : int.parse(json["id"].toString()),
        name : json["name"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
  };

}