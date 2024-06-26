import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:meowlish/core/app_export.dart';
import 'package:meowlish/core/utils/skeleton.dart';
import 'package:meowlish/data/models/assignmentattemps.dart';
import 'package:meowlish/data/models/assignments.dart';
import 'package:meowlish/network/network.dart';
import 'package:meowlish/presentation/edit_assignment_screen/edit_assignment_screen.dart';
import 'package:meowlish/presentation/home_page/home_page.dart';
import 'package:meowlish/presentation/home_page/search/search.dart';
import 'package:meowlish/presentation/indox_chats_page/indox_chats_page.dart';
import 'package:meowlish/presentation/my_course_completed_page/my_course_completed_page.dart';
import 'package:meowlish/presentation/profiles_page/profiles_page.dart';
import 'package:meowlish/presentation/transactions_page/transactions_page.dart';
import 'package:meowlish/presentation/view_all_assignment_attemp/view_all_assignment_attemp.dart';
import 'package:meowlish/session/session.dart';
import 'package:meowlish/widgets/custom_elevated_button.dart';
import 'package:video_player/video_player.dart';

class ReviewAssignment extends StatefulWidget {
  final String assignmentID;
  final bool isOnlineClass;

  const ReviewAssignment(
      {super.key, required this.assignmentID, required this.isOnlineClass});

  @override
  State<ReviewAssignment> createState() => _ReviewAssignmentState();
}

class _ReviewAssignmentState extends State<ReviewAssignment> {
  TextEditingController additionalInfoController = TextEditingController();
  late Assignment chosenAssignment = Assignment();
  Map<String, List<AssignmentAttempt>> moduleUndoAssignmentAttempt = {};
  Map<String, List<AssignmentAttempt>> moduleUngradeAssignmentAttempt = {};
  int _currentPage = 1;
  int _itemsPerPage = 5; // Define the number of items per page
  String lid = '';
  List<AssignmentAttempt> _paginatedAssignmentAttempt = [];
  int _currentIndex = 0;
  late bool isLoadingAssignmentAttempt;
  final List<String> listPoint = [
    '2',
    '4',
    '6',
    '8',
    '10',
  ];
  late Map<String, String> point;
  late VideoPlayerController _videoPlayerController;
  late VideoPlayerController _videoQuestionPlayerController;
  late ChewieAudioController _chewieController;
  late ChewieAudioController _chewieQuestionController;
  late List<VideoPlayerController> _videoPlayerControllers = [];
  late List<ChewieAudioController> _chewieControllers = [];
  bool isLoading = true;
  bool isLoadingQuestion = true;
  bool _isLoading = true;

