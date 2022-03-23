import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {

  NetworkHelper(this.url, {this.headers});

  final Uri url;
  final Map<String, String> headers;

  Future getData() async {
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String data = response.body;
      
      return jsonDecode(data);

    } else {
      print(response.statusCode);
    }
  }
}