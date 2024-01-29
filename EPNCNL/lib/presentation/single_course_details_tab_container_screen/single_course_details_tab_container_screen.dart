import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/presentation/single_course_details_curriculcum_page/single_course_details_curriculcum_page.dart';
import 'package:meowlish/presentation/single_meet_course_details_page/single_meet_course_details_page.dart';
import 'package:meowlish/widgets/custom_icon_button.dart';

class SingleCourseDetailsTabContainerScreen extends StatefulWidget {
  const SingleCourseDetailsTabContainerScreen({Key? key})
      : super(
          key: key,
        );

  @override
  SingleCourseDetailsTabContainerScreenState createState() =>
      SingleCourseDetailsTabContainerScreenState();
}

class SingleCourseDetailsTabContainerScreenState
    extends State<SingleCourseDetailsTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildArrowDown(context),
                SizedBox(
                  height: 881.v,
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      SingleCourseDetailsCurriculcumPage(),
                      SingleMeetCourseDetailsPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildArrowDown(BuildContext context) {
    return SizedBox(
      height: 595.v,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 35.h,
                vertical: 74.v,
              ),
              decoration: AppDecoration.fillBlack,
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowDownBlueGray100,
                height: 20.v,
                width: 26.h,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 34.h),
              decoration: AppDecoration.outlineBlack.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.h,
                      right: 24.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Graphic Design",
                          style: CustomTextStyles.labelLargeOrangeA700,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgSignal,
                              height: 11.v,
                              width: 12.h,
                              margin: EdgeInsets.only(bottom: 3.v),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.h),
                              child: Text(
                                "4.2",
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Text(
                        "Design Principles: Organizing ..",
                        style: CustomTextStyles.titleLarge20,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.h,
                      right: 24.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgUpload,
                          height: 17.v,
                          width: 18.h,
                          margin: EdgeInsets.only(
                            top: 4.v,
                            bottom: 5.v,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 9.h,
                            top: 7.v,
                            bottom: 5.v,
                          ),
                          child: Text(
                            "21 Class",
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.h,
                            top: 7.v,
                          ),
                          child: Text(
                            "|",
                            style: CustomTextStyles.titleSmallBlack900,
                          ),
                        ),
                        Container(
                          height: 16.adaptSize,
                          width: 16.adaptSize,
                          margin: EdgeInsets.only(
                            left: 10.h,
                            top: 6.v,
                            bottom: 4.v,
                          ),
                          padding: EdgeInsets.all(4.h),
                          decoration: AppDecoration.fillGray900,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFill3,
                            height: 7.v,
                            width: 4.h,
                            alignment: Alignment.topRight,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.h,
                            top: 8.v,
                            bottom: 4.v,
                          ),
                          child: Text(
                            "42 Hours",
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "28",
                          style: CustomTextStyles.titleLargeMulishPrimary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.v),
                  Container(
                    height: 52.v,
                    width: 360.h,
                    child: TabBar(
                      controller: tabviewController,
                      labelPadding: EdgeInsets.zero,
                      labelColor: appTheme.blueGray900,
                      labelStyle: TextStyle(
                        fontSize: 15.fSize,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelColor: appTheme.blueGray900,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 15.fSize,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                      ),
                      indicator: BoxDecoration(
                        color: theme.colorScheme.onPrimaryContainer,
                        border: Border.all(
                          color: appTheme.orange50,
                          width: 2.h,
                        ),
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            "About",
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Curriculcum",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 49.h,
              bottom: 167.v,
            ),
            child: CustomIconButton(
              height: 63.adaptSize,
              width: 63.adaptSize,
              padding: EdgeInsets.all(18.h),
              decoration: IconButtonStyleHelper.outlineBlack,
              alignment: Alignment.bottomRight,
              child: CustomImageView(
                imagePath: ImageConstant.imgGroup6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}