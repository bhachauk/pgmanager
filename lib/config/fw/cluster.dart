import 'node.dart';
import 'util.dart';
import 'rules.dart';

class Cluster extends ClusterFW {
  Cluster(super.pub);
}


abstract class ClusterFW {
  List<Node> subs = [];
  Node pub;
  ClusterFW(this.pub);
  void setConfig(String nodeId, String configName, String value) {
    Node node = getNode(nodeId);
    node.getConfig(configName)?.value = value;
  }

  UpdateResponse updateConfig(String nodeId, String configName, String value) {
    UpdateRequest request = UpdateRequest(this, nodeId, configName, value);
    return Rules.update(request);
  }
  Node getNode(String nodeId) {
    if (pub.id == nodeId) {
      return pub;
    }
    return subs.where((element) => element.id == nodeId).first;
  }
  List<String> names() {
    List<String> names = [];
    names.add(pub.id);
    for (var element in subs) {
      names.add(element.id);
    }
    return names;
  }

  List<Node> allNodes() {
    List<Node> nodes = [];
    nodes.add(pub);
    nodes.addAll(subs);
    return nodes;
  }
}




