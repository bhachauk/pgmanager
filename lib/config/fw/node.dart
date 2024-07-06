class Node {
  String id;
  bool isPub;
  List<Config> configs = [];
  Node(this.id, {this.isPub=false});

  Config? getConfig(String name){
    return configs.where((element) => element.name == name).first;
  }

  String confText() {
    String text = "# postgres config text exported from https://bhachauk.github.io/pgmanager\n";
    configs.forEach((element) {
      text +='${element.name}=${element.value}\n';
    });
    return text;
  }
}

class Config {
  String name;
  String value;
  Config(this.name, this.value);
}