import 'package:flutter/material.dart';

class RecordPage extends StatelessWidget {

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
        title: Text('Record Audio'),
      ),
      body: Center(
        child: Text('Record audio to help your peers. Record the word: Teepot')
      ),
    );
  }
}