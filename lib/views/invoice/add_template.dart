import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/view_models/invoice_template_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../utils/route_constrant.dart';

class AddInvoiceTemplate extends StatefulWidget {
  const AddInvoiceTemplate({super.key});

  @override
  State<AddInvoiceTemplate> createState() => _AddInvoiceTemplateState();
}

class _AddInvoiceTemplateState extends State<AddInvoiceTemplate> {
  final InvoiceTemplateViewModel _invoiceTemplateViewModel =
      InvoiceTemplateViewModel();

  late final List<bool> _selectedTemplates = List<bool>.filled(
    _invoiceTemplateViewModel.invoiceTemplates!.length,
    false,
  );

  @override
  void initState() {
    super.initState();
    _invoiceTemplateViewModel.loadInvoiceTemplatesByOrganizationId();
  }

  @override
  void dispose() {
    _invoiceTemplateViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Get.offAllNamed(RouteHandler.CREATE_INVOICE);
          },
        ),
      ),
      body: ScopedModel<InvoiceTemplateViewModel>(
        model: _invoiceTemplateViewModel,
        child: ScopedModelDescendant<InvoiceTemplateViewModel>(
          builder: (context, child, model) {
            if (_invoiceTemplateViewModel.status == ViewStatus.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (_invoiceTemplateViewModel.status == ViewStatus.Error) {
              return Center(child: Text('Failed to load templates'));
            } else if (_invoiceTemplateViewModel.status ==
                    ViewStatus.Completed &&
                _invoiceTemplateViewModel.invoiceTemplates != null) {
              return ListView.builder(
                itemCount: _invoiceTemplateViewModel.invoiceTemplates!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    value: _selectedTemplates[index],
                    title: Text(
                      _invoiceTemplateViewModel.invoiceTemplates![index].id ??
                          '',
                    ),
                    subtitle: Text(
                      _invoiceTemplateViewModel
                              .invoiceTemplates![index].templateName ??
                          '',
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedTemplates[index] = value ?? false;
                      });
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('Failed to load templates'));
            }
          },
        ),
      ),
    );
  }

  // Widget _buildBody() {
  //   return SafeArea(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 16),
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: _invoiceTemplateViewModel.invoiceTemplates!.length,
  //             itemBuilder: (context, index) {
  //               return CheckboxListTile(
  //                 value: _selectedTemplates[index],
  //                 title: Text(
  //                   _invoiceTemplateViewModel.invoiceTemplates?[index].id ?? '',
  //                 ),
  //                 subtitle: Text(
  //                   _invoiceTemplateViewModel
  //                           .invoiceTemplates?[index].templateName ??
  //                       '',
  //                 ),
  //                 onChanged: (bool? value) {
  //                   setState(() {
  //                     _selectedTemplates[index] = value ?? false;
  //                   });
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
