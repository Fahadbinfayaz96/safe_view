import 'package:bloc/bloc.dart';
import 'package:safe_view/services/api_services.dart';

import 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  ApiService apiService;
  VerifyCodeCubit(this.apiService) : super(VerifyCodeInitialState());
  Future verifyCode(
      {required String parentDeviceId, required String pairingCode}) async {
    try {
      emit(VerifyCodeLoadingState());
      final data = await apiService.verifyCodeService(
          parentDeviceId: parentDeviceId, pairingCode: pairingCode);
      if (data.data != null && data.error == false) {
        emit(VerifiedCodeState(verifyCode: data.data!));
      } else {
        emit(VerifyCodeErrorState(errorMessage: data.errorMessage.toString() ));
      }
    } catch (e) {
      emit(VerifyCodeErrorState(errorMessage: e.toString()));
    }
  }
}
