import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider_structure/core/constants/app_constants.dart';
import 'package:provider_structure/feature/parent_task/page/parent_tasks_page.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../add_child/view/add_your_child.dart';
import '../../../core/widgets/custom_bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SizedBox(),
    ParentTasksPage(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  String _getPageTitle() => switch (_selectedIndex) { 0 => TextConstants.home, 1 => TextConstants.task, 2 => TextConstants.rewards, 3 => TextConstants.stats, 4 => TextConstants.more, _ => "" };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddChildBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddYourChild(isBottomSheet: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _getPageTitle(),
            style: TextStyle(
              fontFamily: AppConstants.nunitoFont,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
              // Stack(
              //   children: [
              //     Center(
              //       child: Container(
              //         width: 311.w,
              //         height: 355.h,
              //         child: SingleChildScrollView(
              //           child: Column(
              //             children: [
              //               Image.asset(
              //                 AssetConstants.homePageFamily,
              //                 width: 300.w,
              //                 height: 238.h,
              //               ),
              //               SizedBox(height: 8.h),
              //               CustomButton(
              //                 width: 213.w,
              //                 text: TextConstants.addChild,
              //                 fontSize: 16.sp,
              //                 onPressed: () {
              //                   _showAddChildBottomSheet(context);
              //                 },
              //               ),
              //               SizedBox(height: 8.h),
              //               Text(
              //                 TextConstants.homeContent,
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   fontFamily: 'Nunito',
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 16.sp,
              //                   color: AppColors.textSecondary,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomNavigationBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  floatingAction: _buildFloatingActionWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionWidget() => switch (_selectedIndex) {
        1 => CustomButton(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            text: TextConstants.addNewTask,
          ),
        _ => null
      };
}
