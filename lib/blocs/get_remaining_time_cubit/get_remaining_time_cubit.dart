import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/get_remaining_time_cubit/get_remaining_time_state.dart';
import 'package:safe_view/services/api_services.dart';

class GetRemainingTimeCubit extends Cubit<GetRemainingTimeState> {
  ApiService apiService;
  GetRemainingTimeCubit(this.apiService)
      : super(GetRemainingTimeLoadingState());
  Future getRemainingTime({required String childDeviceId}) async {
    try {
      emit(GetRemainingTimeLoadingState());
      final data = await apiService.getRemainingTimeService(
          childDeviceId: childDeviceId);

      if (data.data != null && data.error == false) {
        emit(GetRemainingTimeLoadedState(getRemainingTimeModel: data.data!));
      } else {
        emit(const GetRemainingTimeErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {

      emit(GetRemainingTimeErrorState(errorMessage: e.toString()));
    }
  }
}
