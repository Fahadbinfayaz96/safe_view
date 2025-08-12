 import 'package:equatable/equatable.dart';
import 'package:safe_view/models/track_time_limit_model.dart';

class TrackTimeLimitState extends Equatable {
  const TrackTimeLimitState();

  @override
  List<Object> get props => [];
}

class TrackTimeLimitInitialState extends TrackTimeLimitState {}
class TrackTimeLimitLoadingState extends TrackTimeLimitState {}
class TimeLimitSentState extends TrackTimeLimitState {
  final TrackTimeLimitModel trackTimeLimitModel;

  const TimeLimitSentState({required this.trackTimeLimitModel});
  @override

  List<Object> get props => [trackTimeLimitModel];
}
class TrackTimeLimitErrorState extends TrackTimeLimitState {
  final String errorMessage;

  const TrackTimeLimitErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
