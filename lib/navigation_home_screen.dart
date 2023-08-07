// ignore_for_file: must_be_immutable, unused_local_variable, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'common/theme/app_theme.dart';
import 'common/widget/drawer_user_controller.dart';
import 'common/widget/home_drawer.dart';
import 'modules/chat/chat.screen.list.dart';
import 'modules/home/home.screen.dart';

class NavigationHomeScreen extends StatefulWidget {

  NavigationHomeScreen({super.key});
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {

    drawerIndex = DrawerIndex.HOME;
    screenView =  HomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          )
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView =  HomeScreen();
          });
          break;
        case DrawerIndex.Message:
          setState(() {
            screenView = ListChatScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = Container();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = Container();
          });
          break;
        default:
          break;
      }
    }
  }
}
