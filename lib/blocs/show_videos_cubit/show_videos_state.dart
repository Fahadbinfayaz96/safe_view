import 'package:equatable/equatable.dart';
import 'package:safe_view/models/show_videos_model.dart';

class ShowVideosState extends Equatable {
  const ShowVideosState();

  @override
  List<Object> get props => [];
}

 class ShowVideosLoadingState extends ShowVideosState {}
 class ShowVideosLoadedState extends ShowVideosState {
  final ShowVideosModel showVideos;

  const ShowVideosLoadedState({required this.showVideos});
  @override

  List<Object> get props => [showVideos];
 }

 class ShowVideosErrorState extends ShowVideosState {
  final String errorMessage;

  const ShowVideosErrorState({required this.errorMessage});
  @override

  List<Object> get props => [errorMessage];
 }