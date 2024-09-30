import 'package:flutter/material.dart';
import 'package:medication_reminder_app/screens/login.dart';
import 'package:medication_reminder_app/screens/signup_screen.dart';
import 'package:medication_reminder_app/theme.dart';
import 'package:medication_reminder_app/widgets/custom_scaffold.dart';
import 'package:medication_reminder_app/widgets/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 40.0,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'Welcome \n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text: 'hello',
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                    ),
                  ))),
          Flexible(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    const Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: LoginScreen(),
                        color: Colors.transparent,
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: const SignupScreen(),
                        color: Colors.white,
                        textColor: lightColorScheme.primary,
                        //  textColor: Color.fromARGB(255, 11, 212, 202),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
