import 'package:flutter/material.dart';
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
              leadingAvatarSvgImage: AssetConstants.userAvatarSvg1,
              taskName: 'Read a book',
              taskType: 'Daily',
              rewards: 10,
              trailingAction: null,
            ),
            separatorBuilder: (context, index) => SizedBox(height: 16),
          ),
        )
      ],
    );
  }
}
