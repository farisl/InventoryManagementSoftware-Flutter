import 'dart:convert';

class Product{
  final int id;
  final String? name;
  final String? category;
  final String? price;

  Product({
    required this.id,
    this.name,
    this.category,
    this.price
});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id : int.parse(json["id"].toString()),
      name : json["name"],
      category : json["category"],
      price : json["price"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
    "category" : category,
    "price" : price
  };

}