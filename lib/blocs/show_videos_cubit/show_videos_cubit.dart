import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_view/services/api_services.dart';

import 'show_videos_state.dart';

class ShowVideosCubit extends Cubit<ShowVideosState> {
  ApiService apiService;
  ShowVideosCubit(this.apiService) : super(ShowVideosLoadingState());

  Future showVideos(
      {required String childDeviceId,
      required String searchKey,
      bool fromSocket = false,
      required int pageNumber,
      bool isPagination = false}) async {
    try {
      if (!fromSocket && pageNumber == 1) {
        emit(ShowVideosLoadingState());
      }

      final data = await apiService.showVideosService(
          childDeviceId: childDeviceId,
          searchKey: searchKey,
          pageNumber: pageNumber);

      if (data.data != null && data.error == false) {
        emit(ShowVideosLoadedState(showVideos: data.data!));
      } else if (data.data != null && data.data?.videos == null) {
        emit(const ShowVideosEmptyState(
            emptyMessage: "No videos available. Please check back later"));
      } else if (data.error == true &&
          data.errorMessage == "Child settings not found") {
        emit(ChildSettingsUnsetState(
            validationMessage: data.errorMessage.toString()));
      } else {
        emit(const ShowVideosErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(ShowVideosErrorState(errorMessage: e.toString()));
    }
  }
}
