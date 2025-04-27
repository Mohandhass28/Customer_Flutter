import 'package:flutter/material.dart';

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({super.key});

  @override
  State<PastOrdersPage> createState() => _PastOrdersPageState();
}

class _PastOrdersPageState extends State<PastOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past Orders"),
      ),
    );
  }
}
