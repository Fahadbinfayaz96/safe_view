import 'package:bloc/bloc.dart';
import 'package:safe_view/services/api_services.dart';

import 'update_content_filter_state.dart';

class UpdateContentFilterCubit extends Cubit<UpdateContentFilterState> {
  ApiService apiService;
  UpdateContentFilterCubit(this.apiService)
      : super(UpdateContentFilterInitailState());
  Future updateContentFilters(
      { String? childDeviceId,
       bool? allowSearch,
       bool? allowAutoplay,
       bool? blockUnsafeVideos,
       List<String>? blockedCategories,
       int? screenTimeLimit,
       bool? isLocked}) async {
    try {
      emit(UpdateContentFilterLoadingState());

      final data = await apiService.updateContentFilterService(
          childDeviceId: childDeviceId,
          allowSearch: allowSearch,
          allowAutoplay: allowAutoplay,
          blockUnsafeVideos: blockUnsafeVideos,
          blockedCategories: blockedCategories,
          screenTimeLimit: screenTimeLimit,
          isLocked: isLocked);
      if (data.data != null && data.error == false) {
        emit(UpdateContentFilterSuccessState(updateContentFilter: data.data!));
      } else {
        emit(const UpdateContentFilterErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(UpdateContentFilterErrorState(errorMessage: e.toString()));
    }
  }
}
