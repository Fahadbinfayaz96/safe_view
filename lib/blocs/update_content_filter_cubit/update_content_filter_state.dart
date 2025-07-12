import 'package:equatable/equatable.dart';
import 'package:safe_view/models/update_content_filter_model.dart';

class UpdateContentFilterState extends Equatable {
  const UpdateContentFilterState();

  @override
  List<Object> get props => [];
}

class UpdateContentFilterInitailState extends UpdateContentFilterState {}

class UpdateContentFilterLoadingState extends UpdateContentFilterState {}

class UpdateContentFilterSuccessState extends UpdateContentFilterState {
  final UpdateContentFilterModel updateContentFilter;

  const UpdateContentFilterSuccessState({required this.updateContentFilter});
  @override
  List<Object> get props => [updateContentFilter];
}

class UpdateContentFilterErrorState extends UpdateContentFilterState {
  final String errorMessage;

  const UpdateContentFilterErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
