import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MinimalPairs extends StatefulWidget {
  const MinimalPairs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MinimalPairsState();
}

class MinimalPairsState extends State<MinimalPairs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
          child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.get_app),
            tooltip: 'Test connection',
            onPressed: () {
              getMinPair();
            },
          ),
          const Text('This is an app developed for a master thesis etc')
        ],
      )),
    );
  }
}

Future<Minpair> getMinPair() async {
  var response =
      await http.get(Uri.parse("http://localhost:8000/minpair?category=K_T"));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    log(responseData.toString());
    Minpair minPair = Minpair(
      id: responseData["minpair"],
      firstStimulus: responseData["first_stimulus"],
      firstAudio: Uri.parse(responseData["first_audio"]),
      secondText: responseData["second_text"],
      secondAudio: Uri.parse(responseData["second_audio"]),
    );
    return minPair;
  } else {
    log("Server could not be reached");
    throw Error();
  }
}

class Minpair {
  final int id;
  final String firstStimulus;
  final Uri firstAudio;
  final String secondText;
  final Uri secondAudio;

  const Minpair(
      {required this.id,
      required this.firstStimulus,
      required this.firstAudio,
      required this.secondText,
      required this.secondAudio});
}
