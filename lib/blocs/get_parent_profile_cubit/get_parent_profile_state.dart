import 'package:equatable/equatable.dart';
import 'package:safe_view/models/get_parent_profile_model.dart';

class GetParentProfileState extends Equatable {
  const GetParentProfileState();

  @override
  List<Object> get props => [];
}

class GetParentProfileLoadingState extends GetParentProfileState {}

class GetParentProfileLoadedState extends GetParentProfileState {
  final GetParentProfileModel getParentProfileModel;

  const GetParentProfileLoadedState({required this.getParentProfileModel});
  @override
  List<Object> get props => [getParentProfileModel];
}
class GetParentProfileEmptyState extends GetParentProfileState {
  final String emptyMessage;

  const GetParentProfileEmptyState({required this.emptyMessage});
  @override
  List<Object> get props => [emptyMessage];
}
class GetParentProfileErrorState extends GetParentProfileState {
  final String errorMessage;

  const GetParentProfileErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
