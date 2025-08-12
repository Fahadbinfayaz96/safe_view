import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/track_time_limit_cubit/track_time_limit_state.dart';
import 'package:safe_view/services/api_services.dart';

class TrackTimeLimitCubit extends Cubit<TrackTimeLimitState> {
  ApiService apiService;
  TrackTimeLimitCubit(this.apiService) : super(TrackTimeLimitInitialState());
  Future sendRemainingTime({
    required String childDeviceId,
    required int remainingTime,
  }) async {
    try {
      emit(TrackTimeLimitLoadingState());
      final data = await apiService.trackTimeService(
          childDeviceId: childDeviceId, remainingTime: remainingTime);
      if (data.data != null && data.error == false) {
        emit(TimeLimitSentState(trackTimeLimitModel: data.data!));
      } else {
        emit(TrackTimeLimitErrorState(
            errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(TrackTimeLimitErrorState(errorMessage: e.toString()));
    }
  }
}
