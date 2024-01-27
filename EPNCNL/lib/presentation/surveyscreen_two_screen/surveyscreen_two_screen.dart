import 'package:flutter/material.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:meowlish/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class SurveyscreenTwoScreen extends StatefulWidget {
  const SurveyscreenTwoScreen({Key? key}) : super(key: key);


  @override
  SurveyscreenTwoScreenState createState() => SurveyscreenTwoScreenState();
}
class SurveyscreenTwoScreenState extends State<SurveyscreenTwoScreen> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  width: 300,
                  height: 30, // Add margin
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(
                      color: Colors.black, // Set border color
                      width: 0.0, // Set border width
                    ),
                    borderRadius:
                    BorderRadius.circular(20.0), // Set border radius
                  ),
                  // Set the background color for the text
                  // child: Text(
                  //   'Sign Up',
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 25,
                  //     fontFamily: 'Inter',
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 19.h, vertical: 45.v),
                  child: Column(children: [
                    Text("What are your level ?",
                        style: CustomTextStyles.headlineSmallJuaBlack900),
                    SizedBox(height: 72.v),
                    _buildAbsoluteNew(context),
                  ])),
            ),
            bottomNavigationBar: _buildNext(context)));
  }


  /// Section Widget
  Widget _buildAbsoluteNew(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 11.h, right: 10.h),
        child: ElevatedButton(
          onPressed: () {
            // Handle button press action here
            setState(() {
              isClicked = !isClicked;
            });
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.grey, width: 1.5),
              backgroundColor: isClicked
                  ? Colors.orange
                  : Colors.white // Set your button color
          ),
          child: Text(
            "I am absolute new",
            maxLines: 1,
            style: CustomTextStyles.headlineSmallJuaBlack900,
          ), // Set your button text
        ));

  }

  /// Section Widget
  Widget _buildNext(BuildContext context) {
    return CustomElevatedButton(
        height: 54.v,
        text: "Next",
        margin: EdgeInsets.only(left: 29.h, right: 29.h, bottom: 30.v),
        buttonStyle: CustomButtonStyles.fillPrimary,
        buttonTextStyle: CustomTextStyles.headlineSmallJuaOnPrimaryContainer,
        onPressed: () {
          onTapNext(context);
        });
  }

  /// Navigates to the surveyscreenThreeScreen when the action is triggered.
  onTapNext(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.surveyscreenThreeScreen);
  }
}
