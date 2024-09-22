import 'package:fit_pro_client/providers/auth_provider.dart';
import 'package:fit_pro_client/providers/login_validation_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/providers/taskers_provider.dart';
import 'package:fit_pro_client/providers/tasks_provider.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/screens/login_screen.dart';
import 'package:fit_pro_client/screens/register_screen.dart';
import 'package:fit_pro_client/screens/search_screen.dart';
import 'package:fit_pro_client/services/auth_check_service.dart';
import 'package:fit_pro_client/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fit_pro_client/providers/map_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  await initializeDateFormatting('sq', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => Validators()),
        ChangeNotifierProvider(create: (_) => LoginValidationProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => TaskStateProvider()),
        ChangeNotifierProvider(create: (_) => TaskersProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 867),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FixProClient',
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('sq'),
          ],
          locale: const Locale('sq'),
          initialRoute: '/home',
          routes: {
            '/auth-check': (context) => const AuthCheckService(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/search-screen': (context) => const SearchScreen(),
          },
        );
      },
    );
  }
}
