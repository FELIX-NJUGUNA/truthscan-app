import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:truthscan_app/services/prediction_service.dart';
import 'package:truthscan_app/models/prediction_result.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final TextEditingController inputController = TextEditingController();
  final PredictionService predictionService = PredictionService();

  PredictionResult? result;
  bool isLoading = false;
  String? error;
  String? uploadedPdfName;
  Uint8List? uploadedPdfBytes;

  void _analyzeContent() async {
    setState(() {
      isLoading = true;
      error = null;
      result = null;
    });

    try {
      if (uploadedPdfBytes != null && uploadedPdfName != null) {
        final prediction = await predictionService.analyzePdfFile(
          uploadedPdfBytes!,
          uploadedPdfName!,
        );
        setState(() => result = prediction);
      } else {
        final text = inputController.text.trim();
        if (text.isEmpty) {
          throw Exception("Please provide some input or upload a PDF.");
        }
        final prediction = await predictionService.analyzeText(text);
        setState(() => result = prediction);
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickPdf() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (picked != null && picked.files.single.bytes != null) {
      setState(() {
        uploadedPdfBytes = picked.files.single.bytes;
        uploadedPdfName = picked.files.single.name;
        inputController.clear();
      });
    }
  }

  void _clearPdf() {
    setState(() {
      uploadedPdfBytes = null;
      uploadedPdfName = null;
    });
  }

  Widget _buildInputArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Text or Upload PDF",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            TextField(
              controller: inputController,
              maxLines: 6, // Reduced max lines for a less tall initial view
              enabled: uploadedPdfBytes == null,
              decoration: InputDecoration(
                hintText: "Paste your text here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: InkWell(
                onTap: isLoading ? null : _pickPdf,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (uploadedPdfName != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.orange),
                title: Text(
                  uploadedPdfName!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: _clearPdf,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultCard() {
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      );
    }

    if (result == null) return const SizedBox.shrink();

    final double aiConfidence = result!.confidence['ai']?.toDouble() ?? 0.0;
    final double humanConfidence =
        result!.confidence['human']?.toDouble() ?? 0.0;
    final bool isAiGenerated = aiConfidence > humanConfidence;
    final features = result!.features;

    Widget circularIndicator(String label, double value, Color color) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 8,
                  color: color,
                  backgroundColor: color.withValues(),
                ),
              ),
              Text(
                "${value.toStringAsFixed(0)}%",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      );
    }

    Widget featureItem(String name, String description, bool isPresent) {
      return Row(
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAiGenerated ? "AI-Generated" : "Human-Written",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isAiGenerated ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                circularIndicator("AI", aiConfidence, Colors.indigo),
                circularIndicator("Human", humanConfidence, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            if (features.isNotEmpty) ...[
              const Text(
                "Detected Features:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              featureItem(
                "Repetitive Words",
                "Excessive repetition of words",
                features['repetitive_words'] > 0.5,
              ),
              const SizedBox(height: 8),
              featureItem(
                "Vocabulary Diversity",
                "Ratio of unique to total words",
                features['type_token_ratio'] > 0.5,
              ),
              const SizedBox(height: 8),
              featureItem(
                "Verb Usage",
                "Proportion of verbs used",
                features['verb_ratio'] > 0.5,
              ),
              const SizedBox(height: 8),
              featureItem(
                '"In Conclusion" Present',
                "Common AI conclusion phrase",
                features['word_inconclusion_presence'] > 0.5,
              ),
              const SizedBox(height: 8),
              featureItem(
                '"This" Present',
                "Use of demonstrative pronouns",
                features['word_this_presence'] > 0.5,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TruthScan Analyzer"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Paste text or upload a PDF to analyze for AI-generated content.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildInputArea(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _analyzeContent,
              icon: const Icon(Icons.search),
              label: const Text("Analyze"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            if (isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
