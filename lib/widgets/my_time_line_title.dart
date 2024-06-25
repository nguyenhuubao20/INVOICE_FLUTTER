// import 'package:flutter/material.dart';
// import 'package:timelines_plus/timelines_plus.dart';

// class MyTimeLineTitle extends StatelessWidget {
//   final Axis? direction;
//   final Widget node;
//   final TimelineNodeAlign nodeAlign;
//   final double? nodePosition;
//   final Widget? contents;
//   final Widget? oppositeContents;
//   final double? mainAxisExtent;
//   final double? crossAxisExtent;

//   const MyTimeLineTitle({
//     Key? key,
//     this.direction,
//     required this.node,
//     this.nodeAlign = TimelineNodeAlign.basic,
//     this.nodePosition,
//     this.contents,
//     this.oppositeContents,
//     this.mainAxisExtent,
//     this.crossAxisExtent,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TimelineTile(
//       direction: direction ?? Axis.vertical,
//       nodeAlign: nodeAlign,
//       node: TimelineNode(
//         indicator: node,
//         startConnector: const SolidLineConnector(),
//         endConnector: const SolidLineConnector(),
//       ),
//       nodePosition: nodePosition ?? 0.5,
//       contents: contents ?? Container(),
//       oppositeContents: oppositeContents ?? Container(),
//       mainAxisExtent: mainAxisExtent ?? 120.0,
//       crossAxisExtent: crossAxisExtent,
//     );
//   }
// }
