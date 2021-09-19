import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class Services {
  final BuildContext context;
  Services(this.context);

  var api = "https://demoonlineshop.revoapps.id/wp-json/revo-admin/v1/";

  getData(apiName) async {
    final response =
        await http.get(Uri.parse('$api$apiName'), headers: {"Accept": "application/json"});

    final data = jsonDecode(response.body);
    return data;
  }
}
