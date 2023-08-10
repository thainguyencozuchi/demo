// ignore_for_file: must_be_immutable, unused_local_variable, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/theme/app_theme.dart';
import 'common/widget/drawer_user_controller.dart';
import 'common/widget/home_drawer.dart';
import 'modules/chat/chat.screen.list.dart';
import 'modules/home/bloc/home_bloc.dart';
import 'modules/home/ui/home.screen.dart';
import 'modules/profile/bloc/profile_bloc.dart';
import 'modules/profile/ui/profile.screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  DrawerIndex? drawerIndex;
  Widget? screenView;
  NavigationHomeScreen({super.key, this.drawerIndex, this.screenView});
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = widget.drawerIndex ?? DrawerIndex.HOME;
    screenView = widget.screenView ?? BlocProvider(
              create: (context) => HomeBloc()..add(GetPostsEvent()),
              child: HomeScreen(),
            );
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
          )),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = BlocProvider(
              create: (context) => HomeBloc()..add(GetPostsEvent()),
              child: HomeScreen(),
            );
          });
          break;
        case DrawerIndex.Message:
          setState(() {
            screenView = ListChatScreen();
          });
          break;
        case DrawerIndex.Profile:
          setState(() {
            screenView = BlocProvider(
              create: (context) => ProfileBloc()..add(GetProfieEvent()),
              child: ProfileScreen(),
            );
          });
          break;
        default:
          break;
      }
    }
  }
}
