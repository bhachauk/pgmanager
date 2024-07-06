import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../fw/node.dart';
import '../models/config_model.dart';

abstract class ConfigRepository {
  late ClusterConfig clusterConfig;
  bool loaded = false;
  ConfigRepository();

  Future<bool> loadConfig();

  String export() {
    Map data = {};
    data.putIfAbsent(clusterConfig.cluster.pub.id, () => clusterConfig.cluster.pub.configs);
    for (var sub in clusterConfig.cluster.subs) {
      data.putIfAbsent(sub.id, () => sub.configs);
    }
    return json.encode(data);
  }
}

// Demo purpose
class DefaultConfigRepository extends ConfigRepository {
  @override
  Future<bool> loadConfig() async {
      await Future.delayed(const Duration(seconds: 1));
      if (loaded) {
        return true;
      }
      clusterConfig = ClusterConfig();
      String contents = await rootBundle.loadString('assets/postgres.json');
      clusterConfig.cluster.pub.configs.addAll(getDefaultConfigs(contents));
      Node sub1 = Node('Subscriber 1');
      clusterConfig.cluster.subs.add(sub1);
      for (var element in clusterConfig.cluster.subs) {
        element.configs.addAll(getDefaultConfigs(contents));
      }
      loaded = true;
      return true;
  }

  List<Config> getDefaultConfigs(String contents) {
    return Map<String, String>.from(jsonDecode(contents)).entries.map((element) {
      return Config(element.key,element.value);
    }).toList();

  }

}