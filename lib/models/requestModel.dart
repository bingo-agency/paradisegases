class DcsModel {
  final String id;
  final String customer_id;
  final String customer_name;
  final String item_description;
  final String total_cylinders;
  final String approval_status;
  final String timestamp;

  DcsModel({
    required this.id,
    required this.customer_id,
    required this.customer_name,
    required this.item_description,
    required this.total_cylinders,
    required this.approval_status,
    required this.timestamp,
  });

  factory DcsModel.fromJson(Map<String, dynamic> json) {
    return DcsModel(
      id: json['id'] as String,
      customer_id: json['customer_id'] as String,
      customer_name: json['customer_name'] as String,
      item_description: json['item_description'] as String,
      total_cylinders: json['total_cylinders'] as String,
      approval_status:
          json['approval_status'].toString(), // Ensure it's a string
      timestamp: json['timestamp'] as String,
    );
  }
}
