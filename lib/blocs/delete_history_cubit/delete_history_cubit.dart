import 'package:bloc/bloc.dart';
import 'package:safe_view/blocs/delete_history_cubit/delete_history_state.dart';
import 'package:safe_view/services/api_services.dart';

class DeleteHistoryCubit extends Cubit<DeleteHistoryState> {
  ApiService apiService;
  DeleteHistoryCubit(this.apiService) : super(DeleteHistoryInitialState());

  Future deleteHistory({required String childDeviceId}) async {
    try {
      emit(DeleteHistoryLoadingState());
      final data =
          await apiService.deleteHistoryService(childDeviceId: childDeviceId);
      if (data.data != null && data.error == false) {
        emit(DeleteHistorySuccessState(deleteHistoryModel: data.data!));
      } else {
        emit(DeleteHistoryErrorState(message: data.errorMessage.toString()));
      }
    } catch (e) {
      emit(DeleteHistoryErrorState(message: e.toString()));
    }
  }
}
