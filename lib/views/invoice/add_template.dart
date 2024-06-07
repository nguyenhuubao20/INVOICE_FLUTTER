import 'package:flutter/material.dart';
import 'package:invoice/view_models/invoice_template_view_model.dart';

class AddInvoiceTemplate extends StatefulWidget {
  const AddInvoiceTemplate({super.key});

  @override
  State<AddInvoiceTemplate> createState() => _AddInvoiceTemplateState();
}

class _AddInvoiceTemplateState extends State<AddInvoiceTemplate> {
  final _invoiceTemplateViewModel = InvoiceTemplateViewModel();

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
        title: Text('Add Invoice Template'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _invoiceTemplateViewModel.invoiceTemplates!.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: _selectedTemplates[index],
                  title: Text(
                    _invoiceTemplateViewModel.invoiceTemplates?[index].id ?? '',
                  ),
                  subtitle: Text(
                    _invoiceTemplateViewModel
                            .invoiceTemplates?[index].templateName ??
                        '',
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedTemplates[index] = value ?? false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
