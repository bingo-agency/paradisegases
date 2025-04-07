import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/requestModel.dart';

class Dcsservices {
  Future<List<DcsModel>> getDcs() async {
    var url = 'https://bingo-agency.com/paradisegases.com/admin/api/getDcs.php';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // print("Response Status Code: ${response.statusCode}");
    // print("Raw Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final rsbody = jsonDecode(response.body);

      // Check if the 'requests' key exists and is not null
      if (rsbody != null && rsbody['requests'] != null) {
        final json = rsbody['requests'] as List;
        return json.map((e) {
          return DcsModel(
              id: e['id'],
              customer_id: e['customer_id'],
              customer_name: e['customer_name'],
              item_description: e['item_description'],
              total_cylinders: e['total_cylinders'],
              approval_status: e['approval_status'],
              timestamp: e['timestamp']);
        }).toList();
      } else {
        // Return an empty list if 'requests' is null or not present
        return [];
      }
    } else {
      throw Exception('Failed to load requests');
    }
  }
}
