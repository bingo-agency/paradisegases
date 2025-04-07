import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ChallanModel.dart';

class ChallanService {
  Future<List<ChallanModel>> getChallanDetails(String challanId) async {
    var url =
        'https://bingo-agency.com/paradisegases.com/admin/api/challan_detail?challan_id=' +
            challanId;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    // print(uri.toString);

    if (response.statusCode == 200) {
      final rsbody = jsonDecode(response.body);
      // print(rsbody.toString());

      if (rsbody != null && rsbody['sold_items'] != null) {
        final json = rsbody['sold_items'] as List;
        return json.map((e) => ChallanModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load challan details');
    }
  }
}
