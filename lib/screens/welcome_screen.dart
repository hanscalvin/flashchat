import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/reusable_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  // AnimationController controller;
  // Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 1),
    // );
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    // controller.forward();
    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat',],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  isRepeatingAnimation: false,
                  speed: Duration(milliseconds: 200),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableButton(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context,LoginScreen.id);
              },
            ),
            ReusableButton(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: (){
                Navigator.pushNamed(context,RegistrationScreen.id);
              },
            ),

          ],
        ),
      ),
    );
  }
}


