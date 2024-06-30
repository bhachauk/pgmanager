class Node {
  String id;
  bool isPub;
  List<Config> configs = [];
  Node(this.id, {this.isPub=false});

  Config? getConfig(String name){
    return configs.where((element) => element.name == name).first;
  }
}

class Config {
  String name;
  String value;
  Config(this.name, this.value);
}