import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:meowlish/widgets/custom_icon_button.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 31.h,
            vertical: 30.v,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 39.v),
              Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowDownBlueGray900,
                      height: 20.v,
                      width: 26.h,
                      margin: EdgeInsets.only(
                        top: 4.v,
                        bottom: 5.v,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: Text(
                        "Payment Methods",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.v),
              _buildPaymentMethodsRow(context),
              SizedBox(height: 21.v),
              Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(
                  "Select the Payment Methods you Want to Use",
                  style: theme.textTheme.titleSmall,
                ),
              ),
              SizedBox(height: 35.v),
              _buildPaymentOptionsRow(context),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 16.h),
                child: CustomIconButton(
                  height: 62.adaptSize,
                  width: 62.adaptSize,
                  padding: EdgeInsets.all(18.h),
                  decoration: IconButtonStyleHelper.outlineBlackTL31,
                  alignment: Alignment.centerRight,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCloseOnprimarycontainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildEnrollCourseButton(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentMethodsRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.h),
      padding: EdgeInsets.symmetric(
        horizontal: 21.h,
        vertical: 14.v,
      ),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 100.adaptSize,
            width: 100.adaptSize,
            margin: EdgeInsets.only(top: 6.v),
            decoration: BoxDecoration(
              color: appTheme.black900,
              borderRadius: BorderRadius.circular(
                16.h,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 33.v,
              right: 8.h,
              bottom: 25.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Graphic Design",
                  style: CustomTextStyles.labelLargeOrangeA700,
                ),
                SizedBox(height: 7.v),
                Text(
                  "Setup your Graphic Desig..",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentOptionsRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 17.v,
      ),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 231.h,
              top: 5.v,
              bottom: 2.v,
            ),
            child: Text(
              "VN Pay",
              style: CustomTextStyles.titleSmallBluegray900ExtraBold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 11.h),
            padding: EdgeInsets.all(5.h),
            decoration: AppDecoration.outlineTeal.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder15,
            ),
            child: Container(
              height: 12.adaptSize,
              width: 12.adaptSize,
              decoration: BoxDecoration(
                color: appTheme.teal700,
                borderRadius: BorderRadius.circular(
                  6.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEnrollCourseButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Enroll Course - 55",
      margin: EdgeInsets.only(
        left: 39.h,
        right: 39.h,
        bottom: 53.v,
      ),
      rightIcon: Container(
        padding: EdgeInsets.fromLTRB(14.h, 16.v, 12.h, 14.v),
        margin: EdgeInsets.only(left: 30.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(
            24.h,
          ),
        ),
        child: CustomImageView(
          imagePath: ImageConstant.imgFill1Primary,
          height: 17.v,
          width: 21.h,
        ),
      ),
    );
  }
}