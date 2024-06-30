import 'dart:js_interop';

import 'cluster.dart';
import 'node.dart';

class UpdateRequest {
  ClusterFW cluster;
  String nodeId;
  String configName;
  String configValue;
  UpdateRequest(this.cluster, this.nodeId, this.configName, this.configValue);

  Node getNode() {
    return cluster.getNode(nodeId);
  }

  Config? getConfig() {
    return getNode().getConfig(configName);
  }
}

class UpdateResponse {
  bool isValid = false;
  List<ErrorNodeConfig> errorConfigs = [];
  UpdateResponse({this.isValid=false});
  static UpdateResponse suc() {
    return UpdateResponse(isValid: true);
  }
  void err(String nodeId, String config, String msg) {
    errorConfigs.add(ErrorNodeConfig(nodeId, config, msg));
  }
}

class ErrorNodeConfig {
  String nodeId;
  String config;
  String errorMsg;
  ErrorNodeConfig(this.nodeId, this.config, this.errorMsg);

  @override
  String toString() {
    return "Node: $nodeId, Config: $config Error: $errorMsg";
  }
}

class ErrMsgs {
  static String CAVEAT_SUBS_LOWER_VALUE = "Subscriber have lower value. Please increase subscriber value first";
  static String CAVEAT_PUB_HIGHER_VALUE = "Publisher have higher value. Please decrease publisher value first";
}