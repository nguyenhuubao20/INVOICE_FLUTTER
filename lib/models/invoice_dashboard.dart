//report
class InvoiceReport {
  int? totalInvoice;
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
    this.totalInvoice,
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
      totalInvoice: json['totalInvoice'],
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
      'totalInvoice': totalInvoice,
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
}

class InvoicePaymentReport {
  int? totalInvoiceReport;
  int? totalInvoiceReportInDate;
  double? totalTaxAmountReport;
  double? totalAmountAfterTaxReport;
  double? totalSaleAmountReport;
  double? totalDiscountAmountReport;
  double? totalAmountWithoutTaxReport;
  double? totalAmountReport;

  InvoicePaymentReport({
    this.totalInvoiceReport,
    this.totalInvoiceReportInDate,
    this.totalTaxAmountReport,
    this.totalAmountAfterTaxReport,
    this.totalSaleAmountReport,
    this.totalDiscountAmountReport,
    this.totalAmountWithoutTaxReport,
    this.totalAmountReport,
  });

  InvoicePaymentReport.empty()
      : totalInvoiceReport = 0,
        totalInvoiceReportInDate = 0,
        totalTaxAmountReport = 0.0,
        totalAmountAfterTaxReport = 0.0,
        totalSaleAmountReport = 0.0,
        totalDiscountAmountReport = 0.0,
        totalAmountWithoutTaxReport = 0.0,
        totalAmountReport = 0.0;

  factory InvoicePaymentReport.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentReport(
      totalInvoiceReport: json['totalInvoiceReport'],
      totalInvoiceReportInDate: json['totalInvoiceReportInDate'],
      totalTaxAmountReport: json['totalTaxAmountReport'],
      totalAmountAfterTaxReport: json['totalAmountAfterTaxReport'],
      totalSaleAmountReport: json['totalSaleAmountReport'],
      totalDiscountAmountReport: json['totalDiscountAmountReport'],
      totalAmountWithoutTaxReport: json['totalAmountWithoutTaxReport'],
      totalAmountReport: json['totalAmountReport'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInvoiceReport': totalInvoiceReport,
      'totalInvoiceReportInDate': totalInvoiceReportInDate,
      'totalTaxAmountReport': totalTaxAmountReport,
      'totalAmountAfterTaxReport': totalAmountAfterTaxReport,
      'totalSaleAmountReport': totalSaleAmountReport,
      'totalDiscountAmountReport': totalDiscountAmountReport,
      'totalAmountWithoutTaxReport': totalAmountWithoutTaxReport,
      'totalAmountReport': totalAmountReport,
    };
  }
}
