import 'dart:convert';

class Employee {
  final int id;
  final int? genderId;
  final int? cityId;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final DateTime? hireDate;
  final String? jmbg;
  final String? addressName;
  final String? city;
  final String? username;
  final String? email;
  late final String? phoneNumber;
  final String? inventory;
  final String? genderName;
  final double? salary;
  final bool? active;


  Employee({
    required this.id,
    this.fullName,
    this.firstName,
    this.cityId,
    this.lastName,
    this.genderId,
    this.birthDate,
    this.hireDate,
    this.jmbg,
    this.addressName,
    this.city,
    this.username,
    this.email,
    this.phoneNumber,
    this.inventory,
    this.salary,
    this.genderName,
    this.active,
  });

  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(
        id: int.parse(json["id"].toString()),
        cityId: int.parse(json["cityId"].toString()),
        genderId: int.parse(json["genderId"].toString()),
        birthDate: DateTime.parse(json["birthDate"].toString()),
        hireDate: DateTime.parse(json["hireDate"].toString()),
        fullName: json['fullName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        jmbg: json['jmbg'],
        addressName: json['addressName'],
        city: json['city'],
        username: json['username'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        inventory: json['inventory'],
        genderName: json['genderName'],
        active: json['active'] as bool,
        salary: double.parse(json['salary'].toString())
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "birthDate": birthDate,
        "fullName": fullName,
        "firstName": firstName,
        "genderId": genderId,
        "lastName": lastName,
        "jmbg": jmbg,
        "addressName": addressName,
        "city": city,
        "username": username,
        "email": email,
        "phoneNumber": phoneNumber,
        "inventory": inventory,
        "genderName": genderName,
        "active": active,
        "salary": salary
      };
}

