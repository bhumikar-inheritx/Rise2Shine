import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'config/routes/app_routes.dart';
import 'config/routes/route_generator.dart';
import 'config/theme/theme_provider.dart';
import 'core/base/base_provider.dart';
import 'core/base/locale_provider.dart';
import 'core/providers/bottom_navigation_provider.dart';
import 'core/providers/parent_provider.dart';
import 'core/services/fcm_service.dart';
import 'core/utils/toast_util.dart';
import 'feature/signup/provider/auth_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  print('🚀 App: Starting application initialization');
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar to white
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  try {
    print(' App: Initializing Firebase');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print(' App: Initializing FCM');
    await FCMService.initialize();
  } catch (e) {
    print('Firebase initialization failed: $e');
    print(' App: Continuing without Firebase');
  }

  print(' App: Running app');
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
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
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
              initialRoute: AppRoutes.splashRoute,
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
