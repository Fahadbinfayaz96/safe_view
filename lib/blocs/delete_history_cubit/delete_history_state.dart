import 'package:equatable/equatable.dart';
import 'package:safe_view/models/delete_history_model.dart';

class DeleteHistoryState extends Equatable {
  const DeleteHistoryState();

  @override
  List<Object> get props => [];
}

class DeleteHistoryInitialState extends DeleteHistoryState {}

class DeleteHistoryLoadingState extends DeleteHistoryState {}

class DeleteHistorySuccessState extends DeleteHistoryState {
  final DeleteHistoryModel deleteHistoryModel;

  const DeleteHistorySuccessState({required this.deleteHistoryModel});
  @override
  List<Object> get props => [deleteHistoryModel];
}

class DeleteHistoryErrorState extends DeleteHistoryState {
  final String message;

  const DeleteHistoryErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
