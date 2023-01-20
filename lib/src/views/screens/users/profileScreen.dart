import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:avatar_view/avatar_view.dart';

import '../../../../constants.dart';
import '../../../models/providers/profile.dart';
import '../../components/navbar/drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileData>(
      builder: (context, profile, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pushNamed(context, 'createPublication');
            },
            child: const FaIcon(
              color: kPrimaryColor,
              FontAwesomeIcons.circlePlus,
              size: 45,
            ),
          ),
          drawer: const NowDrawer(currentPage: "Profile"),
          body: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                        decoration: const BoxDecoration(
                            // image: DecorationImage(
                            //     image: AssetImage("assets/imgs/bg-profile.png"),
                            //     fit: BoxFit.cover),
                            color: kPrimaryColor),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  if (context.watch<ProfileData>().photoUrl == '') ...[
                                    const AvatarView(
                                      radius: 60,
                                      borderWidth: 8,
                                      borderColor: kSecundaryColor,
                                      avatarType: AvatarType.CIRCLE,
                                      backgroundColor: Colors.white,
                                      imagePath: "assets/profile.png",
                                      placeHolder: Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                      errorWidget: Icon(
                                        Icons.error,
                                        size: 50,
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                        width: 130,
                                        child: CircleAvatar(backgroundImage: NetworkImage(context.watch<ProfileData>().photoUrl), radius: 65.0))
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text('${context.watch<ProfileData>().name}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: const [
                                              Text('agregar iconos o contenido')
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  const Flexible(
                    flex: 2,
                    child: SingleChildScrollView(),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
