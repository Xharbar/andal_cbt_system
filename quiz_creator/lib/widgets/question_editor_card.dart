// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quiz_creator/screens/create_quiz.dart';

// Helper Widget for Editing a Single Question
class QuestionEditorCard extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final VoidCallback onDelete;

  const QuestionEditorCard({
    super.key,
    required this.index,
    required this.question,
    required this.onDelete,
  });

  @override
  State<QuestionEditorCard> createState() => _QuestionEditorCardState();
}

class _QuestionEditorCardState extends State<QuestionEditorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  child: Text(
                    "${widget.index + 1}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.question.text,
                    onChanged: (v) => widget.question.text = v,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Question Text",
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            if (widget.question.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.attachment, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      widget.question.imagePath!.split('/').last,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          setState(() => widget.question.imagePath = null),
                      child: const Text("Remove"),
                    ),
                  ],
                ),
              ),
            const Divider(),
            const SizedBox(height: 8),
            // Options Grid
            Column(
              children: List.generate(4, (optIndex) {
                return RadioListTile<int>(
                  value: optIndex,
                  groupValue: widget.question.correctOptionIndex,
                  title: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.question.options[optIndex],
                        onChanged: (v) => widget.question.options[optIndex] = v,
                        decoration: InputDecoration(
                          hintText:
                              "Option ${String.fromCharCode(65 + optIndex)}",
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              widget.question.optionImagePath[optIndex] == ""
                                  ? Icons.add_photo_alternate_outlined
                                  : Icons.image,
                              color:
                                  widget.question.optionImagePath[optIndex] ==
                                      ""
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                            tooltip: "Add Image to Option",
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null) {
                                setState(() {
                                  widget.question.optionImagePath[optIndex] =
                                      result.files.single.path!;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      // B. Image Preview (If selected)
                      if (widget.question.optionImagePath[optIndex] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(
                                    widget.question.optionImagePath[optIndex],
                                  ),
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Image Attached",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                ),
                              ),
                              const Spacer(),
                              // Remove Image Button
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.question.optionImagePath[optIndex] =
                                        "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  onChanged: (val) {
                    setState(() => widget.question.correctOptionIndex = val!);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        widget.question.imagePath = result.files.single.path;
      });
    }
  }

  // Future<void> _optionImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     setState(() {
  //       widget.question.optionImagePath = result.files.single.path;
  //     });
  //   }
  // }
}
