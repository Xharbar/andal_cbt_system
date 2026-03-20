import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:quiz_creator/screens/create_quiz.dart';
import 'package:quiz_creator/screens/pdf_preview.dart';

Future<void> generatePdf({
  required BuildContext context,
  required String examTitle,
  required String subject,
  required String examClass,
  required String duration,
  required List<QuestionModel> questions,
}) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load("lib/assets/fonts/Lato-Regular.ttf");
  final boldFontData = await rootBundle.load("lib/assets/fonts/Lato-Bold.ttf");

  final font = pw.Font.ttf(fontData);
  final boldFont = pw.Font.ttf(boldFontData);

  final imageByteData = await rootBundle.load(
    "lib/assets/images/andal_logo.png",
  );
  final imageBytes = imageByteData.buffer.asUint8List();
  final emblem = pw.MemoryImage(imageBytes);

  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: font, bold: boldFont),

      build: (pw.Context context) {
        return [
          // TOP HEADER SECTION
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Emblem
              pw.Container(width: 80, height: 80, child: pw.Image(emblem)),
              pw.SizedBox(width: 10),
              // Text Titles
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'ANDAL SCIENCE ACADEMY',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'C22, Gwarzo Road, Kabuga, Kano.',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      // _titleCtrl.text.toUpperCase(), // Dynamic Quiz Title
                      examTitle.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // THE INPUT TABLE SECTION
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(width: 1.5),
              ),
            ),
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'SUBJECT: $subject',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'CLASS: $examClass',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'DURATION: $duration mins',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SECTION HEADER
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Center(
              child: pw.Text(
                'CBT Exam Questions',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),

          // Rest of your questions go here...
          ...questions.asMap().entries.map((e) {
            int i = e.key + 1;
            var q = e.value;

            pw.Widget? imageWidget;
            if (q.imagePath != null && File(q.imagePath!).existsSync()) {
              final imageBytes = File(q.imagePath!).readAsBytesSync();
              imageWidget = pw.Container(
                height: 150, // Limit height
                alignment: pw.Alignment.centerLeft,
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            }

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Q$i: ${q.text}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (imageWidget != null) imageWidget,
                pw.SizedBox(height: 5),
                // pw.Wrap(
                //   spacing: 20,
                //   runSpacing: 10,
                //   children: q.options.asMap().entries.map((opt) {
                //     return pw.Row(
                //       children: [
                //         pw.Container(
                //           width: 20,
                //           height: 20,
                //           child: pw.Text(
                //             "${String.fromCharCode(65 + opt.key)}. ${opt.value}",
                //           ),
                //         ),
                //       ],
                //     );
                //   }).toList(),
                // ),
                pw.Wrap(
                  spacing: 20, // Horizontal space between options
                  runSpacing: 10, // Vertical space if they drop to next line
                  children: q.options.asMap().entries.map((opt) {
                    final label = String.fromCharCode(
                      65 + opt.key,
                    ); // A, B, C...
                    final String imagePath = q.optionImagePath[opt.key];

                    pw.Widget? optionImageWidget;
                    if (imagePath != "" && File(imagePath).existsSync()) {
                      final optBytes = File(imagePath).readAsBytesSync();
                      optionImageWidget = pw.Container(
                        height: 60, // Keep option images relatively small
                        child: pw.Image(
                          pw.MemoryImage(optBytes),
                          fit: pw.BoxFit.contain,
                        ),
                      );
                    }

                    return pw.Container(
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "$label. ",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: boldFont,
                            ),
                          ),
                          // Flexible allows text to wrap *inside* the option
                          // if the specific option is wider than the page
                          pw.Flexible(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  opt.value,
                                  style: pw.TextStyle(font: font),
                                ),

                                if (optionImageWidget != null) ...[
                                  pw.SizedBox(height: 5),
                                  optionImageWidget,
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                pw.SizedBox(height: 15),
              ],
            );
          }),
        ];
      },
    ),
  );

  // 1. Generate the raw bytes
  final Uint8List bytes = await pdf.save();

  // 2. Save to Temp File
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/preview_cache.pdf');
  await file.writeAsBytes(bytes);

  // 2. Navigate to the Preview Screen
  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          filePath: file.path,
          fileName: "${subject}_${examClass}_Quiz.pdf",
          onSave: (tempPath) async {
            // 4. Handle Final Save
            // Read bytes back from the temp file and pass to your save logic
            final savedBytes = await File(tempPath).readAsBytes();
            _saveAndOpenBytes(savedBytes, "${subject}_${examClass}_Quiz.pdf");
          },
        ),
      ),
    );
  }
}

// Helper method to handle Mobile vs Desktop saving
Future<void> _saveAndOpenBytes(List<int> bytes, String fileName) async {
  try {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF',
        fileName: fileName,
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsBytes(bytes);
        await OpenFilex.open(outputFile);
      }
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    }
  } catch (e) {
    return;
  }
}
