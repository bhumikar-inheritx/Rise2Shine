import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../add_child/view/add_your_child.dart';
import '../widget/custom_bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

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
        backgroundColor: AppColors.textWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            TextConstants.addChilds,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 311.w,
                        height: 355.h,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.asset(
                                AssetConstants.homePageFamily,
                                width: 300.w,
                                height: 238.h,
                              ),
                              SizedBox(height: 8.h),
                              CustomButton(
                                width: 213.w,
                                text: TextConstants.addChild,
                                fontSize: 16.sp,
                                onPressed: () {
                                  _showAddChildBottomSheet(context);
                                },
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                TextConstants.homeContent,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: AppColors.textSecondary,
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
              CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
