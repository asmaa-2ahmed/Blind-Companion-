import 'package:color_sensor/MyHomePage.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  // what is id used for?
  static const String id = "welcome";
  @override
  Widget build(BuildContext context) {
    return OnBoardingScreen(
      onSkip: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      },
      showPrevNextButton: true,
      //showIndicator: true,
      backgourndColor: const Color.fromARGB(255, 249, 240, 229),
      activeDotColor: const Color.fromARGB(255, 97, 63, 30),
      deactiveDotColor: const Color.fromARGB(255, 97, 63, 30),
      iconColor: const Color.fromARGB(255, 97, 63, 30),
      leftIcon: Icons.arrow_circle_left_rounded,
      rightIcon: Icons.arrow_circle_right_rounded,
      iconSize: 30,
      pages: [
        OnBoardingModel(
          titleColor: const Color.fromARGB(255, 97, 63, 30),
          title: "Supervised by :",
          titleFontSize: 30,
          image: Image.asset(
            "images/image_1.png",
            height: 300,
            width: 300,
          ),
          body: "Dr. Saad Darwish\nEng. Mazen Amer",
          bodyColor: const Color.fromARGB(255, 183, 109, 35),
        ),
        OnBoardingModel(
          titleColor: const Color.fromARGB(255, 97, 63, 30),
          title: "Project Team",
          titleFontSize: 30,
          image: Image.asset(
            "images/image_2.png",
            height: 300,
            width: 300,
          ),
          body:
              "Asmaa Ahmed Ahmed - 202101657\nFarah Nasr - 202101892\nArwa Mekawy - 202102726",
          bodyColor: const Color.fromARGB(255, 183, 109, 35),
        ),
        OnBoardingModel(
          image: Image.asset("images/image_3.png"),
          title: "Our Project",
          titleFontSize: 30,
          titleColor: const Color.fromARGB(255, 97, 63, 30),
          body:
              "Aims to help visually impaired individuals by providing location services to prevent them from getting lost and offering color recognition technology to help them identify colors in their surroundings.",
          bodyColor: const Color.fromARGB(255, 183, 109, 35),
        ),
        OnBoardingModel(
          image: Image.asset(
            "images/image_5.png",
          ),
          title: "Ready to Get Started?",
          titleFontSize: 30,
          titleColor: const Color.fromARGB(255, 97, 63, 30),
          body:
              "Let's start this journey together towards an easier, safer lifestyle!",
          bodyColor: const Color.fromARGB(255, 97, 63, 30),
        )
      ],
    );
  }
}
