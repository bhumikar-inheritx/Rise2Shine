import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../profile_selection/widget/custom_button.dart';

class AddYourChild extends StatefulWidget {
  const AddYourChild({super.key});

  @override
  State<AddYourChild> createState() => _AddYourChildState();
}

class _AddYourChildState extends State<AddYourChild> {
  late TextEditingController _childNameController;
  late TextEditingController _dateOfBirthController;
  late List<TextEditingController> _passcodeControllers;
  late List<FocusNode> _passcodeFocusNodes;

  int _selectedAvatarIndex = 0;
  String? _childNameError;
  String? _dateOfBirthError;
  String? _passcodeError;

  final List<String> _avatars = ['👦', '👧', '🧒', '👶', '🧑', '👨'];

  @override
  void initState() {
    super.initState();
    _childNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _passcodeControllers = List.generate(4, (index) => TextEditingController());
    _passcodeFocusNodes = List.generate(4, (index) => FocusNode());
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _dateOfBirthController.dispose();
    for (var controller in _passcodeControllers) {
      controller.dispose();
    }
    for (var focusNode in _passcodeFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onAddChild() {
    // Validation and navigation logic
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
              Center(
                child: Container(
                  width: 376.w,
                  height: 551.h,
                  margin: EdgeInsets.only(
                      top: 203.h, left: 32.w, right: 32.w, bottom: 20.h),
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTitle(),
                        SizedBox(height: 24.h),
                        _buildFormFields(),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: TextConstants.addChild,
                          width: 312.w,
                          height: 54.h,
                          fontSize: 16.sp,
                          onPressed: _onAddChild,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 311.w,
      height: 36.h,
      child: Text(
        TextConstants.addYourChild,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return SizedBox(
      width: 312.w,
      height: 349.h,
      child: Column(
        children: [
          _buildAvatarSelection(),
          SizedBox(height: 12.h),
          _buildChildNameField(),
          SizedBox(height: 12.h),
          _buildDateOfBirthField(),
          SizedBox(height: 12.h),
          _buildPasscodeField(),
        ],
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return SizedBox(
      width: 312.w,
      height: 76.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.chooseAvatar,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIndex = index;
                    });
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: _selectedAvatarIndex == index
                          ? AppColors.primaryColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: _selectedAvatarIndex == index
                            ? AppColors.primaryColor
                            : Colors.grey,
                        width: 2.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _avatars[index],
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildNameField() {
    return SizedBox(
      width: 312.w,
      height: 79.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.childName,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: TextField(
              controller: _childNameController,
              decoration: InputDecoration(
                hintText: TextConstants.enterChildName,
                hintStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                  height: 1.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide:
                      BorderSide(width: 1.w, color: AppColors.textLight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return SizedBox(
      width: 312.w,
      height: 79.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.dateOfBirth,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: TextField(
              controller: _dateOfBirthController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _dateOfBirthController.text =
                      '${date.day}/${date.month}/${date.year}';
                }
              },
              decoration: InputDecoration(
                hintText: TextConstants.selectDateOfBirth,
                hintStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                  height: 1.5,
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide:
                      BorderSide(width: 1.w, color: AppColors.textLight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasscodeField() {
    return SizedBox(
      width: 312.w,
      height: 79.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.setChildPasscode,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Container(
                  width: 72.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.w, color: AppColors.textLight),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: TextField(
                    controller: _passcodeControllers[index],
                    focusNode: _passcodeFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      hintText: '○',
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _passcodeFocusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _passcodeFocusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
