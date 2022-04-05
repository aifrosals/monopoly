import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly/pages/start_page.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/admin_questions_provider.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/transaction_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/web/admin/admin_app.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/values.dart';

void main() async {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<AdminProvider>(
        create: (context) => AdminProvider(),
      ),
      ChangeNotifierProvider<AdminQuestionProvider>(
        create: (context) => AdminQuestionProvider(),
      ),
    ], child: const AdminApp()));
  } else {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider<BoardProvider>(
        create: (context) => BoardProvider(),
      ),
      ChangeNotifierProvider<DiceProvider>(
        create: (context) => DiceProvider(),
      ),
      ChangeNotifierProvider<TransactionProvider>(
        create: (context) => TransactionProvider(),
      ),
    ], child: const MyApp()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        navigatorKey: Values.navigatorKey,
        scaffoldMessengerKey: Values.snackBarKey,
        title: 'Monopoly',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[200],
          ),
          primarySwatch: Colors.grey,
        ),
        home: const StartPage());
  }
}
