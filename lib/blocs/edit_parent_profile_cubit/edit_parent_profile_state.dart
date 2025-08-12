import 'package:equatable/equatable.dart';
import 'package:safe_view/models/edit_parent_profile_model.dart';


class EditParentProfileState extends Equatable {
  const EditParentProfileState();

  @override
  List<Object> get props => [];
}

class EditParentProfileInitialState extends EditParentProfileState {}

class EditParentProfileLoadingState extends EditParentProfileState {}

class EditParentProfileSuccessState extends EditParentProfileState {
  final EditParentProfileModel editParentProfileModel;

  const EditParentProfileSuccessState(
      {required this.editParentProfileModel});
  @override
  List<Object> get props => [editParentProfileModel];
}

class EditParentProfileErrorState extends EditParentProfileState {
  final String errorMessage;

  const EditParentProfileErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
