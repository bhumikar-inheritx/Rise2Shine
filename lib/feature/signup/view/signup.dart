import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../profile_selection/widget/custom_button.dart';
import '../widget/signup_container.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.primaryColor,
            child: SvgPicture.asset(
              AssetConstants.bgSignupOptions,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SignupContainer(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
                child: _buildInputField(
                    'Full name', _fullNameController, 'Enter full name'),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                ),
                child: _buildInputField(
                    'Phone number', _phoneController, 'Enter phone number'),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Submit',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, String hint) {
    return Container(
      width: 312.w,
      height: 79.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              // height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: 312.w,
            height: 51.h,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                // contentPadding: EdgeInsets.symmetric(
                //   horizontal: 16.w,
                //   vertical: 12.h,
                // ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(width: 1.w, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
