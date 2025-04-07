import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleListLoading extends StatelessWidget {
  const SimpleListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          loadingTile(context),
          loadingTile(context),
          loadingTile(context),
          loadingTile(context),
          loadingTile(context),
          loadingTile(context),
          loadingTile(context),
          loadingTile(context)
        ],
      ),
    );
  }
}

loadingTile(context) {
  return ListTile(
    title: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Colors.grey[10],
        boxShadow: const [
          BoxShadow(
              color: Color(0xffd4d4d9), spreadRadius: 0.2, blurRadius: 1.0),
        ],
        border: Border.all(color: Colors.black12),
      ),
    ),
    subtitle: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Colors.grey[10],
        boxShadow: const [
          BoxShadow(
              color: Color(0xffd4d4d9), spreadRadius: 0.2, blurRadius: 1.0),
        ],
        border: Border.all(color: Colors.black12),
      ),
    ),
  );
}
