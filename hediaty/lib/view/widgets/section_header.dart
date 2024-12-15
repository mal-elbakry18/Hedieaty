import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Text(
            'View All',
            style: TextStyle(color: Colors.orange[800]),
          ),
        ),
      ],
    );
  }
}
