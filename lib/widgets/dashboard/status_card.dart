import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final double width;
  final double height;

  const StatusCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCardRevenue extends StatelessWidget {
  final String title;
  final double value; // Giá trị là kiểu double
  final Color color;
  final double width;
  final double height;

  const StatusCardRevenue({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value.toStringAsFixed(
                  2), // Định dạng hiển thị số với 2 chữ số thập phân
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
