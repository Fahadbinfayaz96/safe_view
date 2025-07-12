import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_state.dart';
import 'package:safe_view/blocs/update_content_filter_cubit/update_content_filter_cubit.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/jumping_dot_progress_indicator.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import 'package:safe_view/widgets/timer_widget.dart';

import '../blocs/get_content_filters_cubit/get_content_filters_state.dart';
import '../blocs/update_content_filter_cubit/update_content_filter_state.dart';
import '../untilities/app_colors.dart';
import '../widgets/retry_widget.dart';

class ParentHomeScreen extends StatefulWidget {
  final String parentDeviceId;
  const ParentHomeScreen({super.key, required this.parentDeviceId});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  bool isChildLocked = false;
  bool isContentFilterOn = false;
  int screenTimeLimit = 30;
  bool allowSearch = false;
  bool allowAutoplay = false;
  String? childDeviceId;
  List<String> selectedBlockedChannelCategories = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Map<String, String> youtubeCategories = {
    "1": "Film & Animation",
    "2": "Autos & Vehicles",
    "10": "Music",
    "15": "Pets & Animals",
    "17": "Sports",
    "18": "Short Movies",
    "19": "Travel & Events",
    "20": "Gaming",
    "21": "Videoblogging",
    "22": "People & Blogs",
    "23": "Comedy",
    "24": "Entertainment",
    "25": "News & Politics",
    "26": "Howto & Style",
    "27": "Education",
    "28": "Science & Technology",
    "29": "Nonprofits & Activism",
    "30": "Movies",
    "31": "Anime/Animation",
    "32": "Action/Adventure",
    "33": "Classics",
    "34": "Comedy",
    "35": "Documentary",
    "36": "Drama",
    "37": "Family",
    "38": "Foreign",
    "39": "Horror",
    "40": "Sci-Fi/Fantasy",
    "41": "Thriller",
    "42": "Shorts",
    "43": "Shows",
    "44": "Trailers",
  };

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? pin = await secureStorage.read(key: "parent_pin");
      showPinDialog(isSetup: pin == null || pin.isEmpty);
    });
    super.initState();
  }

  void _loadData() {
    BlocProvider.of<InfoCubit>(context)
        .getInfo(parentDeviceId: widget.parentDeviceId)
        .then((_) {
      _refreshController.refreshCompleted();
    }).catchError((error) {
      _refreshController.refreshFailed();
    });
  }

  void _onRefresh() {
    _loadData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void showPinDialog({required bool isSetup}) {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) => false,
          canPop: false,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSetup ? Icons.lock_outline : Icons.lock,
                    size: 40,
                    color: AppColors.blue,
                  ),
                  const SizedBox(height: 12),
                  TextWidget(
                    text: isSetup ? "Set Your Parent PIN" : "Unlock Settings",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: isSetup
                        ? "Enter a 4-digit PIN to protect your settings."
                        : "Enter your 4-digit PIN to continue.",
                    textAlignment: TextAlign.center,
                    textColor: AppColors.lightGrey,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 12,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: AppColors.lightGrey.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "••••",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonWiget(
                    buttonText: isSetup ? "Save PIN" : "Unlock",
                    buttonFontSize: 15,
                    onPressed: () async {
                      final enteredPin = pinController.text.trim();

                      if (enteredPin.length != 4) {
                        Fluttertoast.showToast(
                          msg: "Please enter a valid 4-digit PIN",
                        );
                        return;
                      }

                      if (isSetup) {
                        await secureStorage.write(
                            key: "parent_pin", value: enteredPin);
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "PIN set successfully");
                      } else {
                        final storedPin =
                            await secureStorage.read(key: "parent_pin");

                        if (enteredPin == storedPin && context.mounted) {
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: "Incorrect PIN");
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool hasInitialized = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(CupertinoIcons.lock_shield_fill),
            const SizedBox(
              width: 5,
            ),
            TextWidget(
              text: "Parent Mode",
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ],
        ),
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightBlue2,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpdateContentFilterCubit, UpdateContentFilterState>(
            listener: (context, state) async {
              if (state is UpdateContentFilterSuccessState) {
                Fluttertoast.showToast(msg: "Updated successfull");
                await BlocProvider.of<GetContentFiltersCubit>(context)
                    .getContentFilter(childDeviceId: childDeviceId.toString());
              }
            },
          ),
          BlocListener<InfoCubit, InfoState>(
            listener: (context, state) {
              if (state is InfoLoadedState) {
                setState(() {
                  childDeviceId = state.info.pairedWith;
                  BlocProvider.of<GetContentFiltersCubit>(context)
                      .getContentFilter(
                          childDeviceId: state.info.pairedWith.toString());
                });
              }
            },
          )
        ],
        child: BlocBuilder<GetContentFiltersCubit, GetContentFiltersState>(
          builder: (context, state) {
            if (state is GetContentFiltersLoadingState) {
              return const BackgroundGradientColorWiget(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.black,
                  ),
                ),
              );
            } else if (state is GetContentFiltersLoadedState) {
              final filters = state.getContentFilter;
              if (!hasInitialized && childDeviceId != null) {
                hasInitialized = true;
                isContentFilterOn = filters.blockUnsafeVideos ?? false;
                allowSearch = filters.allowSearch ?? false;
                allowAutoplay = filters.allowAutoplay ?? false;

                selectedBlockedChannelCategories =
                    List.from(filters.blockedCategories ?? []);

                screenTimeLimit =
                    (filters.screenTimeLimitMins ?? 15).clamp(15, 120);
                isChildLocked = filters.isLocked ?? false;
              }
              return Stack(
                children: [
                  const BackgroundGradientColorWiget(),
                  SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    enablePullDown: true,
                    enablePullUp: false,
                    header: const ClassicHeader(
                        idleText: "Pull down to refresh",
                        releaseText: "Release to refresh",
                        refreshingText: "Refreshing...",
                        completeText: "Refresh complete",
                        failedText: "Refresh failed",
                        textStyle: TextStyle(color: AppColors.black),
                        refreshingIcon: JumpingDots()),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Child Device: ",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        children: [
                                      TextSpan(
                                          text: childDeviceId != null
                                              ? "Connected"
                                              : "Not Connected",
                                          style: TextStyle(
                                              color: childDeviceId != null
                                                  ? AppColors.drakGreen
                                                  : AppColors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))
                                    ])),
                                Icon(Icons.check_circle,
                                    color: childDeviceId != null
                                        ? AppColors.drakGreen
                                        : AppColors.red),
                              ],
                            ),
                            const SizedBox(height: 20),
                            contentFilters(),
                            const SizedBox(height: 20),
                            blockChannelCategory(),
                            const SizedBox(height: 20),
                            screenTimeLimitSlider(),
                            const SizedBox(height: 30),
                            lockChildDevice(context),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocBuilder<UpdateContentFilterCubit,
                                UpdateContentFilterState>(
                              builder: (context, state) {
                                bool isLoading =
                                    state is UpdateContentFilterLoadingState
                                        ? true
                                        : false;
                                return isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.black,
                                        ),
                                      )
                                    : ButtonWiget(
                                        buttonText: "Update",
                                        buttonFontSize: 14,
                                        buttonBackgroundColor: AppColors.blue,
                                        onPressed: () {
                                          BlocProvider.of<
                                                      UpdateContentFilterCubit>(
                                                  context)
                                              .updateContentFilters(
                                            childDeviceId:
                                                childDeviceId.toString(),
                                            allowSearch: allowSearch,
                                            allowAutoplay: allowAutoplay,
                                            blockUnsafeVideos:
                                                isContentFilterOn,
                                            blockedCategories:
                                                selectedBlockedChannelCategories
                                                    .where((e) =>
                                                        e.trim().isNotEmpty)
                                                    .toList(),
                                            screenTimeLimit: screenTimeLimit,
                                          );
                                        });
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return retryWidget(
                  onPress: () {
                    _loadData();
                  },
                  errorMessage: "Something went wrong");
            }
          },
        ),
      ),
    );
  }

  Widget lockChildDevice(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isChildLocked
            ? AppColors.red.withOpacity(0.1)
            : AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isChildLocked ? AppColors.red : AppColors.blue,
          width: 1.5,
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: TextWidget(
          text: "Lock Child App",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textColor: AppColors.black,
        ),
        secondary: Icon(
          isChildLocked ? Icons.lock : Icons.lock_open,
          color: isChildLocked ? AppColors.red : AppColors.blue,
        ),
        activeColor: AppColors.red,
        inactiveThumbColor: AppColors.lightGrey,
        value: isChildLocked,
        onChanged: (value) {
          setState(() {
            isChildLocked = value;
          });

          BlocProvider.of<UpdateContentFilterCubit>(context)
              .updateContentFilters(
            childDeviceId: childDeviceId.toString(),
            allowSearch: allowSearch,
            allowAutoplay: allowAutoplay,
            blockUnsafeVideos: isContentFilterOn,
            blockedCategories: selectedBlockedChannelCategories
                .where((e) => e.trim().isNotEmpty)
                .toList(),
            screenTimeLimit: screenTimeLimit,
            isLocked: isChildLocked,
          );
        },
      ),
    );
  }

  Widget contentFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: AppColors.lightGrey),
        const SizedBox(height: 20),
        const Text(
          "Content Filters :",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SwitchListTile(
          value: isContentFilterOn,
          activeThumbColor: AppColors.blue,
          inactiveThumbColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.all(0),
          title: TextWidget(text: "Block unsafe videos"),
          onChanged: (val) {
            setState(() {
              isContentFilterOn = val;
            });
          },
        ),
        SwitchListTile(
          value: allowSearch,
          activeThumbColor: AppColors.blue,
          inactiveThumbColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.all(0),
          title: TextWidget(text: "Allow Search"),
          onChanged: (val) {
            setState(() {
              allowSearch = val;
            });
          },
        ),
        SwitchListTile(
          value: allowAutoplay,
          activeThumbColor: AppColors.blue,
          inactiveThumbColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.all(0),
          title: TextWidget(text: "Allow Autoplay"),
          onChanged: (val) {
            setState(() {
              allowAutoplay = val;
            });
          },
        ),
      ],
    );
  }

  Widget blockChannelCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: "Blocked Categories:",
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            List<String> tempSelected =
                List.from(selectedBlockedChannelCategories);

            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateDialog) {
                    bool isAllSelected =
                        tempSelected.length == youtubeCategories.length;
                    bool isPartialSelection = tempSelected.isNotEmpty &&
                        tempSelected.length >= 2 &&
                        tempSelected.length < youtubeCategories.length;
                    return AlertDialog(
                      backgroundColor: AppColors.white,
                      title: Column(
                        children: [
                          TextWidget(
                            text: "Select Categories",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            textColor: AppColors.black,
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                if (isAllSelected || isPartialSelection) {
                                  tempSelected.clear();
                                } else {
                                  tempSelected =
                                      youtubeCategories.keys.toList();
                                }
                              });
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue2.withOpacity(0.15),
                                border: Border.all(color: AppColors.lightBlue3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: isAllSelected || isPartialSelection
                                        ? "Deselect All"
                                        : "Select All",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppColors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    isAllSelected || isPartialSelection
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isAllSelected || isPartialSelection
                                        ? AppColors.blue
                                        : AppColors.black,
                                    size: 19,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: youtubeCategories.entries.map((item) {
                            return CheckboxListTile(
                              value: tempSelected.contains(item.key),
                              activeColor: AppColors.blue,
                              title: TextWidget(
                                text: item.value,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? selected) {
                                setStateDialog(() {
                                  if (selected == true) {
                                    tempSelected.add(item.key);
                                  } else {
                                    tempSelected.remove(item.key);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: TextWidget(
                            text: "Cancel",
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedBlockedChannelCategories =
                                  List.from(tempSelected);
                            });

                            Navigator.pop(context);
                          },
                          child: TextWidget(
                            text: "OK",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightBlue1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                    text: selectedBlockedChannelCategories.isEmpty
                        ? "Select categories to block"
                        : selectedBlockedChannelCategories
                            .map((id) => youtubeCategories[id] ?? id)
                            .join(", "),
                    textColor: selectedBlockedChannelCategories.isEmpty
                        ? AppColors.lightGrey
                        : AppColors.black,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.lightBlue3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget screenTimeLimitSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: "Screen Time Limit (per day)",
        ),
        const SizedBox(
          height: 10,
        ),
        Slider(
          value: screenTimeLimit.toDouble(),
          min: 2,
          max: 600,
          activeColor: AppColors.blue,
          divisions: ((600 - 30) ~/ 30),
          onChanged: (val) {
            setState(() {
              screenTimeLimit = val.toInt();
            });
          },
        ),
        RichText(
            text: TextSpan(
                text: "Selected Limit:",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                children: [
              TextSpan(
                  text: " ${(screenTimeLimit ~/ 60)}h ${screenTimeLimit % 60}m",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.blue,
                  ))
            ])),
      ],
    );
  }
}
