enum InvoiceStatus {
  Pending,
  Sent,
  PendingApproval,
  Completed,
  Failed,
}

String invoiceStatusFromString(int value) {
  switch (value) {
    case 0:
      return 'Pending';
    case 1:
      return 'Sent';
    case 2:
      return 'PendingApproval';
    case 3:
      return 'Completed';
    case 4:
      return 'Failed';
    default:
      throw ArgumentError("Invalid value: $value");
  }
}
