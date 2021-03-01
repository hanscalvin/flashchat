import 'package:flutter/material.dart';
import 'file:///C:/Users/alexa/AndroidStudioProjects/flashchat/lib/screens/welcome_screen.dart';
import 'file:///C:/Users/alexa/AndroidStudioProjects/flashchat/lib/screens/login_screen.dart';
import 'file:///C:/Users/alexa/AndroidStudioProjects/flashchat/lib/screens/registration_screen.dart';
import 'file:///C:/Users/alexa/AndroidStudioProjects/flashchat/lib/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute:WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      }
    );
  }
}
