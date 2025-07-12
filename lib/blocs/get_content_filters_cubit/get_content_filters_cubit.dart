import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/services/api_services.dart';

import 'get_content_filters_state.dart';

class GetContentFiltersCubit extends Cubit<GetContentFiltersState> {
  ApiService apiService;
  GetContentFiltersCubit(this.apiService)
      : super(GetContentFiltersLoadingState());
  Future getContentFilter({required String childDeviceId}) async {
    try {
      emit(GetContentFiltersLoadingState());
      final data = await apiService.getContentFilterService(
          childDeviceId: childDeviceId);
      if (data.data != null && data.error == false) {
        emit(GetContentFiltersLoadedState(getContentFilter: data.data!));
      } else {
        emit(const GetContentFiltersErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log("e...........$e");
      emit(GetContentFiltersErrorState(errorMessage: e.toString()));
    }
  }
}
