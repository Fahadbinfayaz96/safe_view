import 'package:equatable/equatable.dart';
import 'package:safe_view/models/trail_status_model.dart';

class TrailStatusState extends Equatable {
  const TrailStatusState();

  @override
  List<Object> get props => [];
}

class TrailStatusLoadingState extends TrailStatusState {}

class TrailStatusLoadedState extends TrailStatusState {
  final TrailStatusModel trailStatusModel;

  const TrailStatusLoadedState({required this.trailStatusModel});
  @override
  List<Object> get props => [trailStatusModel];
}

class TrailStatusErrorState extends TrailStatusState {
  final String errorMessage;

  const TrailStatusErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
