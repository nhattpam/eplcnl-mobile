import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/data/models/categories.dart';
import 'package:meowlish/data/models/courses.dart';
import 'package:meowlish/network/network.dart';
import 'package:meowlish/presentation/home_page/home_page.dart';
import 'package:meowlish/presentation/indox_chats_page/indox_chats_page.dart';
import 'package:meowlish/presentation/my_course_completed_page/my_course_completed_page.dart';
import 'package:meowlish/presentation/profiles_page/profiles_page.dart';
import 'package:meowlish/presentation/transactions_page/transactions_page.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:meowlish/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class CategoryMentorsListScreen extends StatefulWidget {
  final categoryId;

  const CategoryMentorsListScreen({super.key, this.categoryId});

  @override
  State<CategoryMentorsListScreen> createState() =>
      _CategoryMentorsListScreenState();
}

class _CategoryMentorsListScreenState extends State<CategoryMentorsListScreen> {
  TextEditingController searchController = TextEditingController();
  late List<Course> listCourse = [];
  late List<Course> chosenCategory = [];
  late Category? _category = Category();
  int _currentIndex = 0;

  int found = 0;

  @override
  void initState() {
    super.initState();
    loadCourse();
    loadCategoryByCategoryId();
    loadCourseByCategory();
  }

  void loadCourse() async {
    List<Course> loadedCourse = await Network.getCourse();
    setState(() {
      listCourse = loadedCourse;
    });
  }
  void loadCourseByCategory() async {
    try {
      final courses = await Network.getCourseByCategoryID(widget.categoryId);
      setState(() {
        chosenCategory = courses;
      });
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  void loadCategoryByCategoryId() async {
    try {
      final category = await Network.getCategoryByCategoryId(widget.categoryId);
      setState(() {
        _category = category;
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
      resizeToAvoidBottomInset: false,
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
              'Online Courses',
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
          child: Column(children: [
            SizedBox(height: 69.v),
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 31.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 2.h),
                                  child: CustomSearchView(
                                    controller: searchController,
                                    hintText: "Search for",
                                    context: context,
                                  )),
                              SizedBox(height: 25.v),
                              _buildCategory(context),
                              SizedBox(height: 15.v),
                              _buildHEADING(context),
                              SizedBox(height: 19.v),
                              buildResults(context)
                            ]))))
          ])),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyCourseCompletedPage()),
                );
              }
              if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => IndoxChatsPage()),
                );
              }
              if (index == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TransactionsPage()),
                );
              }
              if (index == 4) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilesPage()),
                );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'My Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: 'Transaction',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Color(0xbbff9300),
            unselectedItemColor: Color(0xffff9300),
          ),

        ));
  }

  /// Section Widget
  Widget _buildCategory(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2.h),
        decoration: AppDecoration.outlineBlack9002
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder22),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: CustomElevatedButton(
                  height: 48.v,
                  text: "Courses",
                  margin: EdgeInsets.only(right: 10.h),
                  buttonStyle: CustomButtonStyles.fillOnPrimaryContainerTL24,
                  buttonTextStyle:
                      CustomTextStyles.titleSmallBluegray900ExtraBold15,
                  onPressed: () {
                    onTapCourses(context);
                  })),
          Expanded(
              child: CustomElevatedButton(
                  height: 48.v,
                  text: "Tutors",
                  margin: EdgeInsets.only(left: 10.h),
                  buttonStyle: CustomButtonStyles.fillPrimaryTL24,
                  buttonTextStyle:
                      CustomTextStyles.titleSmallOnPrimaryContainer))
        ]));
  }

  /// Section Widget
  Widget _buildHEADING(BuildContext context) {
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
                    text: _category?.description ?? '',
                    style: CustomTextStyles.titleSmallJostffff9300),
                TextSpan(
                    text: "”", style: CustomTextStyles.titleSmallJostff202244)
              ]),
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(top: 7.v),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        chosenCategory.where((element) => element.isActive == true).length.toString() +
                            " Founds".toUpperCase(),
                        style: CustomTextStyles.labelLargePrimary),
                  ]))
        ]);
  }

  Widget buildResults(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 2.h),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 9.5.v),
                  child: SizedBox(
                      width: 360.h,
                      child: Divider(
                          height: 1.v,
                          thickness: 1.v,
                          color: appTheme.blue50)));
            },
            itemCount: chosenCategory.length ,
            itemBuilder: (context, index) {
              String image = '${chosenCategory?[index].tutor?.account?.imageUrl}';
              String name = '${chosenCategory?[index].tutor?.account?.fullName}';
              String email = '${chosenCategory?[index].tutor?.account?.email}';
              bool isActive = chosenCategory?[index]?.isActive ?? false;
              return isActive
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 66.adaptSize,
                    width: 66.adaptSize,
                    decoration: BoxDecoration(
                      color: appTheme.black900,
                      borderRadius: BorderRadius.circular(
                        33.h,
                      ),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 11.h,
                      top: 9.v,
                      bottom: 12.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 160,
                          ),
                          child: Text(
                            name,
                            style: CustomTextStyles.titleMedium17,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 2.v),
                        Text(
                          email,
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Container();
            }));
  }

  onTapCourses(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           CoursesListScreen(categoryId: widget.categoryId)),
    // );
    Navigator.pop(context);
  }
}
