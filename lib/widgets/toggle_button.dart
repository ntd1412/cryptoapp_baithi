
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final String name;
  const ToggleButton({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 38) / 4,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(name),
      ),
    );
  }
}
