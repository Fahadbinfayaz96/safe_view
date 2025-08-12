import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/trail_status_cubit/trail_status_state.dart';
import 'package:safe_view/services/api_services.dart';

class TrailStatusCubit extends Cubit<TrailStatusState> {
  ApiService apiService;
  TrailStatusCubit(this.apiService) : super(TrailStatusLoadingState());
  Future getTrailStatus({required String parentDeviceId}) async {
    try {
      emit(TrailStatusLoadingState());
      final data =
          await apiService.trailStatusService(parentDeviceId: parentDeviceId);
      if (data.data != null && data.error == false) {
        emit(TrailStatusLoadedState(trailStatusModel: data.data!));
      } else {
        emit(TrailStatusErrorState(errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(TrailStatusErrorState(errorMessage: e.toString()));
    }
  }
}
