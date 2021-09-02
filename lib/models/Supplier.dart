import 'dart:convert';

class Supplier {
  final int id;
  final String? name;


  Supplier({
    required this.id,
    this.name
  });

  factory Supplier.fromJson(Map<String, dynamic> json){
    return Supplier(
        id: int.parse(json["id"].toString()),
        name: json['name']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
      };
}

