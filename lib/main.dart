import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/app_routes.dart';
import 'config/routes/route_generator.dart';
import 'config/theme/theme_provider.dart';
import 'core/base/base_provider.dart';
import 'core/base/locale_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/app_localizations_delegate.dart';
import 'core/utils/toast_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseProvider(),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(440, 956),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              title: 'Rise2Shine',
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              scaffoldMessengerKey: ToastUtils.key,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: AppRoutes.initialRoute,
              locale: localeProvider.locale,
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
              ],
            ),
          );
        },
      ),
    );
  }
}
