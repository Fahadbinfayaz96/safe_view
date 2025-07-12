import 'package:equatable/equatable.dart';
import 'package:safe_view/models/generate_code_model.dart';

class GenerateCodeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateCodeInitialState extends GenerateCodeState {}

class GenerateCodeLoadingState extends GenerateCodeState {}

class CodeGeneratedState extends GenerateCodeState {
  final GenerateCodeModel generateCode;

  CodeGeneratedState({required this.generateCode});
  @override
  List<Object?> get props => [generateCode];
}

class GenerateCodeErrorState extends GenerateCodeState {
  final String errorMessage;

  GenerateCodeErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
