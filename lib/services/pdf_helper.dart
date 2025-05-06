import 'dart:io';
import 'package:pdf_text/pdf_text.dart';

class PdfHelper {
  static Future<String> extractText(File pdfFile) async {
    try {
      final PDFDoc doc = await PDFDoc.fromFile(pdfFile);
      return await doc.text;
    } catch (e) {
      throw Exception("Failed to extract text from PDF: $e");
    }
  }
}
