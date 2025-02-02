import 'package:bank_app/Screens/soon_screen.dart';
import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  final String name;
  final Icon icon;

  const Service({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SoonScreen(),
              ),
            );
          },
          child: CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            radius: 28,
            child: icon,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          width: 75,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.fade,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
