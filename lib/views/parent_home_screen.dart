// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_cubit.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_cubit.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_state.dart';
import 'package:safe_view/blocs/info_cubit/info_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_state.dart';
import 'package:safe_view/blocs/set_pin_cubit/set_pin_cubit.dart';
import 'package:safe_view/blocs/set_pin_cubit/set_pin_state.dart';
import 'package:safe_view/blocs/trail_status_cubit/trail_status_cubit.dart';
import 'package:safe_view/blocs/trail_status_cubit/trail_status_state.dart';
import 'package:safe_view/blocs/unlink_device_cubit/unlink_device_cubit.dart';
import 'package:safe_view/blocs/unlink_device_cubit/unlink_device_state.dart';
import 'package:safe_view/blocs/update_content_filter_cubit/update_content_filter_cubit.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_cubit.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_state.dart';
import 'package:safe_view/blocs/verify_pin_cubit/verify_pin_cubit.dart';
import 'package:safe_view/blocs/verify_pin_cubit/verify_pin_state.dart';
import 'package:safe_view/main.dart';
import 'package:safe_view/models/get_content_filter_model.dart';
import 'package:safe_view/models/get_parent_profile_model.dart'
    show GetParentProfileModel;
import 'package:safe_view/views/pairing_screen.dart';
import 'package:safe_view/widgets/button_widget.dart';
import 'package:safe_view/widgets/jumping_dot_progress_indicator.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../blocs/get_content_filters_cubit/get_content_filters_state.dart';
import '../blocs/update_content_filter_cubit/update_content_filter_state.dart';
import '../untilities/app_colors.dart';
import '../widgets/retry_widget.dart';

class ParentHomeScreen extends StatefulWidget {
  final String parentDeviceId;
  final bool isPinSet;
  final getParentProfileModel;
  const ParentHomeScreen(
      {super.key,
      required this.parentDeviceId,
      required this.isPinSet,
      required this.getParentProfileModel});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  bool isChildLocked = false;
  bool isContentFilterOn = false;
  int screenTimeLimit = 30;
  bool allowSearch = false;
  bool allowAutoplay = false;

  bool hasInitialized = false;

  String? childDeviceId;
  List<String> selectedBlockedChannelCategories = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late IO.Socket socket;
  Map<String, String> youtubeCategories = {
    "1": "Film & Animation",
    "2": "Autos & Vehicles",
    "10": "Music",
//"15": "Pets & Animals",
    "17": "Sports",
    // "18": "Short Movies",
    // "19": "Travel & Events",
    "20": "Gaming",
    //"21": "Videoblogging",
    "22": "People & Blogs",
    "23": "Comedy",
    "24": "Entertainment",
    "25": "News & Politics",
    "26": "Howto & Style",
    "27": "Education",
    "28": "Science & Technology",
    "29": "Nonprofits & Activism",
    // "30": "Movies",
    // "31": "Anime/Animation",
    // "32": "Action/Adventure",
    // "33": "Classics",
    // "34": "Comedy",
    // "35": "Documentary",
    // "36": "Drama",
    // "37": "Family",
    // "38": "Foreign",
    // "39": "Horror",
    // "40": "Sci-Fi/Fantasy",
    // "41": "Thriller",
    // "42": "Shorts",
    // "43": "Shows",
    // "44": "Trailers",
  };

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializeSocket();

