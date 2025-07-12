import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_view/blocs/pairing_status_cubit/pairing_status_cubit.dart';
import 'package:safe_view/views/child_home_screen.dart';
import 'package:safe_view/views/pairing_screen.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import 'dart:async';

import '../blocs/generate_code_cubit/generate_code_cubit.dart';
import '../blocs/generate_code_cubit/generate_code_state.dart';
import '../untilities/app_colors.dart';

class GenerateCodeScreen extends StatefulWidget {
  String generatedCode;
  final String childDeviceId;
  GenerateCodeScreen(
      {super.key, required this.generatedCode, required this.childDeviceId});

  @override
  State<GenerateCodeScreen> createState() => _GenerateCodeScreenState();
}

class _GenerateCodeScreenState extends State<GenerateCodeScreen> {
  Duration remainingTime = const Duration(minutes: 10);
  Timer? countdownTimer;
  Timer? statusCheckTimer;
  String? currentCode;
  @override
  void initState() {
    super.initState();
    currentCode = widget.generatedCode;
    startCountdown();
    startStatusChecks();
  }

  void startStatusChecks() {
    BlocProvider.of<PairingStatusCubit>(context)
        .getPairingStatus(deviceId: widget.childDeviceId);

    statusCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      BlocProvider.of<PairingStatusCubit>(context)
          .getPairingStatus(deviceId: widget.childDeviceId);
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    statusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeText =
        "${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate code"),
        centerTitle: true,
        backgroundColor: AppColors.lightBlue2,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GenerateCodeCubit, GenerateCodeState>(
            listener: (context, state) {
              if (state is CodeGeneratedState) {
                setState(() {
                  currentCode = state.generateCode.code.toString();
                  remainingTime = const Duration(minutes: 10);
                  countdownTimer?.cancel();
                  startCountdown();
                });
              }
            },
          ),
          BlocListener<PairingStatusCubit, PairingStatusState>(
            listener: (context, state) {
              log("state...........$state");
              if (state is PairingStatusLoadedState) {
                if (state.pairingStatus.role == "child" &&
                    state.pairingStatus.isVerified == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  ChildHomeScreen(childDeviceId: widget.childDeviceId,)),
                  );
                }
              } else if (state is PairingStatusErrorState) {
                Fluttertoast.showToast(msg: state.errorMessage);
              }
            },
          ),
        ],
        child: BackgroundGradientColorWiget(
          padding: 20,
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.lock, size: 60, color: AppColors.blue),
              const SizedBox(height: 16),
              TextWidget(
                text:
                    "This device is in locked mode.\nAsk your parent to set it up.",
                textAlignment: TextAlign.center,
                fontSize: 18,
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextWidget(
                  text: currentCode!.split('').join('  '),
                  fontSize: 32,
                  letterSpacing: 4,
                  textColor: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextWidget(
                text: "Expires in $timeText",
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () async {
                  await BlocProvider.of<GenerateCodeCubit>(context)
                      .generateCode(
                          childDeviceId: widget.childDeviceId.toString());
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.black,
                ),
                label: TextWidget(text: "Regenerate Code"),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.lightBlue1,
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.lightBlue3,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        text:
                            "This code can only be used from a different device. if you’re the parent, install SafeView on your phone and choose",
                        style: TextStyle(
                          color: AppColors.charcoalGrey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                              text: "\n\nEnter Setup Code to continue.",
                              style: TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
