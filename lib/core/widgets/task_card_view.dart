import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_structure/config/theme/app_colors.dart';
import 'package:provider_structure/core/constants/app_constants.dart';
import 'package:provider_structure/core/constants/asset_constants.dart';

class TaskCardView extends StatelessWidget {
  const TaskCardView({
    super.key,
    required this.leadingAvatarSvgImage,
    required this.taskName,
    required this.taskType,
    required this.rewards,
    this.trailingAction,
  });

  final String leadingAvatarSvgImage;
  final String taskName;
  final String taskType;
  final int rewards;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.black.withAlpha(22), offset: Offset(0, 10), blurRadius: 20, spreadRadius: 0),
        ],
      ),
      child: Row(
        spacing: 8,
        children: [
          Container(
            height: 60,
            width: 60,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(top: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.avtarbackground,
            ),
            child: SvgPicture.asset(leadingAvatarSvgImage),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  taskName,
                  style: TextStyle(
                    fontFamily: AppConstants.unboundedFont,
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: taskType,
                    style: TextStyle(
                      fontFamily: AppConstants.nunitoFont,
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      WidgetSpan(
                        child: SizedBox(
                          height: 13,
                          width: 22,
                          child: VerticalDivider(
                            radius: BorderRadius.circular(8),
                            color: AppColors.gray4,
                            thickness: 2,
                          ),
                        ),
                      ),
                      WidgetSpan(child: SvgPicture.asset(AssetConstants.rewardIcon, height: 16, width: 16)),
                      TextSpan(
                        text: rewards.toString().padLeft(4," "),
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.5,
                          fontFamily: AppConstants.nunitoFont,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (trailingAction != null) trailingAction!
        ],
      ),
    );
  }
}
