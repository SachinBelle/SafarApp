import 'package:flutter/material.dart';

class InitialUIDPage extends StatefulWidget {
  const InitialUIDPage({super.key});

  @override
  State<InitialUIDPage> createState() => InitialUIDPageState();
}



class InitialUIDPageState extends State<InitialUIDPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

    );
  }
}