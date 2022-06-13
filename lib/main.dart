import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly/firebase_options.dart';
import 'package:monopoly/pages/start_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/image_provider.dart';
import 'package:monopoly/providers/transaction_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/values.dart';

void main() async {
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
    ChangeNotifierProvider<ImagesProvider>(
      create: (context) => ImagesProvider(),
    )
  ], child: const MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          textTheme: GoogleFonts.tekoTextTheme(
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
