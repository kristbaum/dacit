import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'globals.dart';

Future<Minpair> getMinPair() async {
  var response = await http.get(
      Uri.parse("$baseDomain/api/minpair?category=K_T"),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic ${user.token}',
      });
  if (response.statusCode == 200) {
    return Minpair.fromJson(json.decode(response.body));
//    audioSource = ap.AudioSource.uri(minPair.firstAudio);
  } else {
    throw Exception("Failed to load Minpair!");
  }
}

class Minpair {
  final int id;
  final String firstStimulus;
  final Uri firstAudio;
  final String secondStimulus;
  final Uri secondAudio;

  const Minpair(
      {required this.id,
      required this.firstStimulus,
      required this.firstAudio,
      required this.secondStimulus,
      required this.secondAudio});

  factory Minpair.fromJson(Map<String, dynamic> json) {
    return Minpair(
      id: json['minpair'],
      firstStimulus: json["first_stimulus"],
      firstAudio: Uri.parse(json["first_audio"]),
      secondStimulus: json["second_stimulus"],
      secondAudio: Uri.parse(json["second_audio"]),
    );
  }
}
