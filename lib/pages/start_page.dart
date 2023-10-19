import 'package:flutter/material.dart';
import 'package:monopoly/pages/board_page.dart';
import 'package:monopoly/pages/no_internet_connection_page.dart';
import 'package:monopoly/pages/onboarding/onboarding_main_page.dart';
import 'package:monopoly/pages/user_login_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/template_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    final templateProvider =
        Provider.of<TemplateProvider>(context, listen: false);
    templateProvider.getTemplates();
    checkSession();
  }

  checkSession() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);

    String? token = await userProvider.loadSession();
    if (token == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnboardingMainPage()));
    } else {
      Map res = await userProvider.loginWithToken(token);
      if (res['status']) {
        Map res = await boardProvider.getBoardSlots(userProvider.user);
        if (res['status'] == true) {
          diceProvider.resetFace();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BoardPage()));
        }
          else if(res['status'] == false && res['message'] == 'IE0') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NoInternetConnectionPage()));
        }
         else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UserLoginPage()));
        }
      }
      else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserLoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
