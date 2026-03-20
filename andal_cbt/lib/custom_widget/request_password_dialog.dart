import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestPasswordDialog extends StatefulWidget {
  const RequestPasswordDialog({
    super.key,
    required this.controller,
    required this.image,
    required this.title,
    required this.content,
    required this.onAuthenticate,
    required this.onCancel,
  });

  final String image;
  final String title;
  final String content;
  final VoidCallback onAuthenticate;
  final TextEditingController controller;
  final VoidCallback onCancel;

  @override
  State<RequestPasswordDialog> createState() => _RequestPasswordDialog();
}

class _RequestPasswordDialog extends State<RequestPasswordDialog> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(32),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. The Image (Time Up Representation)
          Image.asset(
            widget.image,
            height: 250,
            width: 250,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 24),

          // 2. The Text
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 133, 47, 113),
            ),
          ),
          SizedBox(height: 3.0),

          Text(
            widget.content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 12),

          TextFormField(
            controller: widget.controller,
            autofocus: true,
            obscureText: hidden,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: "Passcode",
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                // onPressed: widget.suffixAction,
                onPressed: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
                // icon: widget.suffixIcon,
                icon: FaIcon(
                  hidden ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                ),
                iconSize: 22.0,
              ),
            ),
            validator: (v) => v!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: 2.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Forgot Password? Contact Your Administrator",
              style: TextStyle(
                color: Color.fromARGB(255, 26, 61, 46),
                fontSize: 12.0,
              ),
            ),
          ),
          SizedBox(height: 40),

          // 3. The Button to Proceed
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 133, 47, 113),
                    Color.fromARGB(255, 0, 87, 38),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: widget.onAuthenticate,
                child: Text(
                  'AUTHENTICATE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: widget.onCancel,
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 61, 46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
