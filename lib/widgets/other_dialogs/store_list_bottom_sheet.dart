import 'package:flutter/material.dart';

import '../../models/store.dart';

class StoreListBottomSheet extends StatelessWidget {
  final List<Store>? storeList;
  final Function(String, String)? onSelectStore; // Thêm cả ID và name

  const StoreListBottomSheet({
    Key? key,
    this.storeList,
    this.onSelectStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.blue,
            width: 5.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          if (storeList != null && storeList!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: storeList!.length,
                itemBuilder: (BuildContext context, int index) {
                  final Store store = storeList![index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.storefront_outlined,
                              size: 32.0,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  store.address ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.add,
                              size: 32.0,
                            ),
                            onTap: () {
                              onSelectStore!(
                                store.id ?? '',
                                store.name ?? '',
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            const Expanded(
              child: Center(child: Text('No data')),
            ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
