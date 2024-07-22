//report
class InvoiceReport {
  DateTime? date;
  int? totalInvoiceReportInDate;
  int? draft;
  int? success;
  int? sent;
  int? pendingApproval;
  int? completed;
  int? failed;
  int? pending;
  int? retryPending;
  int? replaced;

  InvoiceReport({
    this.date,
    this.totalInvoiceReportInDate,
    this.draft,
    this.success,
    this.sent,
    this.pendingApproval,
    this.completed,
    this.failed,
    this.pending,
    this.retryPending,
    this.replaced,
  });

  factory InvoiceReport.fromJson(Map<String, dynamic> json) {
    return InvoiceReport(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      totalInvoiceReportInDate: json['totalInvoiceReportInDate'],
      draft: json['draft'],
      success: json['success'],
      sent: json['sent'],
      pendingApproval: json['pendingApproval'],
      completed: json['completed'],
      failed: json['failed'],
      pending: json['pending'],
      retryPending: json['retryPending'],
      replaced: json['replaced'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'totalInvoiceReportInDate': totalInvoiceReportInDate,
      'draft': draft,
      'success': success,
      'sent': sent,
      'pendingApproval': pendingApproval,
      'completed': completed,
      'failed': failed,
      'pending': pending,
      'retryPending': retryPending,
      'replaced': replaced,
    };
  }

  static InvoiceReport empty() {
    return InvoiceReport(
      date: null,
      totalInvoiceReportInDate: 0,
      draft: 0,
      success: 0,
      sent: 0,
      pendingApproval: 0,
      completed: 0,
      failed: 0,
      pending: 0,
      retryPending: 0,
      replaced: 0,
    );
  }

  InvoiceReport copyWith({
    DateTime? date,
    int? totalInvoiceReportInDate,
    int? draft,
    int? success,
    int? sent,
    int? pendingApproval,
    int? completed,
    int? failed,
    int? pending,
    int? retryPending,
    int? replaced,
  }) {
    return InvoiceReport(
      date: date ?? this.date,
      totalInvoiceReportInDate:
          totalInvoiceReportInDate ?? this.totalInvoiceReportInDate,
      draft: draft ?? this.draft,
      success: success ?? this.success,
      sent: sent ?? this.sent,
      pendingApproval: pendingApproval ?? this.pendingApproval,
      completed: completed ?? this.completed,
      failed: failed ?? this.failed,
      pending: pending ?? this.pending,
      retryPending: retryPending ?? this.retryPending,
      replaced: replaced ?? this.replaced,
    );
  }
}

class InvoicePaymentReport {
  DateTime? date;
  int? totalInvoiceReportInDate;
  double? totalTaxAmountReport;
  double? totalAmountAfterTaxReport;
  double? totalSaleAmountReport;
  double? totalDiscountAmountReport;
  double? totalAmountWithoutTaxReport;
  double? totalAmountReport;

  InvoicePaymentReport({
    this.date,
    this.totalInvoiceReportInDate,
    this.totalTaxAmountReport,
    this.totalAmountAfterTaxReport,
    this.totalSaleAmountReport,
    this.totalDiscountAmountReport,
    this.totalAmountWithoutTaxReport,
    this.totalAmountReport,
  });

  factory InvoicePaymentReport.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentReport(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      totalInvoiceReportInDate: json['totalInvoiceReportInDate'] as int?,
      totalTaxAmountReport: (json['totalTaxAmountReport'] as num?)?.toDouble(),
      totalAmountAfterTaxReport:
          (json['totalAmountAfterTaxReport'] as num?)?.toDouble(),
      totalSaleAmountReport:
          (json['totalSaleAmountReport'] as num?)?.toDouble(),
      totalDiscountAmountReport:
          (json['totalDiscountAmountReport'] as num?)?.toDouble(),
      totalAmountWithoutTaxReport:
          (json['totalAmountWithoutTaxReport'] as num?)?.toDouble(),
      totalAmountReport: (json['totalAmountReport'] as num?)?.toDouble(),
    );
  }

  static InvoicePaymentReport empty() {
    return InvoicePaymentReport(
      date: null,
      totalInvoiceReportInDate: 0,
      totalTaxAmountReport: 0.0,
      totalAmountAfterTaxReport: 0.0,
      totalSaleAmountReport: 0.0,
      totalDiscountAmountReport: 0.0,
      totalAmountWithoutTaxReport: 0.0,
      totalAmountReport: 0.0,
    );
  }
}
