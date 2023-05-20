import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure you want to delete this file?"),
      content: Row(
        children: [
          GestureDetector(
            child: const Text("Cancel"),
            onTap: () {},
          ),
          GestureDetector(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {})
        ],
      ),
    );
  }
}
