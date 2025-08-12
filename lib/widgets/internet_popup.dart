import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/widgets/text_wiget.dart';

class InternetController extends GetxController {
  Connectivity connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    connectivity.onConnectivityChanged.listen(netstatus);
    WidgetsBinding.instance.addObserver(observer);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(observer);
    super.onClose();
  }

  final observer = LifecycleEventHandler(
    resumeCallBack: (state) async {
      var connectivityResult = await Connectivity().checkConnectivity();
      netstatus(connectivityResult);
    },
  );
}

netstatus(List<ConnectivityResult> result) async {
  bool hasInternet = result.any((result) =>
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet);
  if (!hasInternet) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
          PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) => () {},
            child: Container(
              color: AppColors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  TextWidget(
                    text: "No Internet Connection",
                    fontSize: 21,
                    textColor: AppColors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SvgPicture.asset(
                        "assets/images/no_internet.svg",
                        height: 240,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: "Check you internet connection and try again",
                    textColor: Colors.black,
                    fontWeight: FontWeight.w600,
                    textAlignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Connectivity().checkConnectivity();
                          log("hasInternet and Get.isDialogOpen..... $hasInternet ${Get.isDialogOpen}");
                      if (hasInternet && Get.isDialogOpen == true) {

                        Get.back();
                      } else {
                        log("Internet not restored yet");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: const Size(350, 50),
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: TextWidget(
                      text: 'Refresh',
                      textColor: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          useSafeArea: false,
          barrierDismissible: false);
    }
  } else {
    if (hasInternet && Get.isDialogOpen == true) {
      Get.back();
      // log("resssssss $result");
    } else {
      log("Internet not restored yet");
    }
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({required this.resumeCallBack});

  final Future Function(AppLifecycleState state) resumeCallBack;

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    // log("state $state");
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack(state);
        break;
      default:
        break;
    }
  }
}
