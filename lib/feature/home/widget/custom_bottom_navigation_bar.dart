import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/text_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      icon: AssetConstants.homeIcon,
      label: TextConstants.home,
    ),
    BottomNavItem(
      icon: AssetConstants.taskSquare,
      label: TextConstants.task,
    ),
    BottomNavItem(
      icon: AssetConstants.cupIcon,
      label: TextConstants.rewards,
    ),
    BottomNavItem(
      icon: AssetConstants.chartIcon,
      label: TextConstants.stats,
    ),
    BottomNavItem(
      icon: AssetConstants.moreIcon,
      label: TextConstants.more,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76.h,
      margin: EdgeInsets.only(
        bottom: 24.h,
        left: 24.w,
        right: 24.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_navItems.length, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = selectedIndex == index;
    final item = _navItems[index];

    return Flexible(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.icon,
                width: 24.w,
                height: 24.h,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              ),
              SizedBox(height: 4.h),
              FittedBox(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
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

class BottomNavItem {
  final String icon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.label,
  });
}
