import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TextEditingController host = TextEditingController();

  @override
  Widget build(BuildContext context) {
    host.text = '5432';

    return Dialog(
      constraints: BoxConstraints(maxWidth: 350, maxHeight: 580),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/server_settings_ico.png',
              height: 250,
              width: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 14),
            Text(
              'Server Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 47, 113),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Server IP Address',
                hintText: 'eg. 127.0.0.1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: host,
              decoration: InputDecoration(
                enabled: false,
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelText: 'Port',
                labelStyle: TextStyle().copyWith(
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 40.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 133, 47, 113),
                      Color.fromARGB(255, 0, 87, 38),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40.0,
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
      ),
    );
  }
}
