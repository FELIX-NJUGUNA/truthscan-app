class PredictionResult {
  final String prediction;
  final Map<String, double> confidence;
  final Map<String, dynamic> features;

  PredictionResult({
    required this.prediction,
    required this.confidence,
    required this.features,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'],
      confidence: {
        'ai': (json['confidence']['ai'] as num).toDouble(),
        'human': (json['confidence']['human'] as num).toDouble(),
      },
      features: json['features'],
    );
  }
}
