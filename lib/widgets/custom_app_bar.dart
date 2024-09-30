import 'package:flutter/material.dart';
import 'package:medication_reminder_app/theme.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.child,
    this.bottomNavigationBar,
    this.body,
    this.actions,
  });
  final String? title;
  final Widget? child;
  final Widget? bottomNavigationBar;
  final Widget? body;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        backgroundColor: lightColorScheme.primary,
        elevation: 4.0,
        automaticallyImplyLeading: false,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      //actions: actions,
    );
  }
}
