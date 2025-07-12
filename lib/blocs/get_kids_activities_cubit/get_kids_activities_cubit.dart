import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_state.dart';
import 'package:safe_view/services/api_services.dart';

class GetKidsActivitiesCubit extends Cubit<GetKidsActivitiesState> {
  ApiService apiService;
  GetKidsActivitiesCubit(this.apiService)
      : super(GetKidsActivitiesLoadingState());
  Future getKidsActivities({required String childDeviceId}) async {
    try {
      emit(GetKidsActivitiesLoadingState());
      final data = await apiService.GetKidsActivitiesService(
          childDeviceId: childDeviceId);
      if (data.data != null && data.error == false) {
        emit(GetKidsActivitiesLoadedState(getKidsActivities: data.data!));
      } else {
        emit(const GetKidsActivitiesErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log("e..........$e");
      emit(GetKidsActivitiesErrorState(errorMessage: e.toString()));
    }
  }
}
