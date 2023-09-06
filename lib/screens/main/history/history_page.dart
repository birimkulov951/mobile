import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_down_container.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: HistoryDownContainer(),
      );
}
