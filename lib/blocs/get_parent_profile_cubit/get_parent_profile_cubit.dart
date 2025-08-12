import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_state.dart';
import 'package:safe_view/services/api_services.dart';

class GetParentProfileCubit extends Cubit<GetParentProfileState> {
  ApiService apiService;
  GetParentProfileCubit(this.apiService)
      : super(GetParentProfileLoadingState());
  Future getParentProfile({required String parentDeviceId}) async {
    try {
      emit(GetParentProfileLoadingState());
      final data = await apiService.getParentProfileService(
          parentDeviceId: parentDeviceId);
      if (data.data != null && data.error == false) {
        emit(GetParentProfileLoadedState(getParentProfileModel: data.data!));
      } else if (data.error && data.errorMessage == "Profile not found") {
        emit(GetParentProfileEmptyState(
            emptyMessage: data.errorMessage.toString()));
      } else {
        emit(GetParentProfileErrorState(
            errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      log("e..........$e");
      emit(GetParentProfileErrorState(errorMessage: e.toString()));
    }
  }
}
