import 'package:equatable/equatable.dart';
import 'package:safe_view/models/send_kids_activities.dart';

class SendKidsActivitiesState extends Equatable {
  const SendKidsActivitiesState();

  @override
  List<Object> get props => [];
}

class SendKidsActivitiesInitialState extends SendKidsActivitiesState {}

class SendKidsActivitiesLoadingState extends SendKidsActivitiesState {}

class SendKidsActivitiesLoadedState extends SendKidsActivitiesState {
  final SendKidsActivitiesModel sendKidsActivities;

  const SendKidsActivitiesLoadedState({required this.sendKidsActivities});
  @override
  List<Object> get props => [sendKidsActivities];
}

class SendKidsActivitiesErrorState extends SendKidsActivitiesState {
  final String errorMessage;

  const SendKidsActivitiesErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
