// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:invoice/view_models/invoice_view_model.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:scoped_model/scoped_model.dart';

// class InvoiceItem extends StatefulWidget {
//   const InvoiceItem({Key? key}) : super(key: key);

//   @override
//   State<InvoiceItem> createState() => _InvoiceItemState();
// }

// class _InvoiceItemState extends State<InvoiceItem> {
//   InvoiceViewModel model = Get.find<InvoiceViewModel>();
//   final RefreshController refreshController =
//       RefreshController(initialRefresh: true);

//   @override
//   void initState() {
//     super.initState();
//     model.loadInvoice();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModel<InvoiceViewModel>(
//       model: Get.find<InvoiceViewModel>(),
//       child: ScopedModelDescendant<InvoiceViewModel>(
//         builder: (context, child, model) => SafeArea(
//           child: Center(
//             child: SizedBox(
//               child: SmartRefresher(
//                 enablePullUp: true,
//                 onRefresh: () async {
//                   final result = await model.loadInvoice(isRefresh: true);
//                   if (result) {
//                     refreshController.refreshCompleted();
//                   } else {
//                     refreshController.refreshFailed();
//                   }
//                 },
//                 onLoading: () async {
//                   final result = await model.loadInvoice();
//                   if (result) {
//                     refreshController.loadComplete();
//                   } else {
//                     refreshController.loadNoData();
//                   }
//                 },
//                 controller: refreshController,
//                 child: ListView.builder(
//                   itemCount: model.invoiceList.length,
//                   itemBuilder: (context, index) {
//                     final displayedInvoices = model.invoiceList[index];
//                     return ListTile(
//                       title: Text(displayedInvoices.storeId.toString()),
//                       subtitle: Row(
//                         children: [
//                           Text(
//                             '${displayedInvoices.invoiceCode}',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
