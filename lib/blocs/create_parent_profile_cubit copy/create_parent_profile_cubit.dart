import 'package:bloc/bloc.dart';

import 'package:safe_view/services/api_services.dart';

import 'create_parent_profile_state.dart';

class CreateParentProfileCubit extends Cubit<CreateParentProfileState> {
  ApiService apiService;
  CreateParentProfileCubit(this.apiService)
      : super(CreateParentProfileInitialState());
  Future createParentProfile({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    try {
      emit(CreateParentProfileLoadingState());
      final data = await apiService.createParentProfileService(
          parentDeviceId: parentDeviceId,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          childName: childName);
      if (data.data != null && data.error == false) {
        emit(CreateParentProfileSuccessState(
            createParentProfileModel: data.data!));
      } else {
        emit(CreateParentProfileErrorState(
            errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(CreateParentProfileErrorState(errorMessage: e.toString()));
    }
  }
}
