import 'package:flutter/material.dart';

class Fallback extends StatefulWidget {
  const Fallback({
    super.key,
    required this.image,
    required this.description,
    required this.onResolve,
    required this.buttonLabel,
    required this.buttonIcon,
  });

  final String image;
  final String description;
  final VoidCallback onResolve;
  final String buttonLabel;
  final IconData buttonIcon;

  @override
  State<Fallback> createState() => _FallbackState();
}

class _FallbackState extends State<Fallback> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            widget.image,
            fit: BoxFit.contain,
            height: 200,
            width: 200,
          ),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 50,
            width: 200,
            child: FilledButton.icon(
              onPressed: widget.onResolve,
              label: Text(widget.buttonLabel, style: TextStyle(fontSize: 16)),
              icon: Icon(widget.buttonIcon, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
