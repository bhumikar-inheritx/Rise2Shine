import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../constants/asset_constants.dart';
import '../constants/text_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Widget? floatingAction;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.floatingAction,
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
      width: 392.w,
      height: 76.h,
      margin: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
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

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onItemTapped(index),
        child: ClipRect(
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  item.icon,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.contain,
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                ),
                SizedBox(height: 4.h),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
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
