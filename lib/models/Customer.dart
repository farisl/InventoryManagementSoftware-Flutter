import 'dart:convert';

class Customer {
  final int id;
  final String? name;


  Customer({
    required this.id,
    this.name
  });

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
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

