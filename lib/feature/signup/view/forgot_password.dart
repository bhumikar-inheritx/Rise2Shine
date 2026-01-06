import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/utils/validation_utils.dart';
import '../../profile_selection/widget/custom_button.dart';
import '../provider/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _phoneController;
  String? _phoneError;

  bool get _hasValidationErrors => _phoneError != null;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateAndSubmit() {
    setState(() {
      _phoneError = _phoneController.text.isEmpty
          ? TextConstants.phoneNumberRequired
          : ValidationUtils.validatePhoneNumber(_phoneController.text);
    });

    return !_hasValidationErrors;
  }

  void _onSubmit() {
    if (_validateAndSubmit()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.resetPassword(_phoneController.text).then((success) {
        if (success) {
          Navigator.pushNamed(
            context,
            AppRoutes.otpVerificationRoute,
            arguments: {
              'phoneNumber': _phoneController.text,
              'isPasswordReset': true,
            },
          );
        } else {
          ToastUtils.showErrorToast(
              authProvider.errorMessage ?? 'Failed to send reset OTP');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Reset Password',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
          ),
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
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 400.w),
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter your phone number to receive a password reset OTP',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        _buildPhoneInputField(
                          TextConstants.phoneNumber,
                          _phoneController,
                          TextConstants.enterPhoneNumber,
                          errorText: _phoneError,
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return CustomButton(
                                text: 'Send Reset OTP',
                                fontSize: 16.sp,
                                onPressed:
                                    authProvider.isLoading ? null : _onSubmit,
                              );
                            },
                          ),
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

  Widget _buildPhoneInputField(
    String label,
    TextEditingController controller,
    String hint, {
    String? errorText,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                width: 70.w,
                height: 51.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: AppColors.textLight),
                  borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(width: 1.w, color: AppColors.textLight),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null) SizedBox(height: 8.h),
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
