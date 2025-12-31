import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/theme/app_colors.dart';
import '../widget/custom_button.dart';

class ProfileSelection extends StatefulWidget {
  const ProfileSelection({super.key});

  @override
  State<ProfileSelection> createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelection> {
  String selectedProfile = 'parent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Stack buildBody() {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/icons/bg_profile_selection.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.color,
          ),
        ),
        Positioned(
          top: 139.sp,
          right: -56.sp,
          left: -78.sp,
          bottom: 205,
          child: SizedBox(
            width: 574.w,
            height: 612.h,
            child: Image.asset(
              'assets/icons/profile_selection.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    _buildProfileOption(
                      'I am a parent',
                      'assets/icons/parent_profile_selection.svg',
                      'parent',
                    ),
                    SizedBox(height: 20.h),
                    _buildProfileOption(
                      'I am a child',
                      'assets/icons/child_profile_selection.svg',
                      'child',
                    ),
                    SizedBox(height: 40.h),
                    CustomButton(
                      text: 'Choose profile',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileOption(String title, String iconPath, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfile = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 38.82.w,
              height: 64.27.h,
              child: CircleAvatar(
                backgroundColor: AppColors.avtarbackground,
                child: SvgPicture.asset(
                  iconPath,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedProfile,
              onChanged: (String? newValue) {
                setState(() {
                  selectedProfile = newValue!;
                });
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
