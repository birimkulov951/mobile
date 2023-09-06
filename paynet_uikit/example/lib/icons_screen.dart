import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

Widget _iconWithName({required Widget icon, required String name}) {
  return Column(
    children: [icon, Text(name)],
  );
}

class IconsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Action Icons',
              style: Typographies.title5,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _iconWithName(icon: ActionIcons.addPerson, name: 'addPerson'),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Operation Icons',
              style: Typographies.title5,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _iconWithName(
                    icon: OperationIcons.betweenAccounts,
                    name: 'betweenAccounts'),
                _iconWithName(
                    icon: OperationIcons.statusBlocked, name: 'statusBlocked'),
                _iconWithName(
                    icon: OperationIcons.statusCheck, name: 'statusCheck'),
                _iconWithName(
                    icon: OperationIcons.statusDelete, name: 'statusDelete'),
                _iconWithName(
                    icon: OperationIcons.statusInfo, name: 'statusInfo'),
                _iconWithName(
                    icon: OperationIcons.statusPaused, name: 'statusPaused'),
                _iconWithName(
                    icon: OperationIcons.statusRepit, name: 'statusRepit'),
                _iconWithName(
                    icon: OperationIcons.statusWarning, name: 'statusWarning'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
