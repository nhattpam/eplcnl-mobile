import '../courses_list_screen/widgets/productcard1_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/presentation/home_page/home_page.dart';
import 'package:meowlish/presentation/indox_calls_page/indox_calls_page.dart';
import 'package:meowlish/presentation/my_course_completed_page/my_course_completed_page.dart';
import 'package:meowlish/presentation/profiles_page/profiles_page.dart';
import 'package:meowlish/presentation/transactions_page/transactions_page.dart';
import 'package:meowlish/widgets/custom_bottom_bar.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:meowlish/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class CoursesListScreen extends StatelessWidget {
  CoursesListScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 34.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 69.v),
                      Row(children: [
                        CustomImageView(
                            imagePath: ImageConstant.imgArrowDownBlueGray900,
                            height: 20.v,
                            width: 26.h,
                            margin: EdgeInsets.only(top: 5.v, bottom: 4.v)),
                        Padding(
                            padding: EdgeInsets.only(left: 11.h),
                            child: Text("Online Courses",
                                style: theme.textTheme.titleLarge))
                      ]),
                      SizedBox(height: 16.v),
                      CustomSearchView(
                          controller: searchController,
                          hintText: "Graphic Design"),
                      SizedBox(height: 25.v),
                      _buildCategory(context),
                      SizedBox(height: 15.v),
                      _buildHeading(context),
                      SizedBox(height: 19.v),
                      _buildProductCard(context)
                    ])),
            bottomNavigationBar: _buildBottomBar(context)));
  }

  /// Section Widget
  Widget _buildCategory(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: CustomElevatedButton(
              height: 48.v,
              text: "Courses",
              margin: EdgeInsets.only(right: 10.h),
              buttonStyle: CustomButtonStyles.fillPrimaryTL24,
              buttonTextStyle: CustomTextStyles.titleSmallOnPrimaryContainer)),
      Expanded(
          child: CustomElevatedButton(
              height: 48.v,
              text: "Tutors",
              margin: EdgeInsets.only(left: 10.h),
              buttonStyle: CustomButtonStyles.fillOnPrimaryContainerTL24,
              buttonTextStyle:
                  CustomTextStyles.titleSmallBluegray900ExtraBold15,
              onPressed: () {
                onTapTutors(context);
              }))
    ]);
  }

  /// Section Widget
  Widget _buildHeading(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Result for “",
                    style: CustomTextStyles.titleSmallJostff202244),
                TextSpan(
                    text: "Graphic Design",
                    style: CustomTextStyles.titleSmallJostffff9300),
                TextSpan(
                    text: "”", style: CustomTextStyles.titleSmallJostff202244)
              ]),
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(bottom: 4.v),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2480 Founds".toUpperCase(),
                        style: CustomTextStyles.labelLargePrimary),
                    CustomImageView(
                        imagePath: ImageConstant.imgArrowRightPrimary,
                        height: 10.v,
                        width: 5.h,
                        margin:
                            EdgeInsets.only(left: 10.h, top: 2.v, bottom: 3.v))
                  ]))
        ]);
  }

  /// Section Widget
  Widget _buildProductCard(BuildContext context) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 16.v);
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return Productcard1ItemWidget(onTapProductCard: () {
            onTapProductCard(context);
          });
        });
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
    });
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homePage;
      case BottomBarEnum.Mycourses:
        return AppRoutes.myCourseCompletedPage;
      case BottomBarEnum.Indox:
        return AppRoutes.indoxCallsPage;
      case BottomBarEnum.Transaction:
        return AppRoutes.transactionsPage;
      case BottomBarEnum.Profile:
        return AppRoutes.profilesPage;
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homePage:
        return HomePage();
      case AppRoutes.myCourseCompletedPage:
        return MyCourseCompletedPage();
      case AppRoutes.indoxCallsPage:
        return IndoxCallsPage();
      case AppRoutes.transactionsPage:
        return TransactionsPage();
      case AppRoutes.profilesPage:
        return ProfilesPage();
      default:
        return DefaultWidget();
    }
  }

  /// Navigates to the singleCourseDetailsTabContainerScreen when the action is triggered.
  onTapProductCard(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.singleCourseDetailsTabContainerScreen);
  }

  /// Navigates to the mentorsListScreen when the action is triggered.
  onTapTutors(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mentorsListScreen);
  }
}