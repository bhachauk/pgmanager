part of 'config_bloc.dart';


abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object?> get props => [];
}

class ConfigInitState extends ConfigState {}

class ConfigLoadedState extends ConfigState {
  final ClusterConfig config;
  const ConfigLoadedState(this.config);
}

class ConfigUpdateState extends ConfigState {
  final UpdateConfigEvent updateConfigEvent;
  const ConfigUpdateState(this.updateConfigEvent);

}
class ConfigUpdatedSuccess extends ConfigUpdateState {
  ConfigUpdatedSuccess(super.updateConfigEvent);
}

class ConfigUpdateFailed extends ConfigUpdateState {
  final UpdateResponse response;
  const ConfigUpdateFailed(super.updateConfigEvent, this.response);
}

class ConfigLoadErrorState extends ConfigState {}

