import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:safe_view/views/parent_home_screen.dart';
import 'package:safe_view/views/parent_profile_screen.dart';
import 'package:safe_view/views/recent_child_activities.dart';

import '../untilities/app_colors.dart' show AppColors;

class PersistenBottomNavBarWiget extends StatefulWidget {
  final String deviceId;
  final bool isParent;
  final bool isPinSet;
  final getParentProfileModel;
  const PersistenBottomNavBarWiget(
      {super.key,
      required this.deviceId,
      required this.isParent,
      required this.isPinSet,
      required this.getParentProfileModel});

  @override
  State<PersistenBottomNavBarWiget> createState() =>
      _PersistenBottomNavBarWigetState();
}

class _PersistenBottomNavBarWigetState
    extends State<PersistenBottomNavBarWiget> {
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
        title: ("History"),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.charcoalGrey.withOpacity(.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.person,
        ),
        title: ("Profile"),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.charcoalGrey.withOpacity(.6),
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      ParentHomeScreen(
        parentDeviceId: widget.deviceId,
        isPinSet: widget.isPinSet,
        getParentProfileModel: widget.getParentProfileModel,
      ),
      RecentChildActivities(
        parentDeviceId: widget.deviceId,
      ),
      ParentProfileScreen(parentDeviceId: widget.deviceId)
    ];
  }

  @override
  void initState() {
    controller = PersistentTabController(initialIndex: 0);

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
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: EdgeInsets.only(top: 8, bottom: Platform.isAndroid ? 8 : 0),
      backgroundColor: AppColors.lightBlue2,
      isVisible: true,
      decoration: const NavBarDecoration(
          boxShadow: [BoxShadow(color: AppColors.lightBlue2, spreadRadius: 1)]),
      confineToSafeArea: true,
      navBarHeight: Platform.isAndroid ? 75 : 55,
      navBarStyle: NavBarStyle.style1,
    );
  }
}
