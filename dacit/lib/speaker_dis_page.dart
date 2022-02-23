import 'package:flutter/material.dart';

class SpeakerDis extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

/// This is the stateless widget that the main application instantiates.
class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Differantiate between two speakers here'),
      ),
      body: Center(
        child: Text('Is this the same, or a different speaker?')
      ),
    );
  }
}