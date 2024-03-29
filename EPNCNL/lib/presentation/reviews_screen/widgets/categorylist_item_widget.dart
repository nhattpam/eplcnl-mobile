import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';

// ignore: must_be_immutable
class CategorylistItemWidget extends StatelessWidget {
  const CategorylistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.h,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(
            left: 18.h,
            top: 2.v,
            bottom: 1.v,
          ),
          child: Text(
            "Excellect",
            style: CustomTextStyles.labelLargeOnPrimaryContainer_1,
          ),
        ),
      ),
    );
  }
}
