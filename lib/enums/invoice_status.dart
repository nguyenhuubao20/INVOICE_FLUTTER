import 'package:flutter/material.dart';

enum InvoiceStatus {
  Draft, // Bản nháp
  Success, // Gửi thành công
  Sent, // Đã gửi
  PendingApproval, // Đang chờ phê duyệt
  Completed, // Hoàn tất
  Failed, // Thất bại
  Pending,
  RetryPending, //Đang chờ thử lại
}

String invoiceStatusFromString(int? value) {
  switch (value) {
    case 0:
      return 'Draft';
    case 1:
      return 'Success';
    case 2:
      return 'Sent';
    case 3:
      return 'PendingApproval';
    case 4:
      return 'Completed';
    case 5:
      return 'Failed';
    case 6:
      return 'Pending';
    case 7:
      return 'RetryPending';
    default:
      throw ArgumentError("Invalid value: $value");
  }
}

String invoiceStatusFromInt(int? value) {
  switch (value) {
    case 0:
      return 'Draft';
    case 1:
      return 'Success';
    case 2:
      return 'Sent';
    case 3:
      return 'PendingApproval';
    case 4:
      return 'Completed';
    case 5:
      return 'Failed';
    case 6:
      return 'Pending';
    case 7:
      return 'RetryPending';
    default:
      throw ArgumentError("Invalid value: $value");
  }
}

String invoiceStatusFromEnum(InvoiceStatus status) {
  switch (status) {
    case InvoiceStatus.Draft:
      return 'Draft';
    case InvoiceStatus.Success:
      return 'Success';
    case InvoiceStatus.Sent:
      return 'Sent';
    case InvoiceStatus.PendingApproval:
      return 'PendingApproval';
    case InvoiceStatus.Completed:
      return 'Completed';
    case InvoiceStatus.Failed:
      return 'Failed';
    case InvoiceStatus.Pending:
      return 'Pending';
    case InvoiceStatus.RetryPending:
      return 'RetryPending';
    default:
      throw ArgumentError("Invalid status: $status");
  }
}

Color getStatusColor(int? status) {
  switch (status) {
    case 0:
      return Colors.grey;
    case 1:
      return Colors.green;
    case 2:
      return Colors.green;
    case 3:
      return Colors.yellow;
    case 4:
      return Colors.yellow;
    case 5:
      return Colors.red;
    case 6:
      return Colors.red;
    case 7:
      return Colors.green;
    default:
      return Colors.grey;
  }
}

enum VnpayInvoiceStatus {
  origin, // Hóa đơn gốc
  adjustment, // Hóa đơn điều chỉnh
  adjusted, // Hóa đơn bị điều chỉnh
  replacement, // Hóa đơn thay thế
  replaced, // Hóa đơn bị thay thế
  cancel, // Hóa đơn đã hủy
}

extension VnpayInvoiceStatusExtension on VnpayInvoiceStatus {
  static String get(String value) {
    try {
      VnpayInvoiceStatus status = fromString(value);
      return status.description;
    } catch (e) {
      return 'Unknown status';
    }
  }

  String get description {
    switch (this) {
      case VnpayInvoiceStatus.origin:
        return 'Hóa đơn gốc';
      case VnpayInvoiceStatus.adjustment:
        return 'Hóa đơn điều chỉnh';
      case VnpayInvoiceStatus.adjusted:
        return 'Hóa đơn bị điều chỉnh';
      case VnpayInvoiceStatus.replacement:
        return 'Hóa đơn thay thế';
      case VnpayInvoiceStatus.replaced:
        return 'Hóa đơn bị thay thế';
      case VnpayInvoiceStatus.cancel:
        return 'Hóa đơn đã hủy';
      default:
        return '';
    }
  }

  static VnpayInvoiceStatus fromString(String status) {
    switch (status) {
      case 'origin':
        return VnpayInvoiceStatus.origin;
      case 'adjustment':
        return VnpayInvoiceStatus.adjustment;
      case 'adjusted':
        return VnpayInvoiceStatus.adjusted;
      case 'replacement':
        return VnpayInvoiceStatus.replacement;
      case 'replaced':
        return VnpayInvoiceStatus.replaced;
      case 'cancel':
        return VnpayInvoiceStatus.cancel;
      default:
        throw Exception('Invalid InvoiceStatus value');
    }
  }

  String get value {
    switch (this) {
      case VnpayInvoiceStatus.origin:
        return 'origin';
      case VnpayInvoiceStatus.adjustment:
        return 'adjustment';
      case VnpayInvoiceStatus.adjusted:
        return 'adjusted';
      case VnpayInvoiceStatus.replacement:
        return 'replacement';
      case VnpayInvoiceStatus.replaced:
        return 'replaced';
      case VnpayInvoiceStatus.cancel:
        return 'cancel';
      default:
        return '';
    }
  }
}

enum VnpayStatus {
  newStatus, // Tạo mới
  released, // Đã phát hành
  signed, // Đã ký số
  signError, // Ký số lỗi
  deleted, // Đã xóa
  canceled, // Đã hủy
}

