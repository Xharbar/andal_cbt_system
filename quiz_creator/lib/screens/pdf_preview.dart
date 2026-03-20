import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String filePath;
  final String fileName;
  final Function(String) onSave;

  const PdfPreviewScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => onSave(filePath), // Trigger save from here
          ),
        ],
      ),
      // This widget renders the PDF in-app
      body: !(Platform.isWindows || Platform.isMacOS || Platform.isLinux)
          ? PDFView(filePath: filePath, autoSpacing: true, pageFling: true)
          : Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/images/under_construction.png",
                      height: 270,
                      width: 270,
                    ),
                    Text(
                      "Under Development",
                      style: TextStyle(
                        fontSize: 32,
                        // color: Color(0xffF2B3E5),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "This feature is currently unavailable on this platform. To proceed, please click the button below to download the PDF file and open it using a compatible PDF viewer.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                    SizedBox(height: 25),
                    FilledButton.icon(
                      onPressed: () => onSave(filePath),
                      label: Text("Save PDF", style: TextStyle(fontSize: 16)),
                      icon: Icon(Icons.save, size: 24.0),
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(250, 50)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart'; // Import pdfrx

class PdfPreviewScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final Function(String) onSave;

  const PdfPreviewScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.onSave,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  // Controller allows zooming and page navigation
  final PdfViewerController _controller = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => _controller.zoomUp(),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => _controller.zoomDown(),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => widget.onSave(widget.filePath),
          ),
        ],
      ),
      // The Viewer Widget
      body: PdfViewer.file(
        widget.filePath,
        controller: _controller,
        params: PdfViewerParams(
          maxScale: 4.0,
          // Nice background color for desktop feel
          // backgroundColor: Colors.grey[200],
          // Layout pages vertically with spacing
          layoutPages: (pages, params) {
            final height = pages.fold(0.0, (prev, page) => prev + page.height) + pages.length * 20;
            return PdfPageLayout(
              pageLayouts: List.generate(pages.length, (index) {
                return Rect.fromLTWH(
                  0,
                  index == 0 ? 0 : pages.sublist(0, index).fold(0.0, (p, n) => p + n.height) + index * 20,
                  pages[index].width,
                  pages[index].height,
                );
              }),
              documentSize: Size(pages.first.width, height),
            );
          },
        ),
      ),
    );
  }
}
*/
