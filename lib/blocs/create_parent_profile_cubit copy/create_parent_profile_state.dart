import 'package:equatable/equatable.dart';
import 'package:safe_view/models/create_parent_profile_model.dart';

class CreateParentProfileState extends Equatable {
  const CreateParentProfileState();

  @override
  List<Object> get props => [];
}

class CreateParentProfileInitialState extends CreateParentProfileState {}

class CreateParentProfileLoadingState extends CreateParentProfileState {}

class CreateParentProfileSuccessState extends CreateParentProfileState {
  final CreateParentProfileModel createParentProfileModel;

  const CreateParentProfileSuccessState(
      {required this.createParentProfileModel});
  @override
  List<Object> get props => [createParentProfileModel];
}

class CreateParentProfileErrorState extends CreateParentProfileState {
  final String errorMessage;

  const CreateParentProfileErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