      showPinDialog();
    });
    super.initState();
  }

  initializeSocket() {
    socket = IO.io(
      'https://safeview-backend.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
    socket.onConnect((_) {
      log("Emitting join for device: ${widget.parentDeviceId}");
      if (!mounted) return;
      if (childDeviceId != null) {
        log("Emitting join for childDeviceId: $childDeviceId");
        socket.emit("join", childDeviceId);
      }

      if (widget.parentDeviceId.isNotEmpty) {
        log("Emitting join for parentDeviceId: ${widget.parentDeviceId}");
        socket.emit("join", widget.parentDeviceId);
      }
    });
    socket.on("contentUpdated", (data) {
      if (!mounted || childDeviceId == null) return;

      BlocProvider.of<GetContentFiltersCubit>(context).getContentFilter(
          childDeviceId: childDeviceId.toString(), fromSocket: true);
      // if (childDeviceId != null && mounted) {
      //   BlocProvider.of<GetContentFiltersCubit>(context).getContentFilter(
      //       childDeviceId: childDeviceId.toString(), fromSocket: true);
      // }
      // setState(() {
      //   originalFilters = GetContentFilterModel.fromJson(data['settings']);
      //   currentFilters = GetContentFilterModel.fromJson(data['settings']);
      hasPendingChanges = false;
      //   hasInitialized = false;
      // });
    });
    socket.on("subscriptionStatus", (data) {
      log("📦 Subscription Started: $data");
      try {
        Navigator.pop(MyApp.navigatorKey.currentContext!);
      } catch (e) {
        log("Dialog pop failed: $e");
      }

      BlocProvider.of<GetParentProfileCubit>(MyApp.navigatorKey.currentContext!)
          .getParentProfile(parentDeviceId: widget.parentDeviceId.toString());
    });

    socket.on("subscriptionExpired", (data) {
      log("❌ Subscription Expired: $data");
      BlocProvider.of<GetParentProfileCubit>(MyApp.navigatorKey.currentContext!)
          .getParentProfile(parentDeviceId: widget.parentDeviceId.toString());
    });
    socket.on("trialExpired", (data) {
      BlocProvider.of<GetParentProfileCubit>(MyApp.navigatorKey.currentContext!)
          .getParentProfile(parentDeviceId: widget.parentDeviceId.toString());

      log("data........$data");
    });
    socket.onDisconnect((_) {
      log("❌ Socket disconnected!");
      if (mounted) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) socket.connect();
        });
      }
    });

    socket.onConnectError((err) {
      log("⚠️ Socket error: $err");
      if (mounted) {
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) socket.connect();
        });
      }
    });
  }

  void _loadData() {
    BlocProvider.of<InfoCubit>(context)
        .getInfo(parentDeviceId: widget.parentDeviceId)
        .then((_) {
      BlocProvider.of<GetParentProfileCubit>(MyApp.navigatorKey.currentContext!)
          .getParentProfile(parentDeviceId: widget.parentDeviceId.toString());
      _refreshController.refreshCompleted();
    }).catchError((error) {
      _refreshController.refreshFailed();
    });
  }

  void _onRefresh() {
    hasInitialized = false;
    hasPendingChanges = false;
    _loadData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  GetContentFilterModel? originalFilters;
  GetContentFilterModel? currentFilters;
  bool hasPendingChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => false,
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBlue1,
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
          actions: [
            if (hasPendingChanges)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Chip(
                  label: Text('UNSAVED CHANGES'),
                  backgroundColor: AppColors.red,
                  labelStyle: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  side: BorderSide(color: AppColors.red),
                ),
              )
          ],
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
                      .getContentFilter(
                          childDeviceId: childDeviceId.toString());

                  setState(() {
                    originalFilters = currentFilters;
                    hasPendingChanges = false;
                  });
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
            ),
            BlocListener<UnlinkDeviceCubit, UnlinkDeviceState>(
              listener: (context, state) {
                if (state is UnlinkDeviceUnlinkSuccessState) {
                  Fluttertoast.showToast(
                      msg: state.unlinkDevice.message.toString());

                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return const PairingScreen();
                      },
                    ),
                    (_) => false,
                  );
                } else if (state is UnlinkDeviceErrorState) {
                  Fluttertoast.showToast(msg: state.errorMessage);
                }
              },
            ),
            BlocListener<GetParentProfileCubit, GetParentProfileState>(
              listener: (context, state) {
                if (state is GetParentProfileLoadedState) {
                  final getProfile = state.getParentProfileModel;
                  bool isSubscribed = getProfile.subscriptionOver == true &&
                      getProfile.subscriptionHistory != null &&
                      getProfile.subscriptionHistory!.isNotEmpty;
                  bool isTrailOver = getProfile.isTrialExpired == true &&
                      getProfile.subscriptionHistory == null &&
                      getProfile.subscriptionHistory!.isEmpty;
                  if (isSubscribed || isTrailOver) {
                    showTrialOverOrSubscriptionPopup(
                        context, isSubscribed, isTrailOver);
                  }
                }
              },
            ),
            BlocListener<UpgradeCubit, UpgradeState>(
              listener: (context, state) {
                if (state is UpgradeSuccessState) {
                  Fluttertoast.showToast(
                      msg: state.upgradeModel.message.toString());
                } else if (state is AlreadyRequestedUpgradeState) {
                  Fluttertoast.showToast(msg: state.message);
                }
              },
            )
          ],
          child: BlocBuilder<GetContentFiltersCubit, GetContentFiltersState>(
            builder: (context, state) {
              if (state is GetContentFiltersLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.black,
                  ),
                );
              } else if (state is GetContentFiltersLoadedState) {
                final filters = state.getContentFilter;

                final isNewData = originalFilters?.toJson().toString() !=
                    filters.toJson().toString();

                if (!hasInitialized || isNewData) {
                  isContentFilterOn = filters.blockUnsafeVideos ?? false;
                  allowSearch = filters.allowSearch ?? false;
                  allowAutoplay = filters.allowAutoplay ?? false;
                  isChildLocked = filters.isLocked ?? false;
                  selectedBlockedChannelCategories =
                      List.from(filters.blockedCategories ?? []);
                  screenTimeLimit = filters.screenTimeLimitMins ?? 30;
                  originalFilters = filters;
                  currentFilters = filters.copyWith();
                  hasPendingChanges = false;
                  hasInitialized = true;
                }

                // if (childDeviceId != null) {
                //   if (!hasInitialized) {
                //     isContentFilterOn = filters.blockUnsafeVideos ?? false;
                //     allowSearch = filters.allowSearch ?? false;
                //     allowAutoplay = filters.allowAutoplay ?? false;
                //     isChildLocked = filters.isLocked ?? false;
                //     selectedBlockedChannelCategories =
                //         List.from(filters.blockedCategories ?? []);
                //     screenTimeLimit =
                //         (filters.screenTimeLimitMins ?? 15).clamp(15, 120);

                //     originalFilters = filters;
                //     currentFilters = filters.copyWith();
                //     hasInitialized = true;
                //   }
                //}

                return SmartRefresher(
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
                                      buttonBackgroundColor: !hasPendingChanges
                                          ? AppColors.lightGrey
                                          : AppColors.blue,
                                      onPressed: !hasPendingChanges
                                          ? () {}
                                          : () {
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
                                                screenTimeLimit:
                                                    screenTimeLimit,
                                              );
                                            });
                            },
                          ),
                          const SizedBox(height: 10),
                          ButtonWiget(
                              buttonText: "Unlink Device",
                              buttonFontSize: 14,
                              buttonBackgroundColor: AppColors.red,
                              onPressed: showUnlinkConfirmation),
                          const SizedBox(height: 50),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
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
            if (value && !isChildLocked) {
              screenTimeLimit = (screenTimeLimit + 30).clamp(30, 600);
            } else if (!value && isChildLocked) {
              screenTimeLimit = (screenTimeLimit - 30).clamp(30, 600);
            }
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

              currentFilters = currentFilters?.copyWith(blockUnsafeVideos: val);
              hasPendingChanges = !currentFilters!.isEqualTo(originalFilters!);
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
              currentFilters = currentFilters?.copyWith(allowSearch: val);
              hasPendingChanges = !currentFilters!.isEqualTo(originalFilters!);
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
              currentFilters = currentFilters?.copyWith(allowAutoplay: val);
              hasPendingChanges = !currentFilters!.isEqualTo(originalFilters!);
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
                              width: 155,
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
                              currentFilters = currentFilters?.copyWith(
                                  blockedCategories:
                                      selectedBlockedChannelCategories);

                              hasPendingChanges =
                                  !currentFilters!.isEqualTo(originalFilters!);
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
          value: screenTimeLimit.clamp(30, 600).toDouble(),
          min: 30,
          max: 600,
          activeColor: AppColors.blue,
          divisions: ((600 - 30) ~/ 30),
          onChanged: (val) {
            setState(() {
              screenTimeLimit = val.toInt();
              currentFilters = currentFilters?.copyWith(
                  screenTimeLimitMins: screenTimeLimit);
              hasPendingChanges = !currentFilters!.isEqualTo(originalFilters!);
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

  void showTrialOverOrSubscriptionPopup(
      BuildContext context, bool isSubscribed, bool isTrailOver) {
    showGeneralDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: isSubscribed
                        ? "Please subscribe"
                        : isTrailOver
                            ? "Trial Expired"
                            : "",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  TextWidget(
                    text: isSubscribed
                        ? "Your subscription is expired. Please upgrade to continue using the app"
                        : isTrailOver
                            ? "Your free trial has ended. Please upgrade to continue using the app."
                            : "",
                    textAlignment: TextAlign.center,
                    fontWeight: FontWeight.normal,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<UpgradeCubit, UpgradeState>(
                    builder: (context, state) {
                      final bool isLoading =
                          state is UpgradeLoadingState ? true : false;
                      return isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.black,
                            )
                          : ButtonWiget(
                              buttonText: isSubscribed
                                  ? "subscribe"
                                  : isTrailOver
                                      ? "Upgrade"
                                      : "",
                              buttonFontSize: 14,
                              onPressed: () {
                                BlocProvider.of<UpgradeCubit>(context)
                                    .upgradeRequest(
                                        parentDeviceId: widget.parentDeviceId,
                                        name: widget.getParentProfileModel.name
                                            .toString(),
                                        phoneNumber: widget
                                            .getParentProfileModel.phone
                                            .toString(),
                                        email: widget
                                            .getParentProfileModel.email
                                            .toString(),
                                        childName: widget
                                            .getParentProfileModel.kidName
                                            .toString());
                                // Navigator.pop(context);
                              },
                            );
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

  void showPinDialog() {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) => false,
          canPop: false,
          child: BlocConsumer<VerifyPinCubit, VerifyPinState>(
            listener: (context, state) {
              if (state is VerifyPinSuccessState) {
                Navigator.pop(context);

                Fluttertoast.showToast(msg: "PIN verified");
              } else if (state is VerifyPinErrorState) {
                Fluttertoast.showToast(msg: "Incorrect PIN");
              }
            },
            builder: (context, verifyState) {
              return BlocConsumer<SetPinCubit, SetPinState>(
                listener: (context, state) {
                  if (state is SetPinSuccessState) {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "PIN set successfully");
                  } else if (state is SetPinErrorState) {
                    Fluttertoast.showToast(msg: "Failed to set PIN");
                  }
                },
                builder: (context, setState) {
                  final bool isLoading = verifyState is VerifyPinLoadingState ||
                      setState is SetPinLoadingState;

                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            !widget.isPinSet ? Icons.lock_outline : Icons.lock,
                            size: 40,
                            color: AppColors.blue,
                          ),
                          const SizedBox(height: 12),
                          TextWidget(
                            text: !widget.isPinSet
                                ? "Set Your Parent PIN"
                                : "Unlock Settings",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          TextWidget(
                            text: !widget.isPinSet
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
                          isLoading
                              ? const CircularProgressIndicator()
                              : ButtonWiget(
                                  buttonText:
                                      !widget.isPinSet ? "Save PIN" : "Unlock",
                                  buttonFontSize: 15,
                                  onPressed: () {
                                    final enteredPin =
                                        pinController.text.trim();

                                    if (enteredPin.length != 4) {
                                      Fluttertoast.showToast(
                                        msg: "Please enter a valid 4-digit PIN",
                                      );
                                      return;
                                    }

                                    if (!widget.isPinSet) {
                                      BlocProvider.of<SetPinCubit>(context)
                                          .setPin(
                                              parentDeviceId:
                                                  widget.parentDeviceId,
                                              pin: enteredPin);
                                    } else {
                                      BlocProvider.of<VerifyPinCubit>(context)
                                          .verifyPin(
                                        parentDeviceId: widget.parentDeviceId,
                                        pin: enteredPin,
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void showUnlinkConfirmation() {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        enableDrag: false,
        builder: (context) {
          return SizedBox(
            height: 350,
            child: Column(
              children: [
                const SizedBox(
                  height: 28,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextWidget(
                      text: "Unlink Device",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  thickness: 1,
                  color: AppColors.lightBlue1,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Icon(
                  Icons.link_off,
                  color: AppColors.red,
                  size: 40,
                ),
                TextWidget(
                  text:
                      "Are you sure you want \nto unlink from the child device?",
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  textAlignment: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<UnlinkDeviceCubit, UnlinkDeviceState>(
                  builder: (context, state) {
                    bool isLoading =
                        state is UnlinkDeviceLoadingState ? true : false;
                    return isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.black,
                          )
                        : ButtonWiget(
                            buttonText: "Confirm",
                            buttonFontSize: 14,
                            onPressed: () {
                              BlocProvider.of<UnlinkDeviceCubit>(context)
                                  .unlinkDevice(
                                      childDeviceId: childDeviceId.toString());
                            },
                            buttonBackgroundColor: AppColors.red,
                          );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonWiget(
                  buttonText: "Cancel",
                  buttonFontSize: 14,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}
