class Invoice {
  final String id;
  final DateTime date;
  final String customerName;
  final double totalPrice;
  final String status;
  final String orderNumber;

  Invoice({
    required this.id,
    required this.date,
    required this.customerName,
    required this.totalPrice,
    required this.status,
    required this.orderNumber,
  });
}
