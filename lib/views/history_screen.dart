import 'package:flutter/material.dart';
import 'package:truthscan_app/services/prediction_service.dart';
import 'package:truthscan_app/models/history_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: FutureBuilder<List<HistoryItem>>(
        future: PredictionService().fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history available'));
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: Icon(
                  item.prediction == 'ai' ? Icons.smart_toy : Icons.person,
                  color: item.prediction == 'ai' ? Colors.red : Colors.green,
                ),
                title: Text(
                  item.inputType == 'pdf'
                      ? 'PDF: ${item.inputText}'
                      : item.inputText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${item.prediction.toUpperCase()} (AI: ${item.confidence['ai']!.toStringAsFixed(1)}%, Human: ${item.confidence['human']!.toStringAsFixed(1)}%)',
                ),
                trailing: Text(
                  '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
