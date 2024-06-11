import 'package:flutter/material.dart';

import '../../models/store.dart';

class StoreListBottomSheet extends StatelessWidget {
  final List<Store>? storeList;
  final Function(String) onSelectStore;

  const StoreListBottomSheet({
    Key? key,
    this.storeList,
    required this.onSelectStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: storeList?.length ?? 0,
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
                child: ListTile(
                  leading: CircleAvatar(), // Thêm hình ảnh vào đây
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
                    onSelectStore(store.name ?? '');
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 50, // Thay đổi kích thước tùy thích
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Đóng bottom sheet khi nút được nhấn
            },
            child: Text('Close'),
          ),
        ),
      ],
    );
  }
}
