import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/verify_pin_cubit/verify_pin_state.dart';
import 'package:safe_view/services/api_services.dart';

class VerifyPinCubit extends Cubit<VerifyPinState> {
  ApiService apiService;
  VerifyPinCubit(this.apiService) : super(VerifyPinInitialState());
  Future verifyPin(
      {required String parentDeviceId, required String pin}) async {
    try {
      emit(VerifyPinLoadingState());
      final data = await apiService.verifyPinService(
          parentDeviceId: parentDeviceId, pin: pin);
      if (data.error == false) {
        emit(VerifyPinSuccessState(verifyPin: data.data!));
      } else {
        emit(VerifyPinErrorState(errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(VerifyPinErrorState(errorMessage: e.toString()));
    }
  }
}
