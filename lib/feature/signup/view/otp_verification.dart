import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/utils/toast_util.dart';
import '../../profile_selection/widget/custom_button.dart';
import '../provider/auth_provider.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _passwordControllers;
  late List<FocusNode> _passwordFocusNodes;
  late List<TextEditingController> _confirmPasswordControllers;
  late List<FocusNode> _confirmPasswordFocusNodes;
  late List<TextEditingController> _enterPasscodeControllers;
  late List<FocusNode> _enterPasscodeFocusNodes;
  String? _otpError;
  String? _passwordError;
  String? _enterPasscodeError;
  bool _showSetPassword = false;
  bool _showEnterPasscode = false;
  String? _phoneNumber;
  String? _fullName;
  bool _isPasswordReset = false;
  String? _savedPasscode; // Store the set passcode

  // Timer variables
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
    print(
        '🔐 OTP: Screen initialized with phone: $_phoneNumber, isReset: $_isPasswordReset');
  }

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
    _passwordControllers = List.generate(4, (index) => TextEditingController());
    _passwordFocusNodes = List.generate(4, (index) => FocusNode());
    _confirmPasswordControllers =
        List.generate(4, (index) => TextEditingController());
    _confirmPasswordFocusNodes = List.generate(4, (index) => FocusNode());
    _enterPasscodeControllers =
        List.generate(4, (index) => TextEditingController());
    _enterPasscodeFocusNodes = List.generate(4, (index) => FocusNode());
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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _passwordControllers) {
      controller.dispose();
    }
    for (var focusNode in _passwordFocusNodes) {
      focusNode.dispose();
    }
    for (var controller in _confirmPasswordControllers) {
      controller.dispose();
    }
    for (var focusNode in _confirmPasswordFocusNodes) {
      focusNode.dispose();
    }
    for (var controller in _enterPasscodeControllers) {
      controller.dispose();
    }
    for (var focusNode in _enterPasscodeFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  bool _validateAndSubmit() {
    final otp = _otpControllers.map((controller) => controller.text).join();
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
    print('🔐 OTP: Verify button pressed');
    if (_validateAndSubmit()) {
      final otp = _otpControllers.map((controller) => controller.text).join();
      print('🔐 OTP: Entered OTP: $otp');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.verifyOTP(otp).then((success) {
        print('🔐 OTP: AuthProvider.verifyOTP returned: $success');
        if (success) {
          if (_isPasswordReset) {
            print('🔐 OTP: Password reset flow - showing success message');
            ToastUtils.showSuccessToast(
                'Phone number verified. Set new password.');
          }
          print('🔐 OTP: Moving to set password screen');
          setState(() {
            _showSetPassword = true;
          });
        } else {
          print('🔐 OTP: Verification failed, showing error');
          setState(() {
            _otpError = authProvider.errorMessage ?? 'Invalid OTP';
          });
        }
      });
    } else {
      print('🔐 OTP: OTP validation failed');
    }
  }

  bool _validatePasswords() {
    final password =
        _passwordControllers.map((controller) => controller.text).join();
    final confirmPassword =
        _confirmPasswordControllers.map((controller) => controller.text).join();

    setState(() {
      if (password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          password != confirmPassword) {
        _passwordError = TextConstants.passwordsDoNotMatch;
      } else {
        _passwordError = null;
      }
    });

    return !_hasPasswordError;
  }

  void _onSetPasscode() {
    if (_validatePasswords()) {
      // Save passcode and show enter passcode screen
      _savedPasscode =
          _passwordControllers.map((controller) => controller.text).join();
      setState(() {
        _showEnterPasscode = true;
        _showSetPassword = false;
      });
    }
  }

  void _onEnterPasscode() {
    final enteredPasscode =
        _enterPasscodeControllers.map((controller) => controller.text).join();

    setState(() {
      if (enteredPasscode.length < 4) {
        _enterPasscodeError = 'Please enter complete passcode';
      } else if (enteredPasscode != _savedPasscode) {
        _enterPasscodeError = TextConstants.passcodeWrong;
      } else {
        _enterPasscodeError = null;
        // Navigate to add child screen
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Flexible(
                  child: Container(
                    width: 42.w,
                    height: 52.h,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1.w, color: AppColors.textLight),
                      borderRadius: BorderRadius.circular(21.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        hintText: '○',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
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
                        _startResendTimer(); // Restart timer
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
                  'Set passcode', _passwordControllers, _passwordFocusNodes),
              SizedBox(height: 16.h),
              _buildPasswordInputField(TextConstants.confirmPasscode,
                  _confirmPasswordControllers, _confirmPasswordFocusNodes,
                  errorText: _passwordError),
              SizedBox(height: 16.h),
              _buildForgotPasswordText(),
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
      List<TextEditingController> controllers, List<FocusNode> focusNodes,
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
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    obscureText: false,
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
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
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
                    controller: _enterPasscodeControllers[index],
                    focusNode: _enterPasscodeFocusNodes[index],
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
                        _enterPasscodeFocusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _enterPasscodeFocusNodes[index - 1].requestFocus();
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
