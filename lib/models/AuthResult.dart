import 'dart:convert';

class AuthResult {
  final String token;
  final int? employeeId;
  final int? inventoryId;
  final int? userId;


  AuthResult({
    required this.token,
    this.employeeId,
    this.inventoryId,
    this.userId
  });

  factory AuthResult.fromJson(Map<String, dynamic> json){
    return AuthResult(
        token: json['token'],
        employeeId: int.parse(json["employeeId"].toString()),
        inventoryId: int.parse(json["inventoryId"].toString()),
        userId: int.parse(json["userId"].toString())
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "token": token,
        "employeeId": employeeId,
        "inventoryId": inventoryId,
        "userId": userId
      };
}

