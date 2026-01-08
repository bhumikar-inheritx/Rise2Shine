import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/custom_text_field.dart';

class AddYourChild extends StatefulWidget {
  final bool isBottomSheet;

  const AddYourChild({super.key, this.isBottomSheet = false});

  @override
  State<AddYourChild> createState() => _AddYourChildState();
}

class _AddYourChildState extends State<AddYourChild> {
  late TextEditingController _childNameController;
  late TextEditingController _dateOfBirthController;
  final TextEditingController _passcodeController = TextEditingController();

  DateTime? _selectedDate;
  int? _selectedAvatarIndex;
  String? _childNameError;
  String? _dateOfBirthError;
  String? _avatarError;
  String? _passcodeError;

  bool get _hasValidationErrors =>
      _childNameError != null ||
      _dateOfBirthError != null ||
      _avatarError != null ||
      _passcodeError != null;

  final List<String> _avatars = ['👦', '👧', '🧒', '👶', '🧑', '👨'];

  @override
  void initState() {
    super.initState();
    _childNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _dateOfBirthController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  bool _validateAndSubmit() {
    setState(() {
      _childNameError = _childNameController.text.isEmpty
          ? TextConstants.fullNameRequired
          : ValidationUtils.validateFullName(_childNameController.text);

      _dateOfBirthError = _dateOfBirthController.text.isEmpty
          ? 'Date of birth is required'
          : null;

      _avatarError =
          _selectedAvatarIndex == null ? 'Please select an avatar' : null;

      final passcode = _passcodeController.text;
      _passcodeError =
          passcode.length != 4 ? 'Passcode must be 4 digits' : null;
    });

    return !_hasValidationErrors;
  }

  void _onAddChild() {
    if (_validateAndSubmit()) {
      if (widget.isBottomSheet) {
        Navigator.pop(context);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBottomSheet) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAvatarSelection(),
                      SizedBox(height: 16.h),
                      _buildChildNameField(),
                      SizedBox(height: 16.h),
                      _buildDateOfBirthField(),
                      SizedBox(height: 16.h),
                      _buildPasscodeField(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        fontSize: 16.sp,
                        isOutlined: true,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        text: TextConstants.addChild,
                        fontSize: 16.sp,
                        onPressed: _onAddChild,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
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
        widget.isBottomSheet
            ? TextConstants.addChild
            : TextConstants.addYourChild,
        textAlign: widget.isBottomSheet ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
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
    return Column(
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
        SizedBox(
          height: 44.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatarIndex = index;
                    _avatarError = null;
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
                          : (_avatarError != null ? Colors.red : Colors.grey),
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
        if (_avatarError != null) SizedBox(height: 4.h),
        if (_avatarError != null)
          Text(
            _avatarError!,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildChildNameField() {
    return Column(
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
        CustomTextField(
          controller: _childNameController,
          hintText: TextConstants.enterChildName,
          errorText: _childNameError,
          width: widget.isBottomSheet ? 392.w : null,
          onChanged: (value) {
            if (_childNameError != null) {
              setState(() {
                _childNameError = null;
              });
            }
          },
        ),
        if (_childNameError != null) SizedBox(height: 4.h),
        if (_childNameError != null)
          Text(
            _childNameError!,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
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
        CustomTextField(
          controller: _dateOfBirthController,
          hintText: TextConstants.selectDateOfBirth,
          errorText: _dateOfBirthError,
          width: widget.isBottomSheet ? 392.w : null,
          readOnly: true,
          suffixIcon: Icon(
            Icons.calendar_today,
            color: AppColors.primaryColor,
            size: 20.sp,
          ),
          onTap: () async {
            DateTime? initialDate;
            if (_dateOfBirthController.text.isNotEmpty) {
              // Parse existing date from controller
              List<String> parts = _dateOfBirthController.text.split('/');
              if (parts.length == 3) {
                initialDate = DateTime(
                  int.parse(parts[2]), // year
                  int.parse(parts[1]), // month
                  int.parse(parts[0]), // day
                );
              }
            }
            
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CustomDatePicker(
                initialDate: initialDate,
                onDateSelected: (date) {
                  _selectedDate = date;
                  _dateOfBirthController.text =
                      '${date.day}/${date.month}/${date.year}';
                  setState(() {
                    _dateOfBirthError = null;
                  });
                },
              ),
            );
          },
        ),
        if (_dateOfBirthError != null) SizedBox(height: 4.h),
        if (_dateOfBirthError != null)
          Text(
            _dateOfBirthError!,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildPasscodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isBottomSheet
              ? 'Set passcode'
              : TextConstants.setChildPasscode,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Pinput(
          controller: _passcodeController,
          length: 4,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          defaultPinTheme: PinTheme(
            width: widget.isBottomSheet ? 92.w : 72.w,
            height: widget.isBottomSheet ? 48.h : 52.h,
            textStyle: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.w,
                color: _passcodeError != null
                    ? Colors.red
                    : AppColors.inputTextBorder,
              ),
              borderRadius:
                  BorderRadius.circular(widget.isBottomSheet ? 100.r : 26.r),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: widget.isBottomSheet ? 92.w : 72.w,
            height: widget.isBottomSheet ? 48.h : 52.h,
            textStyle: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: AppColors.primaryColor),
              borderRadius:
                  BorderRadius.circular(widget.isBottomSheet ? 100.r : 26.r),
            ),
          ),
          onChanged: (value) {
            if (_passcodeError != null) {
              setState(() {
                _passcodeError = null;
              });
            }
          },
        ),
        if (_passcodeError != null) SizedBox(height: 4.h),
        if (_passcodeError != null)
          Text(
            _passcodeError!,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
