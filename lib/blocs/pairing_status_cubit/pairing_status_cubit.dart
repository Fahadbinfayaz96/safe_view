import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe_view/services/api_services.dart';

import '../../models/pairing_status_model.dart';

part 'pairing_status_state.dart';

class PairingStatusCubit extends Cubit<PairingStatusState> {
  ApiService apiService;
  PairingStatusCubit(this.apiService) : super(PairingStatusLoadingState());

  Future getPairingStatus({required String deviceId}) async {
    try {
      emit(PairingStatusLoadingState());
      final data = await apiService.pairingStausService(deviceId: deviceId);
      if (data.data != null && data.error == false) {
        emit(PairingStatusLoadedState(pairingStatus: data.data!));
      } else {
        emit(const PairingStatusErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log("e.........$e");
      emit(PairingStatusErrorState(errorMessage: e.toString()));
    }
  }
}
