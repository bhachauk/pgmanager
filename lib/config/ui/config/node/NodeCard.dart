import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pg_manager/config/fw/node.dart';

class NodeCard extends StatelessWidget {
  final Node node;
  const NodeCard({super.key, required this.node});

  Widget getCard(IconData icon, String title, String subtitle) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 30,),
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ));
  }

  List<Widget> getTemplate() {
    return [
      getCard(Icons.computer, "Node", node.id),
      getCard(node.isPub ? Icons.publish : Icons.download, "Type", node.isPub ? "Publisher" : "Subscriber"),
      getCard(Icons.settings, "Configurations", node.configs.length.toString()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = getTemplate();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
        return items[index];
    }));
    return Expanded(child: Container(
      width: 500,
        height: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.red, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(12)
        ),
        child: GridView.count(
          shrinkWrap: true,
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(items.length, (index) {
        return items[index];
    }),
    )));
  }
}
