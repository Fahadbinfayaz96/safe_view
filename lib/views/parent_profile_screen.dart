import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:safe_view/blocs/edit_parent_profile_cubit/edit_parent_profile_cubit.dart';
import 'package:safe_view/blocs/edit_parent_profile_cubit/edit_parent_profile_state.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_state.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_cubit.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_state.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/untilities/validators.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/retry_widget.dart';
import 'package:safe_view/widgets/text_wiget.dart';

import '../blocs/get_parent_profile_cubit/get_parent_profile_cubit.dart';

class ParentProfileScreen extends StatefulWidget {
  final String parentDeviceId;
  const ParentProfileScreen({super.key, required this.parentDeviceId});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController kidNameController = TextEditingController();

  bool isEditMode = false;

  void toggleEditMode() {
    setState(() => isEditMode = !isEditMode);
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      toggleEditMode();
      BlocProvider.of<EditParentProfileCubit>(context).editParentProfile(
          parentDeviceId: widget.parentDeviceId,
          name: parentNameController.text,
          phoneNumber: phoneController.text,
          email: emailController.text,
          childName: kidNameController.text);
    }
  }

  @override
  void initState() {
    BlocProvider.of<GetParentProfileCubit>(context)
        .getParentProfile(parentDeviceId: widget.parentDeviceId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => false,
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBlue1,
        appBar: AppBar(
          title: TextWidget(
            text: "Profile",
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.lightBlue2,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: GestureDetector(
            onTap: isEditMode
                ? () {
                    toggleEditMode();
                  }
                : () {},
            child: Icon(
              CupertinoIcons.xmark,
              color: isEditMode ? AppColors.black : AppColors.lightBlue2,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isEditMode ? Icons.check : Icons.edit),
              onPressed: isEditMode ? saveProfile : toggleEditMode,
            ),
          ],
        ),
        body: BlocListener<UpgradeCubit, UpgradeState>(
          listener: (context, state) {
            if (state is UpgradeSuccessState) {
              Fluttertoast.showToast(
                  msg: "Thanks! We've received your upgrade request.");
            } else if (state is AlreadyRequestedUpgradeState) {
              Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 3);
            } else if (state is UpgradeErrorState) {
              Fluttertoast.showToast(
                  msg: state.errorMessage,
                  timeInSecForIosWeb: 2,
                  toastLength: Toast.LENGTH_LONG);
            }
          },
          child: BlocListener<EditParentProfileCubit, EditParentProfileState>(
            listener: (context, state) {
              if (state is EditParentProfileSuccessState) {
                Fluttertoast.showToast(msg: "Profile Updated");
                BlocProvider.of<GetParentProfileCubit>(context)
                    .getParentProfile(parentDeviceId: widget.parentDeviceId);
              }
            },
            child: BlocBuilder<GetParentProfileCubit, GetParentProfileState>(
              builder: (context, state) {
                if (state is GetParentProfileLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                    ),
                  );
                } else if (state is GetParentProfileLoadedState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    parentNameController.text =
                        state.getParentProfileModel.name ?? '';
                    emailController.text =
                        state.getParentProfileModel.email ?? '';
                    phoneController.text =
                        state.getParentProfileModel.phone ?? '';
                    kidNameController.text =
                        state.getParentProfileModel.kidName ?? '';
                  });

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.lightBlue2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.lightBlue2,
                                    spreadRadius: 1,
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.person,
                              size: 50, color: AppColors.blue),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 400,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.lightBlue2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.lightBlue2,
                                    spreadRadius: 1,
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildField("Parent Name", parentNameController),
                                buildField("Email", emailController,
                                    validator: Validators.emailValidator,
                                    keyboardType: TextInputType.emailAddress),
                                buildField("Phone Number", phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    validator: Validators.phoneNumberValidator),
                                buildField("Kid Name", kidNameController),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<UpgradeCubit, UpgradeState>(
                          builder: (context, state) {
                            bool isLoading =
                                state is UpgradeLoadingState ? true : false;
                            return isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.black,
                                    ),
                                  )
                                : ButtonWiget(
                                    buttonText: "Go Premium",
                                    buttonFontSize: 18,
                                    onPressed: () {
                                      BlocProvider.of<UpgradeCubit>(context)
                                          .upgradeRequest(
                                              parentDeviceId:
                                                  widget.parentDeviceId,
                                              name: parentNameController.text,
                                              phoneNumber: phoneController.text,
                                              email: emailController.text,
                                              childName:
                                                  kidNameController.text);
                                    },
                                    buttonBackgroundColor: AppColors.red,
                                  );
                          },
                        )
                      ],
                    ),
                  );
                } else if (state is GetParentProfileEmptyState) {
                  return retryWidget(
                      onPress: () {
                        BlocProvider.of<GetParentProfileCubit>(context)
                            .getParentProfile(
                                parentDeviceId: widget.parentDeviceId);
                      },
                      errorMessage: state.emptyMessage);
                } else if (state is GetParentProfileErrorState) {
                  return retryWidget(
                      onPress: () {
                        BlocProvider.of<GetParentProfileCubit>(context)
                            .getParentProfile(
                                parentDeviceId: widget.parentDeviceId);
                      },
                      errorMessage: state.errorMessage);
                } else {
                  return Center(
                    child: TextWidget(text: "Something went wrong"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: isEditMode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return "Required";
              }
              return null;
            },
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: AppColors.lightGrey),
          labelText: label,
          filled: true,
          fillColor: AppColors.transparent,
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
      ),
    );
  }
}
