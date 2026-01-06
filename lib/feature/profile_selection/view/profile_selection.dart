import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
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
          AssetConstants.bgProfileSelection,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.color,
          ),
        ),
        Positioned(
          top: 139.h,
          left: -78.w,
          child: Image.asset(
            AssetConstants.profileSelection,
            width: 574.w,
            height: 612.h,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 604.h,
          left: 0,
          right: 0,
          // bottom: 0,
          child: Container(
            width: 440.w,
            height: 352.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildProfileOption(
                  TextConstants.iAmAParent,
                  AssetConstants.parentProfileSelection,
                  'parent',
                ),
                SizedBox(width: 20.w),
                _buildProfileOption(
                  TextConstants.iAmAChild,
                  AssetConstants.childProfileSelection,
                  'child',
                ),
                SizedBox(height: 44.h),
                CustomButton(
                  text: TextConstants.chooseProfile,
                  height: 54.h,
                  width: 367.w,
                  fontSize: 20.sp,
                  onPressed: () {
                    if (selectedProfile == 'parent') {
                      Navigator.pushNamed(context, '/signup');
                    }
                  },
                ),
              ],
            ),
          ),
        )
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
      child: Padding(
        padding: EdgeInsets.only(
          top: 32.sp,
          right: 32.sp,
          left: 32.sp,
        ),
        child: SizedBox(
          width: 367.w,
          height: 70.h,
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  color: AppColors.avtarbackground,
                  child: SvgPicture.asset(
                    iconPath,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Unbounded',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 28.w,
                height: 28.h,
                child: Radio<String>(
                  value: value,
                  groupValue: selectedProfile,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProfile = newValue!;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
