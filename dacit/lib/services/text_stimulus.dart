class TextStimulus {
  final String stimulus;
  final int id;

  const TextStimulus({
    required this.stimulus,
    required this.id,
  });

  factory TextStimulus.fromJson(Map<String, dynamic> json) {
    return TextStimulus(
      stimulus: json['stimulus'],
      id: json['id'],
    );
  }
}