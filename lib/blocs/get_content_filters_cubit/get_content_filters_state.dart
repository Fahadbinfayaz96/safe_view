import 'package:equatable/equatable.dart';
import 'package:safe_view/models/get_content_filter_model.dart';

class GetContentFiltersState extends Equatable {
  const GetContentFiltersState();

  @override
  List<Object> get props => [];
}

 class GetContentFiltersLoadingState extends GetContentFiltersState {}
 class GetContentFiltersLoadedState extends GetContentFiltersState {
  final GetContentFilterModel getContentFilter;

  const GetContentFiltersLoadedState({required this.getContentFilter});
  @override

  List<Object> get props => [getContentFilter];
 }
  class GetContentFiltersErrorState extends GetContentFiltersState {
  final String errorMessage;

  const GetContentFiltersErrorState({required this.errorMessage});
  @override

  List<Object> get props => [errorMessage];
 }