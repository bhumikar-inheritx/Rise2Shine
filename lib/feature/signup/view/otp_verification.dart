import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/widgets/custom_button.dart';
import '../provider/auth_provider.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _enterPasscodeController = TextEditingController();
  String? _otpError;
  String? _passwordError;
  String? _enterPasscodeError;
  bool _showSetPassword = false;
  bool _showEnterPasscode = false;
  String? _phoneNumber;
  String? _fullName;
  bool _isPasswordReset = false;
  String? _savedPasscode;

  int _resendTimer = 60;
  bool _canResend = false;

  bool get _hasValidationError => _otpError != null;
  bool get _hasPasswordError => _passwordError != null;
  bool get _hasEnterPasscodeError => _enterPasscodeError != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _phoneNumber = args?['phoneNumber'];
    _fullName = args?['fullName'];
    _isPasswordReset = args?['isPasswordReset'] ?? false;
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
          if (_resendTimer <= 0) {
            _canResend = true;
          }
        });
        return _resendTimer > 0;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _enterPasscodeController.dispose();
    super.dispose();
  }

  bool _validateAndSubmit() {
    final otp = _pinController.text;
    setState(() {
      if (otp.length < 6) {
        _otpError = 'Please enter complete OTP';
      } else {
        _otpError = null;
      }
    });
    return !_hasValidationError;
  }

  void _onVerify() {
    if (_validateAndSubmit()) {
      final otp = _pinController.text;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.verifyOTP(otp).then((success) {
        if (success) {
          if (_isPasswordReset) {
            ToastUtils.showSuccessToast(
                'Phone number verified. Set new password.');
          }
          setState(() {
            _showSetPassword = true;
          });
        } else {
          setState(() {
            _otpError = authProvider.errorMessage ?? 'Invalid OTP';
          });
        }
      });
    }
  }

  bool _validatePasswords() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Passcode cannot be empty';
      } else if (confirmPassword.isEmpty) {
        _passwordError = 'Confirm passcode cannot be empty';
      } else if (password.length < 4) {
        _passwordError = 'Passcode must be 4 digits';
      } else if (confirmPassword.length < 4) {
        _passwordError = 'Confirm passcode must be 4 digits';
      } else if (password != confirmPassword) {
        _passwordError = TextConstants.passwordsDoNotMatch;
      } else {
        _passwordError = null;
      }
    });

    return !_hasPasswordError;
  }

  void _onSetPasscode() {
    if (_validatePasswords()) {
      _savedPasscode = _passwordController.text;
      setState(() {
        _showEnterPasscode = true;
        _showSetPassword = false;
      });
    }
  }

  void _onEnterPasscode() {
    final enteredPasscode = _enterPasscodeController.text;

    setState(() {
      if (enteredPasscode.length < 4) {
        _enterPasscodeError = 'Please enter complete passcode';
      } else if (enteredPasscode != _savedPasscode) {
        _enterPasscodeError = TextConstants.passcodeWrong;
      } else {
        _enterPasscodeError = null;
        Navigator.pushNamed(context, AppRoutes.addChildRoute);
      }
    });
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
              _showEnterPasscode
                  ? _buildEnterPasscodeContainer()
                  : _showSetPassword
                      ? _buildSetPasswordContainer()
                      : _buildOtpContainer(),
            ],
          ),
        ));
  }

  Widget _buildOtpInputField() {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(minHeight: _hasValidationError ? 110.h : 79.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.verifyOtp,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 52.h,
            child: Pinput(
              controller: _pinController,
              length: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              defaultPinTheme: PinTheme(
                width: 42.w,
                height: 52.h,
                textStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.w, color: AppColors.inputTextBorder),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 42.w,
                height: 52.h,
                textStyle: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.w, color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onCompleted: (pin) {
                _onVerify();
              },
            ),
          ),
          if (_otpError != null) SizedBox(height: 4.h),
          if (_otpError != null)
            Text(
              _otpError!,
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

  Widget _buildResendOtpText() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return GestureDetector(
          onTap: (_canResend && !authProvider.isLoading)
              ? () {
                  if (_phoneNumber != null) {
                    authProvider.sendOTP(_phoneNumber!).then((success) {
                      if (success) {
                        ToastUtils.showSuccessToast('OTP sent successfully');
                        _startResendTimer();
                      } else {
                        ToastUtils.showErrorToast(authProvider.errorMessage ??
                            'Failed to resend OTP');
                      }
                    });
                  }
                }
              : null,
          child: Text(
            _canResend
                ? TextConstants.resendOtp
                : 'Resend OTP in ${_resendTimer}s',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5,
              color: (_canResend && !authProvider.isLoading)
                  ? AppColors.primaryColor
                  : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildOtpContainer() {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 400.w,
          minHeight: _hasValidationError ? 316.h : 280.h,
        ),
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOtpInputField(),
            SizedBox(height: 24.h),
            _buildResendOtpText(),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: TextConstants.verify,
                fontSize: 16.sp,
                onPressed: () {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (!authProvider.isLoading) {
                    _onVerify();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetPasswordContainer() {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 400.w),
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordInputField(
                  'Set passcode', _passwordController),
              SizedBox(height: 16.h),
              _buildPasswordInputField(TextConstants.confirmPasscode,
                  _confirmPasswordController,
                  errorText: _passwordError),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Set passcode',
                  fontSize: 16.sp,
                  onPressed: _onSetPasscode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInputField(String label,
      TextEditingController controller,
      {String? errorText}) {
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
          Container(
            height: 52.h,
            child: Pinput(
              controller: controller,
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
            ),
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

  Widget _buildForgotPasswordText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.forgotPasswordRoute);
      },
      child: const Text(
        TextConstants.forgotPasscode,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.primaryColor,
        ),
        textAlign: TextAlign.center,
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
                text: 'Set passcode',
                width: 312.w,
                height: 54.h,
                fontSize: 16.sp,
                onPressed: _onEnterPasscode,
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
            ),
          ),
        ],
      ),
    );
  }
}
