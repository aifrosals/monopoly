import 'package:flutter/material.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/pages/onboarding/page_1.dart';
import 'package:monopoly/pages/onboarding/page_2.dart';
import 'package:monopoly/pages/onboarding/page_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingMainPage extends StatefulWidget {
  const OnboardingMainPage({Key? key}) : super(key: key);

  @override
  State<OnboardingMainPage> createState() => _OnboardingMainPageState();
}

class _OnboardingMainPageState extends State<OnboardingMainPage> {
  final controller = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: const [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
          Positioned.fill(
            top: ScreenConfig.blockHeight * 78,
            child: Center(
              child: SmoothPageIndicator(
                  controller: controller, // PageController
                  count: 3,
                  effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.purple,
                      spacing: 20), // your preferred effect
                  onDotClicked: (index) {}),
            ),
          )
        ],
      ),
    );
  }
}
