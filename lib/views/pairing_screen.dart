import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_view/blocs/generate_code_cubit/generate_code_cubit.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/views/verify_code_screen.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/text_wiget.dart';

import '../blocs/generate_code_cubit/generate_code_state.dart';
import '../widgets/skeleton_loader.dart';
import 'generate_code_screen.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  int selectedOption = 0;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDeviceId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue2,
      ),
      body: BlocListener<GenerateCodeCubit, GenerateCodeState>(
        listener: (context, state) {
          log("state..........$state");
          if (state is CodeGeneratedState &&
              ModalRoute.of(context)?.isCurrent == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GenerateCodeScreen(
                          generatedCode: state.generateCode.code.toString(),
                          childDeviceId: deviceId.toString(),
                        )));
          }
        },
        child: BackgroundGradientColorWiget(
          padding:  20,
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: TextWidget(
                  text: "Welcome to SafeView",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextWidget(
                  text: "This app must be linked to begin.",
                  textColor: AppColors.charcoalGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              TextWidget(
                text: "Please choose how you want to proceed:",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              const SizedBox(height: 20),
              BlocBuilder<GenerateCodeCubit, GenerateCodeState>(
                builder: (context, state) {
                  bool isLoading =
                      state is GenerateCodeLoadingState ? true : false;
                  return isLoading
                      ? skeletonLoader()
                      : buildOptionCard(
                          index: 0,
                          emoji: "📱",
                          childDeviceId: deviceId,
                          title: "Set up this phone as a child’s device",
                          subtitle: "Show Setup Code",
                        );
                },
              ),
              const SizedBox(height: 20),
              buildOptionCard(
                index: 1,
                emoji: "🔐",
                title: "I have a setup code from my child",
                subtitle: "Enter Setup Code",
              ),
              const Spacer(),
              TextWidget(
                text:
                    "You’ll need two devices to complete this setup securely.",
                textColor: AppColors.lightBlack,
                textAlignment: TextAlign.center,
                fontSize: 14,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionCard(
      {required int index,
      required String emoji,
      required String title,
      required String subtitle,
      String? childDeviceId}) {
    final isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedOption = index;
        });

        if (selectedOption == 0) {
          await BlocProvider.of<GenerateCodeCubit>(context)
              .generateCode(childDeviceId: childDeviceId.toString());
        } else {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const VerifyCodeScreen()));
        }
      },
      child: SizedBox(
        height: 110,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(18),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightBlue2 : AppColors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.lightBlue3 : AppColors.lightBlue3,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.lightBlue3.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(text: emoji, fontSize: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text: subtitle,
                      fontSize: 14,
                      textColor: AppColors.lightBlack,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
