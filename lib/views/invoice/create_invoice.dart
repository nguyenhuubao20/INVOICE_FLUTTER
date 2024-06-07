import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/utils/route_constrant.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(RouteHandler.ADD_TEMPLATES);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Add Template"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Add Partner"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Add Item"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
