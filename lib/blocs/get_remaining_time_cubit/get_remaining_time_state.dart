import 'package:equatable/equatable.dart';
import 'package:safe_view/models/get_remaining_time_model.dart';

class GetRemainingTimeState extends Equatable {
  const GetRemainingTimeState();

  @override
  List<Object> get props => [];
}

class GetRemainingTimeLoadingState extends GetRemainingTimeState {}

class GetRemainingTimeLoadedState extends GetRemainingTimeState {
  final GetRemainingTimeModel getRemainingTimeModel;

  const GetRemainingTimeLoadedState({required this.getRemainingTimeModel});
  @override
  List<Object> get props => [getRemainingTimeModel];
}

class GetRemainingTimeErrorState extends GetRemainingTimeState {
  final String errorMessage;

  const GetRemainingTimeErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
