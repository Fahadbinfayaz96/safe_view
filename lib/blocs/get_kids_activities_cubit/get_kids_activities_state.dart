
 import 'package:equatable/equatable.dart';
import 'package:safe_view/models/get_kids_activities_model.dart';

class GetKidsActivitiesState extends Equatable {
  const GetKidsActivitiesState();

  @override
  List<Object> get props => [];
}

 class GetKidsActivitiesLoadingState extends GetKidsActivitiesState {}

 class GetKidsActivitiesLoadedState extends GetKidsActivitiesState {
  final List<GetKidsActivitiesModel> getKidsActivities;

  const GetKidsActivitiesLoadedState({required this.getKidsActivities});
  @override

  List<Object> get props => [getKidsActivities];
  
 }
  class GetKidsActivitiesEmptyState extends GetKidsActivitiesState {
  final String emptyMessage;

  const GetKidsActivitiesEmptyState({required this.emptyMessage});
  @override

  List<Object> get props => [emptyMessage];
 }
 class GetKidsActivitiesErrorState extends GetKidsActivitiesState {
  final String errorMessage;

  const GetKidsActivitiesErrorState({required this.errorMessage});
  @override

  List<Object> get props => [errorMessage];
 }
