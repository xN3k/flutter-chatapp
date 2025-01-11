// import 'package:flutter/material.dart';

// class UserTile extends StatelessWidget {
//   final String text;
//   final String? userImage;
//   final void Function()? onTap;

//   const UserTile({
//     super.key,
//     required this.text,
//     this.onTap,
//     required this.userImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.secondary,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           children: [
//             // Icon(Icons.person),
//             CircleAvatar(
//               backgroundImage: userImage!,
//             ),
//             Text(
//               text,
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? userImage; // URL of the user's image
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
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25, // Adjust size as needed
              backgroundColor: Colors.grey[300], // Fallback background color
              backgroundImage: userImage != null
                  ? NetworkImage(userImage!) // Load image from the URL
                  : null, // No image
              child: userImage == null
                  ? Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[600], // Icon color
                    )
                  : null, // Show icon if no image
            ),
            const SizedBox(width: 10), // Add space between avatar and text
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
