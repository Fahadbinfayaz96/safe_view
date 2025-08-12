import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_state.dart';
import 'package:safe_view/services/api_services.dart';

class GetKidsActivitiesCubit extends Cubit<GetKidsActivitiesState> {
  ApiService apiService;
  GetKidsActivitiesCubit(this.apiService)
      : super(GetKidsActivitiesLoadingState());
  Future getKidsActivities(
      {required String childDeviceId, bool isFromSocket = false}) async {
    try {
      if (!isFromSocket) {
        emit(GetKidsActivitiesLoadingState());
      }

      final data = await apiService.GetKidsActivitiesService(
          childDeviceId: childDeviceId);
          log("data.......${data.data} ${data.data == null || data.data!.isEmpty}");
      if (data.data != null && data.data!.isNotEmpty && data.error == false) {
        emit(GetKidsActivitiesLoadedState(getKidsActivities: data.data!));
      } else if ((data.data == null || data.data!.isEmpty) && data.error == false) {
      emit(const GetKidsActivitiesEmptyState(emptyMessage: "No activities found"));
      } else {
        emit(const GetKidsActivitiesErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log("e..........$e");
      emit(GetKidsActivitiesErrorState(errorMessage: e.toString()));
    }
  }
}
