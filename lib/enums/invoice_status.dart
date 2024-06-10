import 'package:flutter/material.dart';

enum InvoiceStatus {
  Pending,
  Sent,
  PendingApproval,
  Completed,
  Failed,
}

String invoiceStatusFromString(int? value) {
  switch (value) {
    case 0:
      return 'Pending';
    case 1:
      return 'Sent';
    case 2:
      return 'Pending Approval';
    case 3:
      return 'Completed';
    case 4:
      return 'Failed';
    default:
      throw ArgumentError("Invalid value: $value");
  }
}

Color? getStatusColor(int? status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.red;
    case 2:
      return Colors.green;
    case 3:
      return Colors.white;
    default:
      return Colors.grey;
  }
}
