import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'globals.dart';
import 'min_pair.dart';

Future<MinPair> getMinPair() async {
  var response = await http
      .get(Uri.parse("$baseDomain/api/minpair?category=K_T"), headers: {
    HttpHeaders.authorizationHeader: 'Basic ${user.token}',
  });
  if (response.statusCode == 200) {
    return MinPair.fromJson(json.decode(response.body));
//    audioSource = ap.AudioSource.uri(minPair.firstAudio);
  } else {
    throw Exception("Failed to load Minpair!");
  }
}
