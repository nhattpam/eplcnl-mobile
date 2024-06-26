import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/data/models/courses.dart';
import 'package:meowlish/data/models/tutors.dart';
import 'package:meowlish/network/network.dart';
import 'package:meowlish/presentation/single_mentor_details_page/single_mentor_details_page.dart';
import 'package:meowlish/presentation/single_mentor_details_rating_page/single_mentor_details_rating_page.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:meowlish/widgets/custom_outlined_button.dart';

class SingleMentorDetailsRatingTabContainerScreen extends StatefulWidget {
   final String tutorID;
  const SingleMentorDetailsRatingTabContainerScreen({Key? key, required this.tutorID})
      : super(
          key: key,
        );

  @override
  SingleMentorDetailsRatingTabContainerScreenState createState() =>
      SingleMentorDetailsRatingTabContainerScreenState();
}

class SingleMentorDetailsRatingTabContainerScreenState
    extends State<SingleMentorDetailsRatingTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  late Tutor chosenTutor = Tutor();
  late List<Course> _chosenTutor = [];

  @override
  void initState() {
    super.initState();
    loadTutorByTutorID();
    loadCourseByTutorId();
    tabviewController = TabController(length: 2, vsync: this);
  }
  void loadTutorByTutorID() async {
    try {
      final tutor = await Network.getTutorByTutorID(widget.tutorID);
      setState(() {
        chosenTutor = tutor;
      });
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }
  void loadCourseByTutorId() async {
    try {
      final tutors = await Network.getCourseByTutorId(widget.tutorID);
      setState(() {
        _chosenTutor = tutors;
      });
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          toolbarHeight: 65,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 300,
              height: 100, // Add margin
              child: Text(
                'Tutor',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              height: SizeUtils.height * 0.8,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: AppDecoration.fillYellow,
                      child: _buildUserProfileSection(context),
                    ),
                  ),
                  _buildCourseSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfileSection(BuildContext context) {
    String? tutorImageUrl = chosenTutor.account?.imageUrl;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 34.h,
        vertical: 30.v,
      ),
      decoration: AppDecoration.outlineBlack9003,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgArrowDownBlueGray900,
            height: 20.v,
            width: 26.h,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 1.h),
          ),
          SizedBox(height: 22.v),
          Container(
            height: 120.adaptSize,
            width: 120.adaptSize,
            child: tutorImageUrl != null && tutorImageUrl.isNotEmpty
                ? Image.network(
              tutorImageUrl,
              fit: BoxFit.cover,
            )
                : Center(child: Container(child: CircularProgressIndicator())), // Placeholder widget when tutorImageUrl is empty or null
          ),
          SizedBox(height: 8.v),
          Text(
            chosenTutor.account?.fullName ?? '',
            style: theme.textTheme.titleLarge,
          ),
          Text(
            chosenTutor.account?.email ?? '',
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 8.v),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      _chosenTutor.length.toString(),
                      style: CustomTextStyles.titleMedium17,
                    ),
                    Text(
                      "Courses",
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     Text(
                //       "15800",
                //       style: CustomTextStyles.titleMedium17,
                //     ),
                //     Text(
                //       "Students",
                //       style: theme.textTheme.labelLarge,
                //     ),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Text(
                //       "8750",
                //       style: CustomTextStyles.titleMedium17,
                //     ),
                //     SizedBox(height: 1.v),
                //     Text(
                //       "Ratings",
                //       style: theme.textTheme.labelLarge,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  height: 60.v,
                  text: "Follow",
                  margin: EdgeInsets.only(right: 10.h),
                  buttonStyle: CustomButtonStyles.outlineBlueGray,
                  buttonTextStyle: CustomTextStyles.titleMedium18,
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  text: "Message",
                  margin: EdgeInsets.only(left: 10.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCourseSection(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 34.h),
        decoration: AppDecoration.outlineBlack.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 291.h,
              margin: EdgeInsets.symmetric(horizontal: 34.h),
              child: Text(
                "Sed quanta s alias nunc tantum possitne tanta Nec vero sum nescius esse utilitatem in historia non modo voluptatem.",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.labelLargeGray50001,
              ),
            ),
            SizedBox(height: 14.v),
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
                  color: appTheme.orange5001,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      "Courses",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Reviews",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 323.v,
              child: TabBarView(
                controller: tabviewController,
                children: [
                  SingleMentorDetailsPage(tutorId: widget.tutorID),
                  SingleMentorDetailsRatingPage(tutorId: widget.tutorID),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