extension VnpayStatusExtension on VnpayStatus {
  String get description {
    switch (this) {
      case VnpayStatus.newStatus:
        return 'Tạo mới';
      case VnpayStatus.released:
        return 'Đã phát hành';
      case VnpayStatus.signed:
        return 'Đã ký số';
      case VnpayStatus.signError:
        return 'Ký số lỗi';
      case VnpayStatus.deleted:
        return 'Đã xóa';
      case VnpayStatus.canceled:
        return 'Đã hủy';
      default:
        return '';
    }
  }

  static VnpayStatus fromInt(int status) {
    switch (status) {
      case 0:
        return VnpayStatus.newStatus;
      case 1:
        return VnpayStatus.released;
      case 2:
        return VnpayStatus.signed;
      case 3:
        return VnpayStatus.signError;
      case 4:
        return VnpayStatus.deleted;
      case 5:
        return VnpayStatus.canceled;
      default:
        throw Exception('Invalid Status value');
    }
  }

  static VnpayStatus fromString(String status) {
    switch (status) {
      case 'new':
        return VnpayStatus.newStatus;
      case 'released':
        return VnpayStatus.released;
      case 'signed':
        return VnpayStatus.signed;
      case 'signError':
        return VnpayStatus.signError;
      case 'deleted':
        return VnpayStatus.deleted;
      case 'canceled':
        return VnpayStatus.canceled;
      default:
        throw Exception('Invalid Status value');
    }
  }

  String get value {
    switch (this) {
      case VnpayStatus.newStatus:
        return 'new';
      case VnpayStatus.released:
        return 'released';
      case VnpayStatus.signed:
        return 'signed';
      case VnpayStatus.signError:
        return 'sign_error';
      case VnpayStatus.deleted:
        return 'deleted';
      case VnpayStatus.canceled:
        return 'canceled';
      default:
        return '';
    }
  }

  static String get(String value) {
    try {
      VnpayStatus status = fromString(value);
      return status.description;
    } catch (e) {
      return 'Unknown status';
    }
  }
}

enum TvanStatus {
  notSentToTaxAuthority, // Chưa gửi Cơ quan thuế
  waitingForTaxResponse, // Chờ Cơ quan thuế phản hồi
  sendingError, // Gửi TVAN lỗi
  taxAuthorityNotAccept, // Cơ quan thuế không tiếp nhận
  taxAuthorityAccepted, // Cơ quan thuế chấp nhận
  taxAuthorityRejected, // Cơ quan thuế từ chối
  taxAuthorityReceived, // Cơ quan thuế tiếp nhận
  taxAuthorityReturnedResult, // Cơ quan thuế trả kết quả
}

extension TvanStatusExtension on TvanStatus {
  String get description {
    switch (this) {
      case TvanStatus.notSentToTaxAuthority:
        return 'Chưa gửi Cơ quan thuế';
      case TvanStatus.waitingForTaxResponse:
        return 'Chờ Cơ quan thuế phản hồi';
      case TvanStatus.sendingError:
        return 'Gửi TVAN lỗi';
      case TvanStatus.taxAuthorityNotAccept:
        return 'Cơ quan thuế không tiếp nhận';
      case TvanStatus.taxAuthorityAccepted:
        return 'Cơ quan thuế chấp nhận';
      case TvanStatus.taxAuthorityRejected:
        return 'Cơ quan thuế từ chối';
      case TvanStatus.taxAuthorityReceived:
        return 'Cơ quan thuế tiếp nhận';
      case TvanStatus.taxAuthorityReturnedResult:
        return 'Cơ quan thuế trả kết quả';
      default:
        return '';
    }
  }

  static TvanStatus fromValue(int value) {
    switch (value) {
      case 1:
        return TvanStatus.notSentToTaxAuthority;
      case 2:
        return TvanStatus.waitingForTaxResponse;
      case 3:
        return TvanStatus.sendingError;
      case 4:
        return TvanStatus.taxAuthorityNotAccept;
      case 5:
        return TvanStatus.taxAuthorityAccepted;
      case 6:
        return TvanStatus.taxAuthorityRejected;
      case 7:
        return TvanStatus.taxAuthorityReceived;
      case 8:
        return TvanStatus.taxAuthorityReturnedResult;
      default:
        throw Exception('Invalid TvanStatus value');
    }
  }

  static String get(int value) {
    try {
      TvanStatus status = fromValue(value);
      return status.description;
    } catch (e) {
      return 'Unknown status';
    }
  }

  int get value {
    switch (this) {
      case TvanStatus.notSentToTaxAuthority:
        return 1;
      case TvanStatus.waitingForTaxResponse:
        return 2;
      case TvanStatus.sendingError:
        return 3;
      case TvanStatus.taxAuthorityNotAccept:
        return 4;
      case TvanStatus.taxAuthorityAccepted:
        return 5;
      case TvanStatus.taxAuthorityRejected:
        return 6;
      case TvanStatus.taxAuthorityReceived:
        return 7;
      case TvanStatus.taxAuthorityReturnedResult:
        return 8;
      default:
        return 0;
    }
  }
}
