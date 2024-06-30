import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg_manager/config/models/config_model.dart';
import 'package:pg_manager/config/ui/config/config_bloc.dart';
import 'package:pg_manager/config/ui/config/node/NodeCard.dart';

import '../../fw/node.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  @override
  void initState() {
    super.initState();
    context.read<ConfigBloc>().add(LoadConfigEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(builder: (context, state) {
      debugPrint(state.toString());
      if(state is ConfigInitState) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ CircularProgressIndicator(color: Colors.black45)
          ],);
      }
      else if(state is ConfigLoadErrorState) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Configuration not loaded from repository", style: TextStyle(color: Colors.red))
            ]);
      }
      else if(state is ConfigUpdatedSuccess) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Configuration ${state.updateConfigEvent.toString()} updated successfully",
                  style: const TextStyle(color: Colors.green))
            ]);
      }
      else if(state is ConfigUpdateFailed) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Configuration ${state.updateConfigEvent.toString()} update failed due to, \n${state.response.errorConfigs.map((e) => e.toString()).join("\n")}",
                  style: const TextStyle(color: Colors.red))
            ]);
      }
      else if (state is ConfigLoadedState) {
        return ConfigurationSelectionPage(config: state.config);
      }
      return Placeholder();
    });
  }
}

class ConfigurationSelectionPage extends StatefulWidget {
  final ClusterConfig config;
  const ConfigurationSelectionPage({super.key, required this.config});

  @override
  State<ConfigurationSelectionPage> createState() => _ConfigurationSelectionPageState();
}

class _ConfigurationSelectionPageState extends State<ConfigurationSelectionPage> {

  String? _selectedItem;
  ConfigTextEditController? editable;
  List<ConfigTextEditController> controllers = [];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.config.cluster.pub.id;
    widget.config.cluster.allNodes().forEach((node) {
      for (var config in node.configs) {
        controllers.add(ConfigTextEditController(node.id, config.name, config.value));
      }
    });
    controllers.forEach((element) {
      debugPrint(element.toString());
    });
  }

  @override
  void dispose() {
    controllers.forEach((element) { element.dispose(); });
    super.dispose();
  }

  void _onSubmit(String nodeId, String config, String value) {
    context.read<ConfigBloc>().add(UpdateConfigEvent(nodeId, config, value));
  }


  Widget header() {
    return Row(children: [
       DropdownButton<String>(
        hint: const Text('Select an Item'),
        value: _selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            _selectedItem = newValue;
          });
        },
        items: widget.config.cluster.names().map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList())
    ]);
  }

  Widget form() {
    Node node = widget.config.cluster.getNode(_selectedItem!);
    List<Config> configs = node.configs;
    return  Expanded(
    child: Column(
    children: [
    Expanded(
    child: ListView.builder(
    itemCount: configs.length,
    itemBuilder: (context, index) {
    String confName = configs[index].name;
    ConfigTextEditController controller = controllers.where((element) => element.id == _selectedItem && element.conf == confName).first;
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      readOnly: controller.readOnly,
      onChanged:(val) {
        if (val != controller.valueText) {
          controller.edit(val);
          editable = controller;
          controllers.asMap().forEach((_index, _controller) {
            debugPrint(_controller.toString());
            if(!_controller.equals(controller)) {
              _controller.readOnly = true;
            }});
        } else {
          for (var _element in controllers) { _element.reset();}
        }
        setState(() {

        });
      },
    controller: controller,
    decoration: InputDecoration(
    labelText: confName,
    border: OutlineInputBorder(),
    ),
    ),
    );
    },
    ),
    ),
      ElevatedButton(
        onPressed: () {
          if (editable!=null) {
            _onSubmit(editable!.id, editable!.conf, editable!.editText??"");
          }
          },
        child: Text('Update Configuration'),
      ),
    ],
    ));
  }

  Widget content() {
    debugPrint("selected item: $_selectedItem");
    if (_selectedItem == null) {
      return const Text('Invalid node detail error');
    }
    Node node = widget.config.cluster.getNode(_selectedItem!);
    return Expanded(child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        NodeCard(node: node),
        form()
    ],));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Reloaded");
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          header(),
          content(),
        ])
    );
  }
}

class ConfigTextEditController extends TextEditingController {
  String id;
  String conf;
  String valueText;
  String? editText;
  bool readOnly = false;
  ConfigTextEditController(this.id, this.conf, this.valueText) : super(text: valueText);
  bool equals(ConfigTextEditController _controller) =>
      id == _controller.id && conf == _controller.conf;

  void edit(String value) => editText = value;
  void reset() {
    readOnly = false;
    editText = null;
  }

  @override
  String toString() {
    return "$id $conf $valueText";
  }
}
