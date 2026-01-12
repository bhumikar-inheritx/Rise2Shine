import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_structure/core/constants/asset_constants.dart';
import 'package:provider_structure/core/widgets/task_card_view.dart';

class ParentTasksPage extends StatelessWidget {
  const ParentTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 100,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            itemBuilder: (context, index) => TaskCardView(
              leadingAvatarSvgImage: AssetConstants.userAvatarSvg8,
              taskName: 'Read a book',
              taskType: 'Daily',
              rewards: 100,
              trailingAction: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: SvgPicture.asset(
                  AssetConstants.verticalMoreIcon,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 16),
          ),
        )
      ],
    );
  }
}
