import 'package:flutter/material.dart';



class MinimalPairs extends StatelessWidget {

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
        title: Text('MinimalPairs'),
      ),
      body: Center(
        child: Text('See your messages here!')
      ),
    );
  }
}