import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_state.dart';
import 'package:safe_view/services/api_services.dart';

class UpgradeCubit extends Cubit<UpgradeState> {
  ApiService apiService;
  UpgradeCubit(this.apiService) : super(UpgradeInitialState());
  Future upgradeRequest({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    try {
      emit(UpgradeLoadingState());
      final data = await apiService.upgradeService(
          parentDeviceId: parentDeviceId,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          childName: childName);
      if (data.data != null && data.error == false) {
        emit(UpgradeSuccessState(upgradeModel: data.data!));
      } else if (data.errorMessage == "Already expressed interest") {
        emit(const AlreadyRequestedUpgradeState(
            message:
                "Your upgrade request has already been submitted. We'll contact you soon."));
      } else {
        emit(UpgradeErrorState(errorMessage: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(UpgradeErrorState(errorMessage: e.toString()));
    }
  }
}
