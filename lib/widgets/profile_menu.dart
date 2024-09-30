import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:medication_reminder_app/theme.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });
  final String title;
  final IconData? icon;
  final VoidCallback? onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: lightColorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: lightColorScheme.primary,
          )),
      title: Text(
        title,
        style: TextStyle(color: lightColorScheme.primary),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: lightColorScheme.primary.withOpacity(0.1),
              ),
              child: const Icon(
                FontAwesome.angle_right_solid,
                size: 18.0,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
