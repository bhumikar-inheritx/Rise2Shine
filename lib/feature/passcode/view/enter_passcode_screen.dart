import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/services/passcode_service.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/widgets/custom_button.dart';

class EnterPasscodeScreen extends StatefulWidget {
  const EnterPasscodeScreen({super.key});

  @override
  State<EnterPasscodeScreen> createState() => _EnterPasscodeScreenState();
}

class _EnterPasscodeScreenState extends State<EnterPasscodeScreen> {
  final TextEditingController _enterPasscodeController = TextEditingController();
  String? _enterPasscodeError;
  bool _isVerifying = false;

  bool get _hasEnterPasscodeError => _enterPasscodeError != null;

  @override
  void dispose() {
    _enterPasscodeController.dispose();
    super.dispose();
  }

  Future<void> _onEnterPasscode() async {
    final enteredPasscode = _enterPasscodeController.text;

    if (enteredPasscode.length < 4) {
      setState(() {
        _enterPasscodeError = 'Please enter complete passcode';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _enterPasscodeError = null;
    });

    try {
      final isValid = await PasscodeService.verifyPasscode(enteredPasscode);

      if (!mounted) return;

      if (isValid) {
        // Create session
        await PasscodeService.createSession();
        
        // Navigate to home
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.homeRoute,
            (route) => false,
          );
        }
      } else {
        setState(() {
          _enterPasscodeError = TextConstants.passcodeWrong;
          _isVerifying = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _enterPasscodeError = 'Error verifying passcode';
        _isVerifying = false;
      });
    }
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
            _buildEnterPasscodeContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnterPasscodeContainer() {
    return Center(
      child: Container(
        width: 376.w,
        height: _hasEnterPasscodeError ? 300.h : 269.h,
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEnterPasscodeInputField(),
              if (_enterPasscodeError != null) SizedBox(height: 8.h),
              if (_enterPasscodeError != null)
                Text(
                  _enterPasscodeError!,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20.h),
              _buildForgotPasswordText(),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'Continue',
                width: 312.w,
                height: 54.h,
                fontSize: 16.sp,
                onPressed: _onEnterPasscode,
                isLoading: _isVerifying,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnterPasscodeInputField() {
    return SizedBox(
      width: 312.w,
      height: 79.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.enterPasscode,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Pinput(
              controller: _enterPasscodeController,
              length: 4,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              defaultPinTheme: PinTheme(
                width: 72.w,
                height: 52.h,
                textStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: AppColors.inputTextBorder),
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 72.w,
                height: 52.h,
                textStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.w, color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              onCompleted: (pin) {
                _onEnterPasscode();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordText() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement forgot passcode flow
        ToastUtils.showSuccessToast('Forgot passcode feature coming soon');
      },
      child: Text(
        TextConstants.forgotPasscode,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: AppColors.primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
