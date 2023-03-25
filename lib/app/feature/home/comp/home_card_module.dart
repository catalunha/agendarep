import 'package:flutter/material.dart';

import '../../../core/utils/allowed_access.dart';

class HomeCardModule extends StatelessWidget {
  final List<String> access;
  final Function() onAction;
  final String title;
  final IconData icon;
  final Color color;
  const HomeCardModule({
    Key? key,
    required this.access,
    required this.onAction,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (GetModuleAllowedAccess.consultFor(access)) {
      return InkWell(
        onTap: onAction,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 150,
            height: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            child: Column(children: [
              Icon(
                icon,
                size: 50,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              )
            ]),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
