 import 'package:equatable/equatable.dart';
import 'package:safe_view/models/set_pin_model.dart';

class SetPinState extends Equatable {
  const SetPinState();

  @override
  List<Object> get props => [];
}

 class SetPinInitialState extends SetPinState {}

 class SetPinLoadingState extends SetPinState {}

 class SetPinSuccessState extends SetPinState {
    final SetPinModel setPin;

  const SetPinSuccessState({required this.setPin});
  @override

  List<Object> get props => [setPin];
  }

   class SetPinErrorState extends SetPinState {
    final String errorMessage;

  const SetPinErrorState({required this.errorMessage});
  @override

  List<Object> get props => [errorMessage];
  }