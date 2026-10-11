import 'dart:ui';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key, required this.text});

  final String text;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                constraints: BoxConstraints(
                  minWidth: 100,
                  minHeight: 100,
                  maxHeight: 100,
                  maxWidth: 100,
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 12.0,
                    valueColor: AlwaysStoppedAnimation(Colors.purple),
                    backgroundColor: Colors.grey[300],
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              Image.asset(
                'lib/assets/images/andal_logo_circular.png',
                width: 50,
                height: 50,
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

void showBlurredLoader(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(50),
    builder: (BuildContext context) => PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Loader(text: text),
        ),
      ),
    ),
  );
}
