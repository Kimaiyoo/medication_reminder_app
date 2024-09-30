import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:medication_reminder_app/screens/profile/account_screen.dart';
import 'package:medication_reminder_app/screens/profile/edit_profile.dart';
import 'package:medication_reminder_app/services/auth_service.dart';
import 'package:medication_reminder_app/theme.dart';
import 'package:medication_reminder_app/widgets/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    const String pfp = 'assets/images/image2.jpg';
    //var isDark =MediaQuery.of(context).platformBrightness == Brightness.dark;
    /*actions: [
       IconButton(onPressed: () {}, icon: const Icon(isDark? Icon(Icons.sunny) : Icon(Ionicons.moon)))

      ],*/
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(pfp),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: lightColorScheme.primary,
                    ),
                    child: const Icon(
                      FontAwesome.pencil_solid,
                      size: 18.0,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('user'),
            const Text('age'),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()));
                },
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuWidget(
              title: "Settings",
              icon: IonIcons.settings,
              onPress: () {},
            ),
            ProfileMenuWidget(
                title: "Account",
                icon: IonIcons.people_circle,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                }),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuWidget(
              title: "Signout",
              icon: IonIcons.log_out,
              textColor: Colors.red,
              endIcon: false,
              onPress: () async {
                await auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
