import 'package:equatable/equatable.dart';
import 'package:safe_view/models/unlink_device_model.dart';

class UnlinkDeviceState extends Equatable {
  const UnlinkDeviceState();

  @override
  List<Object> get props => [];
}

class UnlinkDeviceInitialState extends UnlinkDeviceState {}

class UnlinkDeviceLoadingState extends UnlinkDeviceState {}

class UnlinkDeviceUnlinkSuccessState extends UnlinkDeviceState {
  final UnlinkDeviceModel unlinkDevice;

  const UnlinkDeviceUnlinkSuccessState({required this.unlinkDevice});
  @override
  List<Object> get props => [unlinkDevice];
}

class UnlinkDeviceErrorState extends UnlinkDeviceState {
  final String errorMessage;

  const UnlinkDeviceErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
