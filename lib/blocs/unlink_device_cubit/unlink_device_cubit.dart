import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/unlink_device_cubit/unlink_device_state.dart';
import 'package:safe_view/services/api_services.dart';

class UnlinkDeviceCubit extends Cubit<UnlinkDeviceState> {
  ApiService apiService;
  UnlinkDeviceCubit(this.apiService) : super(UnlinkDeviceInitialState());
  Future unlinkDevice({required String childDeviceId}) async {
    try {
      emit(UnlinkDeviceLoadingState());
      final data =
          await apiService.unlinkDeviceService(childDeviceId: childDeviceId);
      if (data.error == false) {
        emit(UnlinkDeviceUnlinkSuccessState(unlinkDevice: data.data!));
      } else {
        emit(
            UnlinkDeviceErrorState(errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(UnlinkDeviceErrorState(errorMessage: e.toString()));
    }
  }
}
