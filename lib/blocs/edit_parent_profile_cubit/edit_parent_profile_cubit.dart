import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/edit_parent_profile_cubit/edit_parent_profile_state.dart';

import 'package:safe_view/services/api_services.dart';

class EditParentProfileCubit extends Cubit<EditParentProfileState> {
  ApiService apiService;
  EditParentProfileCubit(this.apiService)
      : super(EditParentProfileInitialState());
  Future editParentProfile({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    try {
      emit(EditParentProfileLoadingState());
      final data = await apiService.editParentProfileService(
  parentDeviceId: parentDeviceId,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          childName: childName);
      if (data.data != null && data.error == false) {
        emit(EditParentProfileSuccessState(
            editParentProfileModel: data.data!));
      } else {
        emit(EditParentProfileErrorState(
            errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(EditParentProfileErrorState(errorMessage: e.toString()));
    }
  }
}
