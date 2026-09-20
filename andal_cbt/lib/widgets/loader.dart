import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            constraints: BoxConstraints(
              minWidth: 150,
              minHeight: 150,
              maxHeight: 150,
              maxWidth: 150,
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: CircularProgressIndicator(
                strokeWidth: 17.0,
                valueColor: AlwaysStoppedAnimation(
                  Color.fromARGB(255, 133, 47, 113),
                ),
                backgroundColor: Colors.grey[300],
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Image.asset(
            'lib/assets/andal_logo_circular.png',
            width: 85,
            height: 85,
          ),
        ],
      ),
    );
  }
}
