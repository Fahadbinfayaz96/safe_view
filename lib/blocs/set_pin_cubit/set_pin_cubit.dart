import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/set_pin_cubit/set_pin_state.dart';
import 'package:safe_view/services/api_services.dart';

class SetPinCubit extends Cubit<SetPinState> {
  ApiService apiService;
  SetPinCubit(this.apiService) : super(SetPinInitialState());
  Future setPin({required String parentDeviceId, required String pin}) async {
    try {
      emit(SetPinLoadingState());
      final data = await apiService.setPinService(
          parentDeviceId: parentDeviceId, pin: pin);

      if (data.error == false) {
        emit(SetPinSuccessState(setPin: data.data!));
      } else {
        emit(SetPinErrorState(errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      log("e........$e");
      emit(SetPinErrorState(errorMessage: e.toString()));
    }
  }
}
