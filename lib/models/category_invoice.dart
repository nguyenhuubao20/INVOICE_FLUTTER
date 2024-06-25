import 'package:invoice/models/invoice.dart';

class CategoryInvoice {
  final String name;
  final List<Invoice> invoices;

  CategoryInvoice({required this.name, required this.invoices});
}
