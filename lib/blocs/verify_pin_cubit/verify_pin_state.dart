import 'package:equatable/equatable.dart';
import 'package:safe_view/models/verify_pin_model.dart';

class VerifyPinState extends Equatable {
  const VerifyPinState();

  @override
  List<Object> get props => [];
}

class VerifyPinInitialState extends VerifyPinState {}

class VerifyPinLoadingState extends VerifyPinState {}

class VerifyPinSuccessState extends VerifyPinState {
  final VerifyPinModel verifyPin;

  const VerifyPinSuccessState({required this.verifyPin});
  @override
  List<Object> get props => [verifyPin];
}

class VerifyPinErrorState extends VerifyPinState {
  final String errorMessage;

  const VerifyPinErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
