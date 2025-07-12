import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_cubit.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_state.dart';
import 'package:safe_view/blocs/show_videos_cubit/show_videos_cubit.dart';
import 'package:safe_view/main.dart';
import 'package:safe_view/models/get_content_filter_model.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/jumping_dot_progress_indicator.dart';
import 'package:safe_view/widgets/retry_widget.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import 'package:safe_view/widgets/video%20player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../blocs/send_kids_activities_cubit/send_kids_activities_cubit.dart' show SendKidsActivitiesCubit;
import '../blocs/show_videos_cubit/show_videos_state.dart';

class ChildHomeScreen extends StatefulWidget {
  final String childDeviceId;
  const ChildHomeScreen({super.key, required this.childDeviceId});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen>
    with WidgetsBindingObserver {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String currentSearchTerm = '';
  bool isLoading = false;
  GetContentFilterModel? filters;
  List? videos;
  late IO.Socket socket;
  int? remainingSeconds;
  String timerDisplay = "Connecting...";
  bool isLimitReached = false;
  Timer? localTimer;

  bool isSocketConnected = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initializeSocket();
    loadVideos();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      stopLocalTimer();
    } else if (state == AppLifecycleState.resumed && !isLimitReached) {
      fetchRemainingTimeFromServer();
    }
  }

  void initializeSocket() {
    log("_initializeSocket");
    socket = IO.io(
      'https://safeview-backend.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log("Emitting join for device: ${widget.childDeviceId}");
      if (!mounted) return;
      setState(() => isSocketConnected = true);
      socket.emit("join", widget.childDeviceId);
    });

    socket.on("limitReached", (data) {
      if (!mounted) return;
      setState(() => isLimitReached = true);
      log("⏰ Limit Reached: ${data['message']}");
      BlocProvider.of<GetContentFiltersCubit>(context)
          .getContentFilter(childDeviceId: widget.childDeviceId);

      stopLocalTimer();
      isChildDeviceLocked();
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
        setState(() {
          timerDisplay = "Connection Error";
        });

        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) socket.connect();
        });
      }
    });
  }

  void fetchRemainingTimeFromServer() async {
    if (filters?.screenTimeLimitMins != null) {
      setState(() {
        remainingSeconds = filters!.screenTimeLimitMins! * 60;
      });
      startLocalTimer();
    } else {}
  }

  void startLocalTimer() {
    stopLocalTimer();
    localTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds == null || isLimitReached) return;

      if (remainingSeconds! <= 1) {
        socket.emit("timeExpired", widget.childDeviceId);
        setState(() => remainingSeconds = 0);
        //  log("Filterrrrrr ${filters?.isLocked}");
        // stopLocalTimer();
        // isChildDeviceLocked();
      } else {
        setState(() {
          remainingSeconds = remainingSeconds! - 1;
        });
      }
    });
  }

  void stopLocalTimer() {
    localTimer?.cancel();
  }

  void loadVideos({String? searchTerm}) {
    BlocProvider.of<ShowVideosCubit>(context)
        .showVideos(
      childDeviceId: widget.childDeviceId,
      searchKey: searchTerm ?? "",
    )
        .then((onValue) {
      if (mounted) {
        BlocProvider.of<GetContentFiltersCubit>(context)
            .getContentFilter(childDeviceId: widget.childDeviceId);
      }
      _refreshController.refreshCompleted();
    }).catchError((error) {
      _refreshController.refreshFailed();
    });
  }

  void _onRefresh() {
    loadVideos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopLocalTimer();
    socket.disconnect();
    socket.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        toolbarHeight: isSearching ? 90 : 80,
        title: isSearching
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      currentSearchTerm = value;
                    });

                    if (value.isNotEmpty) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (currentSearchTerm == value && mounted) {
                          loadVideos(searchTerm: value);
                        }
                      });
                    } else {
                      loadVideos();
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.black),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon:
                                const Icon(Icons.clear, color: AppColors.black),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                currentSearchTerm = '';
                              });
                              loadVideos();
                            },
                          )
                        : null,
                    hintText: 'Search videos...',
                    hintStyle: const TextStyle(color: AppColors.lightBlack),
                    filled: true,
                    fillColor: AppColors.lightBlue2.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.lightBlue3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.lightBlue3, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: const TextStyle(color: AppColors.black, fontSize: 16),
                ),
              )
            : Row(
                children: [
                  const Icon(CupertinoIcons.lock_shield_fill),
                  const SizedBox(width: 5),
                  TextWidget(
                    text: "Kids Mode",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  const Spacer(),
                  if (filters?.allowSearch == true)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.search,
                        size: 25,
                        color: AppColors.black,
                      ),
                    ),
                  const SizedBox(width: 5),
                ],
              ),
        backgroundColor: AppColors.lightBlue2,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: isSearching
            ? [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.black),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      currentSearchTerm = '';
                    });
                    loadVideos();
                  },
                ),
              ]
            : null,
      ),
      body: BlocListener<GetContentFiltersCubit, GetContentFiltersState>(
        listener: (context, state) {
          isLoading = state is GetContentFiltersLoadingState ? true : false;
          if (state is GetContentFiltersLoadedState) {
            filters = state.getContentFilter;
            setState(() {});

            if (!isLimitReached && remainingSeconds == null) {
              fetchRemainingTimeFromServer();
            }
            if (filters?.isLocked == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                isChildDeviceLocked();
              });
            }
          }
        },
        child: BlocConsumer<ShowVideosCubit, ShowVideosState>(
          listener: (context, state) {
            if (state is ShowVideosLoadedState) {
              videos = state.showVideos.videos;
            }
          },
          builder: (context, state) {
            if (state is ShowVideosLoadingState) {
              return const BackgroundGradientColorWiget(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                ),
              );
            } else if (state is ShowVideosLoadedState) {
              final videos = state.showVideos.videos ?? [];
              return BackgroundGradientColorWiget(
                child: SmartRefresher(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: isSearching && currentSearchTerm.isNotEmpty
                                  ? "Search Results"
                                  : "Your Safe Videos",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            isLoading
                                ? const JumpingDots()
                                : RichText(
                                    text: TextSpan(
                                      text: "Time Left: ",
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: remainingSeconds != null
                                              ? "${(remainingSeconds! ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds! % 60).toString().padLeft(2, '0')}"
                                              : "Loading...",
                                          style: const TextStyle(
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: videos.isEmpty &&
                                isSearching &&
                                currentSearchTerm.isNotEmpty
                            ? Center(
                                child: TextWidget(
                                  text:
                                      "No videos found for '$currentSearchTerm'",
                                  fontSize: 16,
                                  textColor: AppColors.charcoalGrey,
                                ),
                              )
                            : videos.isEmpty
                                ? retryWidget(
                                    onPress: () {
                                      loadVideos();
                                    },
                                    isError: false,
                                    errorMessage:
                                        "No videos available. Please check back later.",
                                  )
                                : ListView.builder(
                                    itemCount: videos.length,
                                    itemBuilder: (context, index) {
                                      final video = videos[index];
                                      return GestureDetector(
                                        onTap: () {
                                          final videoIds = videos
                                              .map((v) => v.videoId)
                                              .where((id) => id != null)
                                              .cast<String>()
                                              .toList();

                 
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => VideoPlayerWidget(
                                                videoIds: videoIds,
                                                startIndex: index,
                                                isAutoPlayAllowed:
                                                    filters?.allowAutoplay ??
                                                        false,
                                                        videoModel:video,
                                                        childDeviceId: widget.childDeviceId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      video.thumbnail ?? "N/A",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                    bottom: 5),
                                                child: TextWidget(
                                                  text: video.title ?? "NA",
                                                  textColor: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, bottom: 5),
                                                child: TextWidget(
                                                  text: video.channel ?? "NA",
                                                  textColor:
                                                      AppColors.lightGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ShowVideosErrorState) {
             
              return retryWidget(
                  onPress: () {
                    loadVideos();
                  },
                  errorMessage: "Error loading Videos...");
            } else {
              return retryWidget(
                  onPress: () {
                    loadVideos();
                  },
                  errorMessage: "Something went wrong");
            }
          },
        ),
      ),
    );
  }

  void isChildDeviceLocked() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 60, color: AppColors.red),
                  const SizedBox(height: 20),
                  TextWidget(
                    text: "App Locked",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textColor: AppColors.black,
                  ),
                  const SizedBox(height: 10),
                  TextWidget(
                    text:
                        "Your parent has temporarily locked this app.\nPlease try again later.",
                    textAlignment: TextAlign.center,
                    fontSize: 16,
                    textColor: AppColors.lightGrey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
