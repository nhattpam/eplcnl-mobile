import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/presentation/courses_list_filter_screen/courses_list_filter_screen.dart';
import 'package:meowlish/presentation/home_page/search/search_cour.dart';

class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    required this.context, // 1. Add BuildContext parameter
  }) : super(
          key: key,
        );

  final Alignment? alignment;
  final BuildContext context; // 2. Define BuildContext parameter

  final double? width;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context),
          )
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          // autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.titleMediumMulishBluegray200,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onTap: () {
            controller?.clear();
            showSearch(context: context, delegate: SearchCourse());
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.titleMediumMulishBluegray200,
        prefixIcon: prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(13.h, 22.v, 9.h, 22.v),
              child: Icon(
                Icons.search,
                size: 20.adaptSize,
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 64.v,
            ),
        suffixIcon: suffix ??
            GestureDetector(
              onTap: () {
                // Navigate to another screen here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursesListFilterScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.h,
                  vertical: 10.v,
                ),
                margin: EdgeInsets.fromLTRB(30.h, 13.v, 10.h, 13.v),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: Icon(
                  Icons.filter_list, // Replace with the desired icon
                  size: 18.v,
                  color: Colors.white, // Specify the desired color,
                ),
              ),
            ),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 64.v,
            ),
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 21.v),
        fillColor: fillColor ?? theme.colorScheme.onPrimaryContainer,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide.none,
            ),
      );
}
