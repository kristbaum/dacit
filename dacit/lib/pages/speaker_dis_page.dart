import 'package:flutter/material.dart';

class SpeakerDisPage extends StatelessWidget {
  const SpeakerDisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Main();
  }
}

/// This is the stateless widget that the main application instantiates.
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Differantiate between two speakers here'),
      ),
      body: const Center(
          child: Text('Is this the same, or a different speaker?')),
    );
  }
}
