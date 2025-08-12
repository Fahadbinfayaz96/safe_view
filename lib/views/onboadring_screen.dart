import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/untilities/validators.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/bottom_navigation_bar.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/text_wiget.dart';

import '../blocs/create_parent_profile_cubit copy/create_parent_profile_cubit.dart';
import '../blocs/create_parent_profile_cubit copy/create_parent_profile_state.dart';

class OnboardingScreen extends StatefulWidget {
  final String parentDeviceId;
  const OnboardingScreen({super.key, required this.parentDeviceId});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController kidNameController = TextEditingController();

  @override
  void dispose() {
    parentNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    kidNameController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<CreateParentProfileCubit>(context).createParentProfile(
          parentDeviceId: widget.parentDeviceId,
          name: parentNameController.text,
          phoneNumber: phoneController.text,
          email: emailController.text,
          childName: kidNameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CreateParentProfileCubit, CreateParentProfileState>(
        listener: (context, state) {
          if (state is CreateParentProfileSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersistenBottomNavBarWiget(
                    deviceId: widget.parentDeviceId.toString(),
                    isParent: true,
                    isPinSet: false,
                    getParentProfileModel: state.createParentProfileModel.profile,
                  ),
                ));
          }
        },
        child: BackgroundGradientColorWiget(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      TextWidget(
                        text: "Welcome to safeview",
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        textAlignment: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                      buildInputField(
                        controller: parentNameController,
                        icon: Icons.person,
                        label: "Parent's Name",
                      ),
                      const SizedBox(height: 16),
                      buildInputField(
                        controller: phoneController,
                        icon: Icons.phone,
                        label: "Phone Number",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      buildInputField(
                        controller: emailController,
                        icon: Icons.email,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      buildInputField(
                        controller: kidNameController,
                        icon: Icons.child_care,
                        label: "Kid's Name",
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<CreateParentProfileCubit,
                          CreateParentProfileState>(
                        builder: (context, state) {
                          bool isLoading =
                              state is CreateParentProfileLoadingState
                                  ? true
                                  : false;
                          return isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.black,
                                )
                              : ButtonWiget(
                                  buttonText: "Continue",
                                  buttonFontSize: 16,
                                  onPressed: onSubmit);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (label == "Email") {
          return Validators.emailValidator(value);
        } else if (label == "Phone Number") {
          return Validators.phoneNumberValidator(value);
        } else if (value == null || value.trim().isEmpty) {
          return "required";
        }
        return null;
      },
      inputFormatters: [
        if (label == "Phone Number") ...[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ]
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.lightGrey),
        labelText: label,
        filled: true,
        fillColor: AppColors.transparent,
        labelStyle: const TextStyle(color: AppColors.lightGrey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.lightBlue3,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.lightBlue3)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.red)),
      ),
    );
  }
}
