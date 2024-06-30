import 'dart:convert';

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

class DefaultConfigRepository extends ConfigRepository {
  @override
  Future<bool> loadConfig() async {
      await Future.delayed(const Duration(seconds: 1));
      if (loaded) {
        return true;
      }
      clusterConfig = ClusterConfig();
      clusterConfig.cluster.pub.configs.addAll(getDefaultConfigs());
      Node sub1 = Node('Subscriber 1');
      clusterConfig.cluster.subs.add(sub1);
      for (var element in clusterConfig.cluster.subs) {
        element.configs.addAll(getDefaultConfigs());
      }
      loaded = true;
      return true;
  }

  List<Config> getDefaultConfigs() => <Config>[
    Config('max_wal_senders', '10'),
    Config('max_replication_slots', '10'),
  ];

}