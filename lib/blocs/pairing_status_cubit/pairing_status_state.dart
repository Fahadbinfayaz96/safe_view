part of 'pairing_status_cubit.dart';

sealed class PairingStatusState extends Equatable {
  const PairingStatusState();

  @override
  List<Object> get props => [];
}

final class PairingStatusLoadingState extends PairingStatusState {}
final class PairingStatusLoadedState extends PairingStatusState {
  final PairingStatusModel pairingStatus;

  const PairingStatusLoadedState({required this.pairingStatus});
  @override
  List<Object> get props => [pairingStatus];
}

final class PairingStatusErrorState extends PairingStatusState {
  final String errorMessage;

  const PairingStatusErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}