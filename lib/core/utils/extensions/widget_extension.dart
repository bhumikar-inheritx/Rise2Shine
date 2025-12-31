import 'package:flutter/material.dart';
import 'package:provider_structure/core/utils/custom_widgets/translated_text.dart';

import '../../constants/app_constants.dart';

extension SizeExtension on num {
  SizedBox get vSpace => SizedBox(height: toDouble());

  SizedBox get hSpace => SizedBox(width: toDouble());
}

extension WidgetExtension on Widget {
  Widget get center => Center(child: this);

  Widget padding([EdgeInsets? padding]) => Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        child: this,
      );

  Widget card({Color? color, double? elevation}) => Card(
        color: color,
        elevation: elevation,
        child: this,
      );
}

extension TextExtension on String {
  Widget textWidget({TextStyle? style, TextAlign? textAlign}) => Text(
        this,
        style: style,
        textAlign: textAlign,
      );

  Widget translatedTextWidget({TextStyle? style, TextAlign? textAlign}) =>
      TranslatedText(
        this,
        style: style,
        textAlign: textAlign,
      );
}
