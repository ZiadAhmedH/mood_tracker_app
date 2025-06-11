class AnswerOption {
  final String text;
  final int score;

  AnswerOption({required this.text, required this.score});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      text: json['text'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'score': score,
      };
}
