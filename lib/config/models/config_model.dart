import 'package:pg_manager/config/fw/cluster.dart';
import 'package:pg_manager/config/fw/node.dart';

class ClusterConfig {

  late Cluster cluster;
  ClusterConfig() {
    Node pub = Node('Default Publisher', isPub: true);
    cluster = Cluster(pub);
  }
}