import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? userImage;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.onTap,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon(Icons.person),

            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
