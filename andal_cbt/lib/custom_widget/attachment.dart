import 'package:flutter/material.dart';

class Attachment extends StatefulWidget {
  const Attachment({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Make background clean
      insetPadding: const EdgeInsets.all(
        24,
      ), // Leave some space from screen edges
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // The Image Container
          Container(
            width: 600.0,
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                // Allows user to zoom in/out
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        Text("Image failed to load"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Close Button (Top Right)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