  @override
  void initState() {
    point = {};
    isLoadingAssignmentAttempt = true;
    super.initState();
    loadAssignmentByAssignmentId();
    loadAssignmentAttemptByLearnerId(widget.assignmentID);
    loadAssignmentAttemptByAssignmentId(widget.assignmentID);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _videoQuestionPlayerController.dispose();
    _chewieController.dispose();
    _chewieQuestionController.dispose();
    for (var controller in _videoPlayerControllers) {
      controller.dispose();
    }
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideoPlayer(String audioUrl) async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(audioUrl));
    await _videoPlayerController.initialize();
    if (mounted) {
      setState(() {
        if (_videoPlayerController.value.isInitialized) {
          _chewieController = ChewieAudioController(
            autoInitialize: true,
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: true,
            allowMuting: true,
          );
        }
        isLoading = false;
      });
    }
  }

  Future<void> _initializeVideoPlayerQuestion(String audioUrl) async {
    _videoQuestionPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(audioUrl));
    await _videoQuestionPlayerController.initialize();
    if (mounted) {
      setState(() {
        if (_videoQuestionPlayerController.value.isInitialized) {
          _chewieQuestionController = ChewieAudioController(
            autoInitialize: true,
            videoPlayerController: _videoQuestionPlayerController,
            autoPlay: false,
            looping: true,
            allowMuting: true,
          );
        }
        isLoadingQuestion = false;
      });
    }
  }

  Future<void> loadAssignmentByAssignmentId() async {
    try {
      final assignment =
          await Network.getAssignmentByAssignmentId(widget.assignmentID);
      if (assignment?.isActive ?? true) {
        setState(() {
          chosenAssignment = assignment;
        });
        _initializeVideoPlayerQuestion(chosenAssignment.questionAudioUrl.toString());
      } else {
        // Handle the case where the loaded lesson is not active
        // For example, show a message to the user or perform another action
        print('The loaded lesson is not active');
      }
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  Future<void> loadAssignmentAttemptByLearnerId(String assignmentId) async {
    final lid = SessionManager().getLearnerId();
    try {
      final assignment = await FetchCourseList.getPeerReviewByLearnerId(
          assignmentId: assignmentId, query: lid);
      setState(() {
        moduleUndoAssignmentAttempt[assignmentId] = assignment;
        // Add more print statements for other properties if needed
      });
      if (moduleUndoAssignmentAttempt[assignmentId]?.first.answerAudioUrl !=
          '') {
        _initializeVideoPlayer((moduleUndoAssignmentAttempt[assignmentId]?.first.answerAudioUrl).toString());
        print((moduleUndoAssignmentAttempt[assignmentId]?.first.answerAudioUrl));

      }
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  Future<void> loadAssignmentAttemptByAssignmentId(String assignmentId) async {
    try {
      final assignment =
          await Network.getAssignmentAttemptByAssignmentIdAndLearnerId(
        assignmentId,
      );

      setState(() {
        moduleUngradeAssignmentAttempt[assignmentId] = assignment;
        _loadPage(_currentPage);
        // Add more print statements for other properties if needed
      });
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  void _loadPage(int page) {
    // Sort feedback list by the newest date
    moduleUngradeAssignmentAttempt[widget.assignmentID]!.sort((a, b) =>
        DateTime.parse(b.attemptedDate.toString())
            .compareTo(DateTime.parse(a.attemptedDate.toString())));

    int startIndex = (page - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (startIndex <
        moduleUngradeAssignmentAttempt[widget.assignmentID]!.length) {
      // Ensure endIndex does not exceed the length of the list
      _paginatedAssignmentAttempt =
          moduleUngradeAssignmentAttempt[widget.assignmentID]!.sublist(
              startIndex,
              endIndex.clamp(0,
                  moduleUngradeAssignmentAttempt[widget.assignmentID]!.length));
      // isLoadingFeedback = false;
      isLoadingAssignmentAttempt = false;
    }
    for (var url in _paginatedAssignmentAttempt) {
      final videoController = VideoPlayerController.networkUrl(Uri.parse(url.answerAudioUrl.toString()));
      final chewieController = ChewieAudioController(
        videoPlayerController: videoController,
        autoInitialize: true,
        autoPlay: false,
        looping: true,
        allowMuting: true,
      );
      _videoPlayerControllers.add(videoController);
      _chewieControllers.add(chewieController);
      _isLoading = false;
    }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  void _showMultiSelect(String attemptId) async {
    final List<String>? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReportPopUp(attemptId: attemptId);
        });
  }

  String? validateAssignment(String? assignment) {
    if (assignment == null || assignment.isEmpty) {
      return 'Assignment cannot be empty';
    }
    return null; // Return null if the password is valid.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          toolbarHeight: 65,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 300,
              height: 100, // Add margin
              child: Text(
                'Assignment',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 33.h,
              vertical: 69.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Ensure children stretch horizontally
              children: [
                if (chosenAssignment.questionText != null &&
                    chosenAssignment.questionText!.isNotEmpty)
                  Center(
                    child: Html(
                      data: chosenAssignment.questionText.toString(),
                      style: {
                        "body": Style(
                          textAlign: TextAlign.center,
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.w400,
                          lineHeight: LineHeight(1.2125),
                          color: Color(0xff6c6363),
                        ),
                      },
                    ),
                  ),
                if (chosenAssignment.questionAudioUrl != null &&
                    chosenAssignment.questionAudioUrl!.isNotEmpty)
                  isLoadingQuestion
                      ? Center(
                    child: Skeleton(
                      width: 400,
                      height: 40,
                    ),
                  )
                      : ChewieAudio(controller: _chewieQuestionController),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Score: ",
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontSize: 15.fSize,
                            fontWeight: FontWeight.w800,
                          )),
                      Text(
                        (moduleUndoAssignmentAttempt[widget.assignmentID]
                                    ?.first
                                    ?.totalGrade ??
                                0)
                            .toString(),
                        style: CustomTextStyles.titleSmallPrimary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 73.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Your Answer",
                      style: CustomTextStyles.titleMedium18,
                    ),
                  ),
                ),
                SizedBox(height: 24.v),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 244,
                  ),
                  child: widget.isOnlineClass
                      ? SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 280),
                            child: Column(
                              children: [
                                Html(
                                  data:moduleUndoAssignmentAttempt[
                                  widget.assignmentID]
                                      ?.first
                                      ?.answerText ??
                                      '',
                                  // style: {
                                  //   "body": Style(
                                  //       fontWeight: FontWeight.bold, color: Colors.black),
                                  // },
                                ),
                                if (moduleUndoAssignmentAttempt[
                                                widget.assignmentID]
                                            ?.first
                                            ?.answerAudioUrl !=
                                        null &&
                                    moduleUndoAssignmentAttempt[
                                            widget.assignmentID]!
                                        .first
                                        .answerAudioUrl!
                                        .isNotEmpty)
                                  isLoading
                                      ? Center(
                                    child: Skeleton(
                                      width: 400,
                                      height: 40,
                                    ),
                                  )
                                      : ChewieAudio(
                                          controller: _chewieController),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           EditDoingAssignmnetScreen(
                                  //               assignmentID:
                                  //                   widget.assignmentID,
                                  //               cooldownTime: Duration(
                                  //                   minutes: chosenAssignment
                                  //                           ?.deadline ??
                                  //                       0),
                                  //               isOnlineClass: false),
                                  //     ));
                                },
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  decoration:
                                      AppDecoration.outlineBlack9001.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder10,
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon(
                                      //   Icons.edit,
                                      //   size: 20,
                                      //   color: Colors.grey,
                                      // ),
                                      // SizedBox(width: 4.v),
                                      SingleChildScrollView(
                                        child: Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 280),
                                          child: Column(
                                            children: [
                                              Html(
                                                data:moduleUndoAssignmentAttempt[
                                                widget.assignmentID]
                                                    ?.first
                                                    ?.answerText ??
                                                    '',
                                                // style: {
                                                //   "body": Style(
                                                //       fontWeight: FontWeight.bold, color: Colors.black),
                                                // },
                                              ),
                                              if (moduleUndoAssignmentAttempt[
                                              widget.assignmentID]
                                                  ?.first
                                                  ?.answerAudioUrl !=
                                                  null &&
                                                  moduleUndoAssignmentAttempt[
                                                  widget.assignmentID]!
                                                      .first
                                                      .answerAudioUrl!
                                                      .isNotEmpty)
                                                isLoading
                                                    ? Center(
                                                  child: Skeleton(
                                                    width: 400,
                                                    height: 40,
                                                  ),
                                                )
                                                    : ChewieAudio(
                                                    controller: _chewieController),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 24.v),
                if (moduleUngradeAssignmentAttempt[widget.assignmentID]
                        ?.isNotEmpty ??
                    false)
                  widget.isOnlineClass
                      ? Container()
                      : SizedBox(
                          height: SizeUtils.height,
                          width: double.maxFinite,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 34.h,
                                    vertical: 10.v,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SingleChildScrollView(
                                          child:
                                              _buildCourseReviewList(context)),
                                      SizedBox(height: 12),
                                      Divider(),
                                      SizedBox(height: 30.v),
                                      CustomElevatedButton(
                                        onPressed: () async {
                                          for (int index = 0;
                                              index <
                                                  _paginatedAssignmentAttempt
                                                      .length;
                                              index++) {
                                            final attempt =
                                                _paginatedAssignmentAttempt[
                                                    index];
                                            // print("This is"+ index.toString());
                                            await Network.createPeerReview(
                                                assignmentAttemptId:
                                                    attempt.id.toString(),
                                                grade: point[attempt.id]
                                                    .toString());
                                          }
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.scale,
                                            dialogType: DialogType.success,
                                            body: Center(
                                              child: Text(
                                                'Submit Success!!!',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            btnOkOnPress: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                              // if(isSelected == true){
                                              //   nextQuestion();
                                              // }
                                            },
                                          )..show();
                                        },
                                        text: "Submit",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // _buildCategoryList(context),
                              SizedBox(height: 50.v),
                            ],
                          ),
                        )
              ],
            ),
          ),
        ),
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
        selectedFontSize: 12,
        selectedLabelStyle: CustomTextStyles.labelLargeGray700,
        selectedItemColor: Color(0xbbff9300),
        unselectedItemColor: Color(0xffff9300),
      ),
      ),
    );
  }

  Widget _buildCourseReviewList(BuildContext context) {
    return isLoadingAssignmentAttempt
        ? Column(
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (
                  context,
                  index,
                ) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 11.5.v),
                    child: SizedBox(
                      width: 360.h,
                      child: Divider(
                        height: 1.v,
                        thickness: 1.v,
                        color: appTheme.blue50,
                      ),
                    ),
                  );
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 46.adaptSize,
                          width: 46.adaptSize,
                          margin: EdgeInsets.only(
                            top: 3.v,
                            bottom: 65.v,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.black900,
                            borderRadius: BorderRadius.circular(
                              23.h,
                            ),
                          ),
                          child: Skeleton(width: 20)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Skeleton(width: 30),
                                  Skeleton(width: 60),
                                ],
                              ),
                              SizedBox(height: 9.v),
                              Skeleton(width: 244),
                              SizedBox(height: 11.v),
                              Row(
                                children: [
                                  Skeleton(width: 30),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10.h),
                                      child: Skeleton(width: 30)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          )
        : Column(
            children: [
              if (_paginatedAssignmentAttempt.length != 0)
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 11.5.v),
                      child: SizedBox(
                        width: 360.h,
                        child: Divider(
                          height: 1.v,
                          thickness: 1.v,
                          color: appTheme.blue50,
                        ),
                      ),
                    );
                  },
                  itemCount: _paginatedAssignmentAttempt.length,
                  itemBuilder: (context, index) {
                    final attempt = _paginatedAssignmentAttempt[index];
                    if (!point.containsKey(attempt.id)) {
                      point[attempt.id.toString()] =
                          ''; // Set default value to 2
                    }
                    String originalDateString =
                        attempt.attemptedDate.toString();
                    DateTime originalDate =
                        DateTime.parse(originalDateString.split('T')[0]);
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(originalDate);
                    return GestureDetector(
                      onTap: () {
                        _showMultiSelect(attempt.id.toString());
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          attempt.learner?.account?.imageUrl != null &&
                                  attempt.learner!.account!.imageUrl!.isNotEmpty
                              ? Container(
                                  height: 46.adaptSize,
                                  width: 46.adaptSize,
                                  margin: EdgeInsets.only(
                                    top: 3.v,
                                    bottom: 65.v,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appTheme.black900,
                                    borderRadius: BorderRadius.circular(
                                      23.h,
                                    ),
                                  ),
                                  child: Image.network(
                                    attempt.learner!.account!.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Container(
                                      child: CircularProgressIndicator())),
                          // Placeholder widget when feedback.learner.account.imageUrl is empty or null
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        removeAllHtmlTags(attempt
                                                .learner?.account?.fullName ??
                                            ''),
                                        style: CustomTextStyles.titleMedium17,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 9.v),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 244,
                                    ),
                                    margin: EdgeInsets.only(right: 12.h),
                                    child: Text(
                                      removeAllHtmlTags(
                                          attempt.answerText.toString()),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  ),
                                  if (attempt.answerAudioUrl != null &&
                                      attempt.answerAudioUrl!.isNotEmpty)
                                    _isLoading
                                        ? Center(
                                      child: Skeleton(
                                        width: 400,
                                        height: 40,
                                      ),
                                    )
                                        : ChewieAudio(controller: _chewieControllers[index]),
                                  SizedBox(height: 11.v),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.black,
                                        size: 12.v,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.h),
                                        child: Text(
                                          formattedDate,
                                          style: CustomTextStyles
                                              .labelLargeBluegray900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List<Widget>.generate(
                                      listPoint.length,
                                      (index) {
                                        return Row(
                                          children: [
                                            Radio(
                                              value: listPoint[index],
                                              groupValue: point[attempt.id],
                                              // Use pointMap value
                                              onChanged: (value) {
                                                setState(() {
                                                  point[attempt.id.toString()] =
                                                      value.toString();
                                                  print(point[
                                                      attempt.id.toString()]);
                                                });
                                              },
                                            ),
                                            Text(listPoint[index])
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              // Pagination controls
            ],
          );
  }
}
