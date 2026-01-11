import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../provider/auth_provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  String? _fullNameError;
  String? _phoneError;

  bool get _hasValidationErrors =>
      _fullNameError != null || _phoneError != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController(text: "7405152969");
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateAndSubmit() {
    setState(() {
      _fullNameError = _fullNameController.text.isEmpty
          ? TextConstants.fullNameRequired
          : _fullNameController.text.length > 20
              ? 'Full name cannot exceed 20 characters'
              : ValidationUtils.validateFullName(_fullNameController.text);

      _phoneError = _phoneController.text.isEmpty
          ? TextConstants.phoneNumberRequired
          : ValidationUtils.validatePhoneNumber(_phoneController.text);
    });

    return !_hasValidationErrors;
  }

  void _onSubmit() {
    print('📺 UI: Submit button pressed');
    if (_validateAndSubmit()) {
      print('📺 UI: Validation passed, calling AuthProvider');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Combine country code with phone number
      final fullPhoneNumber =
          '${TextConstants.phoneCode}${_phoneController.text}';
      print('📺 UI: Full phone number: $fullPhoneNumber');

      authProvider.sendOTP(fullPhoneNumber).then((success) {
        print('📺 UI: AuthProvider.sendOTP returned: $success');
        if (success) {
          print('📺 UI: Navigating to OTP verification');
          Navigator.pushNamed(
            context,
            AppRoutes.otpVerificationRoute,
            arguments: {
              'phoneNumber': fullPhoneNumber,
              'fullName': _fullNameController.text,
            },
          );
        } else {
          print('📺 UI: Showing error toast');
          ToastUtils.showErrorToast(
              authProvider.errorMessage ?? 'Failed to send OTP');
        }
      });
    } else {
      print('📺 UI: Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          exit(0);
        }
      },
      child: GestureDetector(
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
                    width: ResponsiveHelper.containerWidth(),
                    constraints: BoxConstraints(
                      maxWidth: 400.w,
                      minHeight: _hasValidationErrors ? 380.h : 330.h,
                    ),
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(
                          TextConstants.fullName,
                          _fullNameController,
                          TextConstants.enterFullName,
                          errorText: _fullNameError,
                        ),
                        SizedBox(height: 16.h),
                        _buildPhoneInputField(
                          TextConstants.phoneNumber,
                          _phoneController,
                          TextConstants.enterPhoneNumber,
                          errorText: _phoneError,
                        ),
                        SizedBox(height: 24.h),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return CustomButton(
                              text: TextConstants.submit,
                              fontSize: 16.sp,
                              onPressed:
                                  authProvider.isLoading ? null : _onSubmit,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildPhoneInputField(
    String label,
    TextEditingController controller,
    String hint, {
    String? errorText,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: errorText != null ? 104.h : 79.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Container(
                width: ResponsiveHelper.isSmallScreen() ? 70.w : 80.w,
                height: 51.h,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.w, color: AppColors.inputTextBorder),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      TextConstants.phoneCode,
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomTextField(
                  controller: controller,
                  hintText: hint,
                  errorText: errorText,
                  keyboardType: TextInputType.phone,
                  width: 224.w,
                  onChanged: (value) {
                    setState(() {
                      _phoneError = value.isEmpty
                          ? TextConstants.phoneNumberRequired
                          : ValidationUtils.validatePhoneNumber(value);
                    });
                  },
                ),
              ),
            ],
          ),
          if (errorText != null) SizedBox(height: 4.h),
          if (errorText != null)
            Text(
              errorText,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    String? errorText,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: errorText != null ? 104.h : 79.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          CustomTextField(
            controller: controller,
            hintText: hint,
            errorText: errorText,
            onChanged: (value) {
              setState(() {
                if (controller == _fullNameController) {
                  if (value.isEmpty) {
                    _fullNameError = TextConstants.fullNameRequired;
                  } else if (value.length > 20) {
                    _fullNameError = 'Full name cannot exceed 20 characters';
                  } else {
                    _fullNameError = ValidationUtils.validateFullName(value);
                  }
                }
              });
            },
          ),
          if (errorText != null) SizedBox(height: 4.h),
          if (errorText != null)
            Text(
              errorText,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
