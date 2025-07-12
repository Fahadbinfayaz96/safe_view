import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:safe_view/services/api_services.dart';

import 'generate_code_state.dart';

class GenerateCodeCubit extends Cubit<GenerateCodeState> {
  ApiService apiService;
  GenerateCodeCubit(this.apiService) : super(GenerateCodeInitialState());
  Future generateCode({required String childDeviceId}) async {
    try {
      emit(GenerateCodeLoadingState());
      final data =
          await apiService.generateCodeService(childDeviceId: childDeviceId);
      if (data.data != null && data.error == false) {
        emit(CodeGeneratedState(generateCode: data.data!));
      } else {
        emit(GenerateCodeErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
  
      emit(GenerateCodeErrorState(errorMessage: e.toString()));
    }
  }
}
