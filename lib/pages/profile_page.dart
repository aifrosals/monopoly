import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/choose_photo_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          'assets/images/profile_background.png',
          fit: BoxFit.cover,
          height: ScreenConfig.screenHeight,
          width: ScreenConfig.screenWidth,
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: ScreenConfig.blockHeight * 75,
                width: ScreenConfig.blockWidth * 75,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.99),
                      gradient: LinearGradient(
                          stops: [0.8, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.deepPurple.withOpacity(0.96),
                            Colors.white70
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: Colors.yellow, width: 2)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(color: Colors.white, width: 2)),
                        height: 120,
                        width: 120,
                        child: Icon(Icons.account_circle_rounded),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        userProvider.user.id,
                        style: GoogleFonts.teko(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text('Token',
                          style: GoogleFonts.teko(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 170,
                        width: 170,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/pawn.png',
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                splashColor: Colors.green,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => ChoosePhoto());
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        )
      ],
    ));
  }
}
