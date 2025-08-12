// splash_screen.dart

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_cubit.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_state.dart';
import 'package:safe_view/blocs/pairing_status_cubit/pairing_status_cubit.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/views/child_home_screen.dart';
import 'package:safe_view/views/onboadring_screen.dart';
import 'package:safe_view/views/pairing_screen.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/bottom_navigation_bar.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/internet_popup.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  String? deviceId;
  StreamSubscription<List<ConnectivityResult>>? subscription;
  Future<void> fetchDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String id;

    if (Theme.of(context).platform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      id = androidInfo.id;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      id = iosInfo.identifierForVendor ?? "unknown";
    } else {
      id = "unknown";
    }

    setState(() {
      deviceId = id;
    });
  }

  late IO.Socket socket;

  bool? isPinSet;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchDeviceId();

      List<ConnectivityResult> result =
          await Connectivity().checkConnectivity();
      netstatus(result);

      bool hasInternet = result.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);

      if (hasInternet) {
        BlocProvider.of<PairingStatusCubit>(context)
            .getPairingStatus(deviceId: deviceId.toString());
       
      } else {}
    });
  }


  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      subscription = Connectivity().onConnectivityChanged.listen((result) {
        bool hasInternet = result.any((result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet);

        if (hasInternet) {
          BlocProvider.of<PairingStatusCubit>(context)
              .getPairingStatus(deviceId: deviceId.toString());
        } else {}
      });
    }
  }



  @override
  void dispose() {

    subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue2,
      ),
      body: BlocListener<GetParentProfileCubit, GetParentProfileState>(
        listener: (context, state) {
          if (state is GetParentProfileLoadedState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => PersistenBottomNavBarWiget(
                  deviceId: deviceId.toString(),
                  isParent: true,
                  isPinSet: isPinSet ?? false,
                  getParentProfileModel: state.getParentProfileModel,
                ),
              ),
              (route) => false,
            );
          } else if (state is GetParentProfileEmptyState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OnboardingScreen(parentDeviceId: deviceId.toString()),
                ),
                (_) => false);
          }
        },
        child: BlocListener<PairingStatusCubit, PairingStatusState>(
            listener: (context, state) async {
              if (state is PairingStatusLoadedState) {
                if (state.pairingStatus.role == "child" &&
                    state.pairingStatus.isVerified == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChildHomeScreen(
                            childDeviceId: deviceId.toString())),
                  );
                } else if (state.pairingStatus.role == "parent") {
                  setState(() {
                    isPinSet = state.pairingStatus.isPinSet;
                  });
                  BlocProvider.of<GetParentProfileCubit>(context)
                      .getParentProfile(parentDeviceId: deviceId.toString());
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PairingScreen()),
                  );
                }
              } else if (state is PairingStatusErrorState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PairingScreen()),
                );
              }
            },
            child: BackgroundGradientColorWiget(
              child: Center(
                  child: Image.asset(
                "assets/logo/logo.png",
                height: 300,
              )),
            )),
      ),
    );
  }

  
}
