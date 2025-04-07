class ItemModel {
  final String itemName;
  final String defaultPrice;
  final String userPrice;
  final String storedLocations;
  final int totalQty;

  ItemModel({
    required this.itemName,
    required this.defaultPrice,
    required this.userPrice,
    required this.storedLocations,
    required this.totalQty,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemName: json['item_name'],
      defaultPrice: json['default_price'],
      userPrice: json['user_price'],
      storedLocations: json['stored_locations'],
      totalQty: int.parse(json['total_qty']),
    );
  }
}
