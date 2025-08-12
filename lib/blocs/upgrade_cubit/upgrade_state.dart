import 'package:equatable/equatable.dart';
import 'package:safe_view/models/upgrade_model.dart';

class UpgradeState extends Equatable {
  const UpgradeState();

  @override
  List<Object> get props => [];
}

class UpgradeInitialState extends UpgradeState {}

class UpgradeLoadingState extends UpgradeState {}

class UpgradeSuccessState extends UpgradeState {
  final UpgradeModel upgradeModel;

  const UpgradeSuccessState({required this.upgradeModel});
  @override
  List<Object> get props => [upgradeModel];
}

class AlreadyRequestedUpgradeState extends UpgradeState {
  final String message;

  const AlreadyRequestedUpgradeState({required this.message});
  @override
  List<Object> get props => [message];
}
class UpgradeErrorState extends UpgradeState {
  final String errorMessage;

  const UpgradeErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
