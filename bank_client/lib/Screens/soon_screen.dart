import 'package:bank_app/Modules/Components/soon.dart';
import 'package:flutter/material.dart';

class SoonScreen extends StatelessWidget {
  const SoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Coming soon"),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        body: const Soon());
  }
}
