import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import 'custom_button.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedDayIndex;
  late int selectedMonthIndex;
  late int selectedYearIndex;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDayIndex = widget.initialDate!.day - 1;
      selectedMonthIndex = widget.initialDate!.month - 1;
      selectedYearIndex = widget.initialDate!.year - 2000;
    } else {
      // Default to current date when no initial date
      DateTime now = DateTime.now();
      selectedDayIndex = now.day - 1;
      selectedMonthIndex = now.month - 1;
      selectedYearIndex = now.year - 2000;
    }
  }

  int _getDaysInMonth(int month, int year) {
    switch (month) {
      case 2: // February
        return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))
            ? 29
            : 28;
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      default:
        return 31;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440.w,
      height: 414.h,
      margin: EdgeInsets.only(top: 542.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 24.h),
          Text(
            'Select date of birth',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Day', style: _labelStyle()),
              SizedBox(width: 80.w),
              Text('Month', style: _labelStyle()),
              SizedBox(width: 80.w),
              Text('Year', style: _labelStyle()),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScrollPicker(
                  items: List.generate(
                    _getDaysInMonth(
                        selectedMonthIndex + 1, 2000 + selectedYearIndex),
                    (i) => (i + 1).toString().padLeft(2, '0'),
                  ),
                  selectedIndex: selectedDayIndex,
                  onChanged: (index) =>
                      setState(() => selectedDayIndex = index),
                ),
                _buildScrollPicker(
                  items: List.generate(
                      12, (i) => (i + 1).toString().padLeft(2, '0')),
                  selectedIndex: selectedMonthIndex,
                  onChanged: (index) {
                    setState(() {
                      selectedMonthIndex = index;
                      int maxDays = _getDaysInMonth(
                          selectedMonthIndex + 1, 2000 + selectedYearIndex);
                      if (selectedDayIndex >= maxDays) {
                        selectedDayIndex = maxDays - 1;
                      }
                    });
                  },
                ),
                _buildScrollPicker(
                  items: List.generate(25, (i) => (2000 + i).toString()),
                  selectedIndex: selectedYearIndex,
                  onChanged: (index) =>
                      setState(() => selectedYearIndex = index),
                  isYear: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, MediaQuery.of(context).padding.bottom + 24.w),
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
                    text: 'Select',
                    fontSize: 16.sp,
                    onPressed: () {
                      widget.onDateSelected(DateTime(
                        2000 + selectedYearIndex,
                        selectedMonthIndex + 1,
                        selectedDayIndex + 1,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollPicker({
    required List<String> items,
    required int selectedIndex,
    required Function(int) onChanged,
    bool isYear = false,
  }) {
    return SizedBox(
      width: isYear ? 80.w : 42.w,
      height: 222.h,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 55.h,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            int position = index - selectedIndex;

            return Container(
              height: 55.h,
              alignment: Alignment.center,
              child: Text(
                items[index],
                style: _getTextStyle(position),
              ),
            );
          },
        ),
        controller: FixedExtentScrollController(initialItem: selectedIndex),
      ),
    );
  }

  TextStyle _getTextStyle(int position) {
    if (position == 0) {
      // Selected item - Bold 32px
      return TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        fontSize: 32.sp,
        color: AppColors.textPrimary,
      );
    } else if (position.abs() == 1) {
      // Adjacent items (±1 position) - Regular 14px
      return TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: AppColors.textSecondary,
      );
    } else {
      // Other items (±2+ positions) - Regular 14px lighter
      return TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: AppColors.textLight,
      );
    }
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      color: AppColors.textPrimary,
    );
  }
}
