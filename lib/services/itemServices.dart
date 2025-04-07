import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

class ItemService {
  static Future<List<ItemModel>> fetchItems(String customerId) async {
    final String url =
        "https://bingo-agency.com/paradisegases.com/admin/api/getItems.php?customer_id=$customerId";

    try {
      final response = await http.get(Uri.parse(url));
      print(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data.toString());
        List<ItemModel> items = (data['items'] as List)
            .map((item) => ItemModel.fromJson(item))
            .toList();
        return items;
      } else {
        throw Exception("Failed to load items");
      }
    } catch (e) {
      throw Exception("Error fetching items: $e");
    }
  }
}
