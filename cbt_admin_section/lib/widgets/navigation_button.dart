import 'package:flutter/material.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.header,
    required this.description,
    required this.image,
    required this.actionDesc,
    required this.onClicked,
    required this.buttonClicked,
  });

  final String header;
  final String description;
  final String image;
  final String actionDesc;
  final GestureTapCallback onClicked;
  final VoidCallback buttonClicked;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClicked,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xff1a1a1a).withAlpha(190),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.header, // .toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              Image.asset(
                widget.image,
                fit: BoxFit.cover,
                width: 250,
                height: 250,
              ),
              Divider(thickness: 1.0, indent: 8.0, endIndent: 8.0),
              SizedBox(height: 5.0),
              Text(
                widget.actionDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 7.0),
              IconButton.filled(
                onPressed: widget.buttonClicked,
                color: Theme.of(context).colorScheme.primary,
                splashColor: Colors.white,
                icon: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                iconSize: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
