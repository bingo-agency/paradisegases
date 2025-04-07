class ChallanModel {
  final String id;
  final String saleId;
  final String customerId;
  final String customerName;
  final String empty;
  final String itemName;
  final String qty;
  final String price;
  final String totalPrice;
  final String cylinderSize;
  final String purity;
  final String? other;
  final String? remarks;
  final String status;
  final String filledQty;

  ChallanModel({
    required this.id,
    required this.saleId,
    required this.customerId,
    required this.customerName,
    required this.empty,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.cylinderSize,
    required this.purity,
    required this.filledQty,
    this.other,
    this.remarks,
    required this.status,
  });

  factory ChallanModel.fromJson(Map<String, dynamic> json) {
    return ChallanModel(
      id: json['id'] as String,
      saleId: json['sale_id'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      empty: json['empty'] as String,
      itemName: json['item_name'] as String,
      qty: json['qty'] as String,
      price: json['price'] as String,
      totalPrice: json['total_price'] as String,
      cylinderSize: json['cylinder_size'] as String,
      purity: json['purity'] as String,
      other: json['other'],
      remarks: json['remarks'],
      status: json['status'] as String,
      filledQty: json['filled_qty'] as String,
    );
  }
}
