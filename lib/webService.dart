import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:civic_points/signIn.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url, this.parse});
}

class Webservice {
  Future<T> load<T>(Resource<T> resource) async {
    final response = await http.get(resource.url);
    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
}

class WebserviceProfilo {
  Future<T> load<T>(Resource<T> resource) async {
    final response = await http.get(resource.url, headers: { HttpHeaders.authorizationHeader: 'Bearer ${token}'});
    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
}