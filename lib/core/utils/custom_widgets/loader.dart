import 'package:flutter/material.dart';
import '../extensions/widget_extension.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator().center;
  }
}
