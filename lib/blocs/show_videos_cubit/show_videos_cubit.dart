import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_view/services/api_services.dart';

import 'show_videos_state.dart';

class ShowVideosCubit extends Cubit<ShowVideosState> {
  ApiService apiService;
  ShowVideosCubit(this.apiService) : super(ShowVideosLoadingState());

  Future showVideos({required String childDeviceId,required String searchKey}) async {
    try {
      emit(ShowVideosLoadingState());
      final data = await apiService.showVideosService(childDeviceId: childDeviceId,searchKey: searchKey);
      if (data.data != null && data.error == false) {
        emit(ShowVideosLoadedState(showVideos: data.data!));
      } else {
        emit(const ShowVideosErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(ShowVideosErrorState(errorMessage: e.toString()));
    }
  }
}
