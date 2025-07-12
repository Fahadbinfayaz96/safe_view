import 'package:equatable/equatable.dart';
import 'package:safe_view/models/info_model.dart';

class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object> get props => [];
}

class InfoLoadingState extends InfoState {}

class InfoLoadedState extends InfoState {
  final InfoModel info;

  const InfoLoadedState({required this.info});
  @override
  List<Object> get props => [info];
}

class InfoErrorState extends InfoState {
  final String errorMessage;

  const InfoErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
