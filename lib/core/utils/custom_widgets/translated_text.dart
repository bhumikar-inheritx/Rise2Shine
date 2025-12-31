import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';

class TranslatedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TranslatedText(
    this.translationKey, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).translate(translationKey),
      style: style,
      textAlign: textAlign,
    );
  }
}
