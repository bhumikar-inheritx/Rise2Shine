import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/services/passcode_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/main_layout.dart';
import '../../add_child/view/add_your_child.dart';
import '../../signup/provider/auth_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showAddChildBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddYourChild(isBottomSheet: true),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Clear passcode session
    await PasscodeService.clearSession();
    
    // Sign out
    await authProvider.signOut();
    
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.signupRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainLayout(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            TextConstants.addChilds,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: AppColors.textPrimary,
                size: 20.sp,
              ),
              onPressed: () => _handleLogout(context),
              tooltip: 'Logout',
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetConstants.homePageFamily,
                width: 300.w,
                height: 238.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                width: 213.w,
                text: TextConstants.addChild,
                fontSize: 16.sp,
                onPressed: () {
                  _showAddChildBottomSheet(context);
                },
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  TextConstants.homeContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
