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

class ConfigUpdatedSuccess extends ConfigState {
  final UpdateConfigEvent updateConfigEvent;
  const ConfigUpdatedSuccess(this.updateConfigEvent);
}

class ConfigUpdateFailed extends ConfigState {
  final UpdateConfigEvent updateConfigEvent;
  final UpdateResponse response;
  const ConfigUpdateFailed(this.updateConfigEvent, this.response);
}

class ConfigLoadErrorState extends ConfigState {}

