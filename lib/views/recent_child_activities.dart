import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:safe_view/blocs/delete_history_cubit/delete_history_cubit.dart';
import 'package:safe_view/blocs/delete_history_cubit/delete_history_state.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_cubit.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_state.dart';
import 'package:safe_view/blocs/info_cubit/info_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_state.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/jumping_dot_progress_indicator.dart';
import 'package:safe_view/widgets/text_wiget.dart';
import '../untilities/app_colors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RecentChildActivities extends StatefulWidget {
  final String parentDeviceId;

  const RecentChildActivities({super.key, required this.parentDeviceId});

  @override
  State<RecentChildActivities> createState() => _RecentChildActivitiesState();
}

class _RecentChildActivitiesState extends State<RecentChildActivities> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late IO.Socket socket;
  String? childDeviceId;
  @override
  void initState() {
    BlocProvider.of<InfoCubit>(context)
        .getInfo(parentDeviceId: widget.parentDeviceId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeSocket();
    });

    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    refreshController.dispose();
    super.dispose();
  }

  onRefresh() {
    BlocProvider.of<InfoCubit>(context)
        .getInfo(parentDeviceId: widget.parentDeviceId)
        .then((_) {
      refreshController.refreshCompleted();
    }).catchError((error) {
      refreshController.refreshFailed();
    });
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
      log("Emitting join for device: ${childDeviceId}");
      if (!mounted) return;

      socket.emit("join", childDeviceId);
    });
    socket.on("activityLogged", (data) {
      if (childDeviceId != null && mounted) {
        BlocProvider.of<GetKidsActivitiesCubit>(context).getKidsActivities(
            childDeviceId: childDeviceId!, isFromSocket: true);
      }
      // log("▶️ Title: ${data['title']}");
      // log("⏱ Duration: ${data['duration']} sec");
      // log("📆 Watched at: ${data['watchedAt']}");
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

  String formatDuration(int? seconds) {
    if (seconds == null) return "0s";
    final duration = Duration(seconds: seconds);
    final parts = <String>[];
    if (duration.inHours > 0) parts.add('${duration.inHours}h');
    if (duration.inMinutes.remainder(60) > 0 || duration.inHours > 0) {
      parts.add('${duration.inMinutes.remainder(60)}m');
    }
    parts.add('${duration.inSeconds.remainder(60)}s');
    return parts.join(' ');
  }

  String formatWatchedAt(String? timestamp) {
    final dateTime = DateTime.tryParse(timestamp ?? '');
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => false,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: "Recent History",
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          backgroundColor: AppColors.lightBlue2,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<InfoCubit, InfoState>(
              listener: (context, state) {
                if (state is InfoLoadedState) {
                  BlocProvider.of<GetKidsActivitiesCubit>(context)
                      .getKidsActivities(
                          childDeviceId: state.info.pairedWith.toString());
                  setState(() {
                    childDeviceId = state.info.pairedWith;
                  });
                }
              },
            ),
            BlocListener<DeleteHistoryCubit, DeleteHistoryState>(
              listener: (context, state) {
                if (state is DeleteHistorySuccessState) {
                  Fluttertoast.showToast(msg: "cleared successfully");
                  BlocProvider.of<GetKidsActivitiesCubit>(context)
                      .getKidsActivities(
                          childDeviceId: childDeviceId.toString());
                }
              },
            ),
          ],
          child: BlocBuilder<GetKidsActivitiesCubit, GetKidsActivitiesState>(
            builder: (context, state) {
              if (state is GetKidsActivitiesLoadingState) {
                return const BackgroundGradientColorWiget(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                    ),
                  ),
                );
              } else if (state is GetKidsActivitiesLoadedState) {
                final childActivities = state.getKidsActivities;
                return BackgroundGradientColorWiget(
                  padding: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await BlocProvider.of<DeleteHistoryCubit>(context)
                              .deleteHistory(
                                  childDeviceId: childDeviceId.toString());
                        },
                        child:
                            BlocBuilder<DeleteHistoryCubit, DeleteHistoryState>(
                          builder: (context, state) {
                            bool isLoading = state is DeleteHistoryLoadingState
                                ? true
                                : false;
                            return isLoading
                                ? const JumpingDots()
                                : childActivities.isEmpty
                                    ? const SizedBox()
                                    : Align(
                                        alignment: Alignment.centerRight,
                                        child: TextWidget(
                                          text: "Clear All",
                                          textColor: AppColors.red,
                                        ),
                                      );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SmartRefresher(
                          controller: refreshController,
                          onRefresh: onRefresh,
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
                          child: ListView.separated(
                            itemCount: childActivities.length,
                            separatorBuilder: (_, __) => const Divider(
                              color: AppColors.lightGrey,
                              height: 20,
                            ),
                            itemBuilder: (context, index) {
                              final activity = childActivities[index];

                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                leading: Stack(
                                  alignment: AlignmentGeometry.center,
                                  children: [
                                    Image.network(
                                        activity.thumbnail.toString()),
                                    const Icon(
                                      Icons.play_circle_outline,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                      size: 35,
                                    ),
                                  ],
                                ),
                                title: TextWidget(
                                  text: activity.title.toString(),
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColors.black,
                                ),
                                subtitle: TextWidget(
                                  text:
                                      "//${formatWatchedAt(activity.watchedAt)} • Duration: ${formatDuration(activity.duration)}",
                                  fontSize: 13,
                                  textColor: AppColors.lightGrey2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is GetKidsActivitiesEmptyState) {
                return BackgroundGradientColorWiget(
                  child: Center(
                    child: TextWidget(text: state.emptyMessage),
                  ),
                );
              } else {
                return BackgroundGradientColorWiget(
                  child: Center(
                    child: TextWidget(text: "Something went wrong"),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
