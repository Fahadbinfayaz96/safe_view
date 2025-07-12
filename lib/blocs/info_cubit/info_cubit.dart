import 'package:bloc/bloc.dart';
import 'package:safe_view/services/api_services.dart';
import 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  ApiService apiService;
  InfoCubit(this.apiService) : super(InfoLoadingState());
  Future getInfo({required String parentDeviceId}) async {
    try {
      emit(InfoLoadingState());
      final data = await apiService.infoService(parentDeviceId: parentDeviceId);
      if (data.data != null && data.error == false) {
        emit(InfoLoadedState(info: data.data!));
      } else {
        emit(const InfoErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(InfoErrorState(errorMessage: e.toString()));
    }
  }
}
