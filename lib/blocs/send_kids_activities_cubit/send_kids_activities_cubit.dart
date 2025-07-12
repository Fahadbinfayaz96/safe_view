import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/send_kids_activities_cubit/send_kids_activities_state.dart';
import 'package:safe_view/services/api_services.dart';

class SendKidsActivitiesCubit extends Cubit<SendKidsActivitiesState> {
  ApiService apiService;
  SendKidsActivitiesCubit(this.apiService)
      : super(SendKidsActivitiesInitialState());

  Future sendKidsActivities({
    required childDeviceId,
    required String videoId,
    required String title,
    required String thumbnail,
    required String channelName,
    required int? duration,
  }) async {
    try {
   
      emit(SendKidsActivitiesLoadingState());
      final data = await apiService.sendKidsActivitiesService(
          childDeviceId: childDeviceId,
          videoId: videoId,
          title: title,
          thumbnail: thumbnail,
          channelName: channelName,
          duration: duration);
      if (data.data != null && data.error == false) {
        emit(SendKidsActivitiesLoadedState(sendKidsActivities: data.data!));
      } else {
        emit(SendKidsActivitiesErrorState(
            errorMessage: data.errorMessage.toString()));
      }

         log("state.......$state");
    } catch (e) {
      log("e.......$e");
      emit(SendKidsActivitiesErrorState(errorMessage: e.toString()));
    }
  }
}
