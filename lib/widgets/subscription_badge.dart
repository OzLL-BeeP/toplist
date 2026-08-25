import 'package:flutter/material.dart';

// Renders a small badge (PRO / PREM / ADMIN) next to a username.
// Takes the badge label directly — callers must source it from
// UserModel.badge (server-derived), never from raw text input.
class SubscriptionBadge extends StatelessWidget {
  final String? label;

  const SubscriptionBadge({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();

    Color bgColor;
    Color textColor;

    switch (label) {
      case 'PRO':
        bgColor = const Color(0xFFC0C0C0); // silver
        textColor = const Color(0xFF2a2a2a);
        break;
      case 'PREM':
        bgColor = const Color(0xFFFFC107); // gold
        textColor = const Color(0xFF2a2a2a);
        break;
      case 'ADMIN':
        bgColor = const Color(0xFFff5722);
        textColor = Colors.white;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label!,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// Convenience widget: username + badge inline, used in comments and feeds.
class UsernameWithBadge extends StatelessWidget {
  final String username;
  final String? badge;
  final TextStyle? style;

  const UsernameWithBadge({
    Key? key,
    required this.username,
    required this.badge,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(username, style: style),
        SubscriptionBadge(label: badge),
      ],
    );
  }
}
