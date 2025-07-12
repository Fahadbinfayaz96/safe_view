import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:safe_view/views/parent_home_screen.dart';
import 'package:safe_view/views/recent_child_activities.dart';

import '../untilities/app_colors.dart' show AppColors;

class PersistenBottomNavBarWiget extends StatefulWidget {
    final String parentDeviceId;
  const PersistenBottomNavBarWiget({super.key,required this.parentDeviceId});

  @override
  State<PersistenBottomNavBarWiget> createState() => _PersistenBottomNavBarWigetState();
}

class _PersistenBottomNavBarWigetState extends State<PersistenBottomNavBarWiget> {
  late PersistentTabController controller;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
        ),
        title: ("Home"),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.charcoalGrey.withOpacity(.6),
     
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.history,
        ),
        title: ("Recent History"),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.charcoalGrey.withOpacity(.6),
       
      ),
    ];
  }

  List<Widget> _buildScreens() {
     log("message ${controller.index}");
    return [
       ParentHomeScreen(parentDeviceId:  widget.parentDeviceId,),
       RecentChildActivities(parentDeviceId: widget.parentDeviceId,),
    ];
  }

  @override
  void initState() {
    controller = PersistentTabController(initialIndex: 0);
   log("inside init of bottom navigation controll");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppColors.lightBlue2,
      isVisible: true,
      decoration: const NavBarDecoration(
          boxShadow: [BoxShadow(color: AppColors.lightBlue2, spreadRadius: 1)]),
      confineToSafeArea: true,
      navBarHeight: 55,
      navBarStyle: NavBarStyle.style6,
    );
  }
}
