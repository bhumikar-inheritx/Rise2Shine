import 'package:flutter/material.dart';
import '../../base/base_provider.dart';
import '../../utils/custom_widgets/loader.dart';

class StackLoader extends StatelessWidget {
  final ViewState state;
  final Widget content;

  const StackLoader({super.key, required this.state, required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: state == ViewState.loading, // Disable interactions
          child: content,
        ),
        if (state == ViewState.loading) const Loader()
      ],
    );
  }
}
