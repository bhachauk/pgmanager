import 'node.dart';
import 'util.dart';

class Rules {

  static List<Rule> rules = [
    CaveatRule(),
  ];

  static UpdateResponse update(UpdateRequest updateRequest)
  {
    for (var element in rules) {
      UpdateResponse response = element.validate(updateRequest);
      if(!response.isValid) {
        return response;
      }
    }
    return UpdateResponse.suc();
  }
}

abstract class Rule {
  UpdateResponse validate(UpdateRequest request);
}

// https://www.postgresql.org/docs/current/hot-standby.html#:~:text=is%20changed.%20The-,parameters,-affected%20are%3A
class CaveatRule extends Rule {
  final List<String> params = [
    'max_connections',
    'max_prepared_transactions',
    'max_locks_per_transaction',
    'max_wal_senders',
    'max_worker_processes'
  ];

  // publisher value <= subscriber
  @override
  UpdateResponse validate(UpdateRequest request) {

    Node node = request.getNode();
    Config? config = request.getConfig();
    String value = request.configValue;
    int intVal = int.parse(value);
    Node pub = request.cluster.pub;
    int pubVal = int.parse(pub.getConfig(config!.name)!.value);

    if(!params.contains(config?.name)) {
      return UpdateResponse.suc();
    }
    if(node.isPub){
      Iterable<Node> inValidIds = request.cluster.subs
          .where((element) => int.parse(element.getConfig(config!.name)!.value) < intVal);
      if(inValidIds.isEmpty) {
        return UpdateResponse.suc();
      }
      UpdateResponse updateResponse = UpdateResponse(isValid: false);
      for (var element in inValidIds) {
        updateResponse.err(element.id, request.configName, ErrMsgs.CAVEAT_SUBS_LOWER_VALUE);
      }
      return updateResponse;
    }
    print("pubVal ${value.toString()} inputValue $value");
    if (pubVal <= intVal) {
      return UpdateResponse.suc();
    }
      UpdateResponse response = UpdateResponse(isValid: false);
      response.err(pub.id, config.name, ErrMsgs.CAVEAT_PUB_HIGHER_VALUE);
      return response;
  }
}