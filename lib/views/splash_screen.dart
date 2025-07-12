// splash_screen.dart
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_view/blocs/pairing_status_cubit/pairing_status_cubit.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/views/child_home_screen.dart';
import 'package:safe_view/views/parent_home_screen.dart';
import 'package:safe_view/views/pairing_screen.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/bottom_navigation_bar.dart';
import 'package:safe_view/widgets/timer_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? deviceId;
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await  fetchDeviceId();
       BlocProvider.of<PairingStatusCubit>(context)
          .getPairingStatus(deviceId: deviceId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue2,
      ),
      body: BlocListener<PairingStatusCubit, PairingStatusState>(
          listener: (context, state) async {
              log("Current Pairing State: $state");
            if (state is PairingStatusLoadedState) {
              if (state.pairingStatus.role == "child" &&
                  state.pairingStatus.isVerified == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChildHomeScreen(
                            childDeviceId: deviceId.toString(),
                          )),
                );
              } else if (state.pairingStatus.role == "parent") {
                log("state.pairingStatus.role ");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PersistenBottomNavBarWiget(
                      parentDeviceId: deviceId.toString(),
                    ),
                  ),
                  (route) => false,
                );
              } else {
                await const FlutterSecureStorage().delete(key: "parent_pin");
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
    );
  }
}
