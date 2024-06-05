

class InvoiceTemplateAPI {
  static int page = 1;
  static int size = 10;

  // Future<List<InvoiceTemplate>?> getTemplateByOrganizationId() async {
  //   try {
  //     var params = {
  //       'page': page,
  //       'size': size,
  //     };
  //     final res = await request.get('organizations', queryParameters: params);
  //     if (res.statusCode == 200) {
  //       List<dynamic> jsonList = res.data['items'];
  //       List<Invoice> invoices =
  //           jsonList.map((json) => Invoice.fromJson(json)).toList();
  //       return invoices;
  //     } else {
  //       throw Exception('Failed to load invoices: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during get invoices: $e');
  //     return null;
  //   }
  // }
}
