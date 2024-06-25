import 'package:flutter/material.dart';

import '../../models/store.dart';

class StoreListBottomSheet extends StatelessWidget {
  final List<Store>? storeList;
  final Function(String)? onSelectStore;

  const StoreListBottomSheet({
    Key? key,
    this.storeList,
    this.onSelectStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (storeList != null && storeList!.isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
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
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(),
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
                        onTap: () {
                          onSelectStore!(store.name ?? '');
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('No data'))),
            ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
