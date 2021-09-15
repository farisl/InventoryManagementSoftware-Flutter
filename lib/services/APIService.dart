import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService{
  static String? token = '';
  String? route;
  static int employeeId = 0;
  static int inventoryId = 0;
  static int userId = 0;

  APIService({this.route});

  static Future<List<dynamic>?> Get(String route, String? query)  async{
    String baseUrl = "https://10.0.2.2:5001/" + route;
    final String bearer = 'Bearer ' + token!;

    if(query != null)
      baseUrl = baseUrl + '?' + query;

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader:bearer}
    );
    if(response.statusCode == 200){
      return json.decode(response.body) as List;
    }
    return null;
  }

  static Future<dynamic> GetById(String route, int id)  async{
    String baseUrl = "https://10.0.2.2:5001/" + route + '/' + id.toString();
    final String bearer = 'Bearer ' + token!;

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader:bearer}
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }
    return null;
  }

  static Future<dynamic> Post(String route, String query)  async{
    String baseUrl = "https://10.0.2.2:5001/" + route + '?' + query;
    final String bearer = 'Bearer ' + token!;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token'
      },
    );
    if(response.statusCode == 201 || response.statusCode == 200){
      return json.decode(response.body);
    }
    return null;
  }

  static Future<dynamic> Put(String route, int id, String body)  async{
    String baseUrl = "https://10.0.2.2:5001/" + route + '/' + id.toString();
    final String bearer = 'Bearer ' + token!;

    final response = await http.put(
        Uri.parse(baseUrl),
        body: body,
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
        'accept' : 'text/plain',
        'Authorization': 'Bearer $token'
      }
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }
    return null;
  }

  static Future<bool> Delete(String route, int id) async{
    String baseUrl = "https://10.0.2.2:5001/" + route + '/' + id.toString();
    final String bearer = 'Bearer ' + token!;

    final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {HttpHeaders.authorizationHeader:bearer}
    );

    return response.statusCode == 200;
  }

  static Future<dynamic> Recommend(String route, int id)  async{
    String baseUrl = "https://10.0.2.2:5001/" + route + '/' + id.toString()
      + '/recommend';

    final response = await http.get(
        Uri.parse(baseUrl),
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }
    return null;
  }

}