import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg_manager/config/fw/cluster.dart';
import 'package:pg_manager/config/fw/util.dart';

import '../../models/config_model.dart';
import '../../repo/config_repo.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  late ConfigRepository repository = DefaultConfigRepository();
  ConfigBloc(): super(ConfigInitState()) {
    on<LoadConfigEvent>((event, emit) async {
      if (await repository.loadConfig()) {
        emit(ConfigLoadedState(repository.clusterConfig));
      }
      else {
        emit(ConfigLoadErrorState());
      }
    });

    on<UpdateConfigEvent>((event, emit) async {
      debugPrint("${event.name} ${event.value}");
      UpdateResponse response = repository.clusterConfig.cluster.updateConfig(event.id, event.name, event.value);
      debugPrint("UpdateResponse: ${response.isValid}");
      if(response.isValid) {
        emit(ConfigUpdatedSuccess(event));
        repository.clusterConfig.cluster.setConfig(event.id, event.name, event.value);
      } else {
        emit(ConfigUpdateFailed(event, response));
      }
      await Future.delayed(const Duration(seconds: 2));
      emit(ConfigLoadedState(repository.clusterConfig));
    });

  }

}