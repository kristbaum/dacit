class MinPair {
  final int id;
  final String category;
  final String firstStimulus;
  final Uri firstAudio;
  final String secondStimulus;
  final Uri secondAudio;

  const MinPair(
      {required this.id,
      required this.category,
      required this.firstStimulus,
      required this.firstAudio,
      required this.secondStimulus,
      required this.secondAudio});

  factory MinPair.fromJson(Map<String, dynamic> json) {
    return MinPair(
      id: json['minpair'],
      category: json['category'],
      firstStimulus: json["first_stimulus"],
      firstAudio: Uri.parse(json["first_audio"]),
      secondStimulus: json["second_stimulus"],
      secondAudio: Uri.parse(json["second_audio"]),
    );
  }
}
