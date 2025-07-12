import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_view/blocs/verify_code_cubit/verify_code_cubit.dart';
import 'package:safe_view/blocs/verify_code_cubit/verify_code_state.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/views/parent_home_screen.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/text_wiget.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  String? deviceId;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDeviceId();
    });
  }

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
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify code"),
        backgroundColor: AppColors.lightBlue2,
        centerTitle: true,
      ),
      body: BlocListener<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state is VerifiedCodeState) {
            Fluttertoast.showToast(msg: state.verifyCode.message.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentHomeScreen(
                    parentDeviceId: deviceId.toString(),
                  ),
                ));
          } else if (state is VerifyCodeErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage.toString());
          }
        },
        child: Form(
          key: formKey,
          child: BackgroundGradientColorWiget(
           padding: 20,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Icon(Icons.qr_code_2_rounded,
                    size: 60, color: AppColors.blue),
                const SizedBox(height: 16),
                TextWidget(
                    text: "Enter the setup code from your child’s phone",
                    textAlignment: TextAlign.center,
                    fontSize: 18),
                const SizedBox(height: 24),
                TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 10),
                  decoration: InputDecoration(
                    hintText: "______",
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.lightBlue3,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: AppColors.lightBlue3)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.red)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length != 6) {
                      return 'Please enter a valid 6-digit code.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                  builder: (context, state) {
                    bool isLoading =
                        state is VerifyCodeLoadingState ? true : false;
                    return isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.black,
                            ),
                          )
                        : ButtonWiget(
                            buttonText: "Verify and Continue",
                            buttonFontSize: 15,
                            buttonBackgroundColor: AppColors.blue,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<VerifyCodeCubit>(context)
                                    .verifyCode(
                                        parentDeviceId: deviceId.toString(),
                                        pairingCode:
                                            codeController.text.trim());
                              }
                            });
                  },
                ),
                const SizedBox(height: 60),
                TextWidget(
                  text:
                      "Make sure this code was shown on the child's phone.It won’t work if generated on this device.",
                  textAlignment: TextAlign.center,
                  fontSize: 15,
                  textColor: AppColors.lightBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
