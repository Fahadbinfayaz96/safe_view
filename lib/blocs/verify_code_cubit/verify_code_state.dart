import 'package:equatable/equatable.dart';
import 'package:safe_view/models/verify_code_model.dart';

class VerifyCodeState extends Equatable {
  const VerifyCodeState();

  @override
  List<Object> get props => [];
}

final class VerifyCodeInitialState extends VerifyCodeState {}

final class VerifyCodeLoadingState extends VerifyCodeState {}

final class VerifiedCodeState extends VerifyCodeState {
  final VerifyCodeModel verifyCode;

  const VerifiedCodeState({required this.verifyCode});
  @override
  List<Object> get props => [verifyCode];
}

final class VerifyCodeErrorState extends VerifyCodeState {
  final String errorMessage;

  const VerifyCodeErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
