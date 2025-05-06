class HistoryItem {
  final int id;
  final String inputType;
  final String inputText;
  final String prediction;
  final Map<String, double> confidence;
  final DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.inputType,
    required this.inputText,
    required this.prediction,
    required this.confidence,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      inputType: json['input_type'],
      inputText: json['input_text'],
      prediction: json['prediction'],
      confidence: {
        'ai': (json['confidence']['ai'] as num).toDouble(),
        'human': (json['confidence']['human'] as num).toDouble(),
      },
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
