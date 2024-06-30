part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object?> get props => [];
}

class LoadConfigEvent extends ConfigEvent {}

class UpdateConfigEvent extends ConfigEvent {
  final String id;
  final String name;
  final String value;
  const UpdateConfigEvent(this.id, this.name, this.value);
  @override
  String toString() {
    return "node=$id, config=$name, value=$value";
  }
}