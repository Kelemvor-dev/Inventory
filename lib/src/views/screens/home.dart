import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:inventory/src/views/screens/product/productScreen.dart';
import 'package:inventory/src/views/screens/users/profileScreen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../models/providers/profile.dart';
import '../components/navbar/drawer.dart';
import '../components/navbar/navbar.dart';
import 'chat/chatScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final userAuth = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    //
    // Provider.of<NotificationApi>(context,listen: false).initNotifications();
    animationController = AnimationController(vsync: this, duration: animationDuration);
    //Llamamos la informacion del perfil en la base de datos(Firestore) con Provider
    Provider.of<ProfileData>(context, listen: false).getProfile();
  }

  final List<Widget> _tabItems = [const ChatScreen(), const ProductScreen(), const ProfileScreen()];
  int _page = 1;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.zero,
        child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: const Navbar(title: "Inventory", transparent: false, bgColor: kPrimaryColor),
          drawer: const NowDrawer(currentPage: "Home"),
          body: _tabItems[_page],
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 1,
            height: 70.0,
            items: const <Widget>[
              Icon(
                Icons.library_books,
                size: 30,
                color: UiColors.white,
              ),
              Icon(
                Icons.home,
                size: 30,
                color: UiColors.white,
              ),
              Icon(
                Icons.perm_identity,
                size: 30,
                color: UiColors.white,
              ),
            ],
            color: kPrimaryColor,
            buttonBackgroundColor: kPrimaryColor,
            backgroundColor: Colors.white,
            animationCurve: Curves.decelerate,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
            letIndexChange: (index) => true,
          ),
        ));
  }
}
