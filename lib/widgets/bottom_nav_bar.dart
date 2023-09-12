import 'package:flutter/material.dart';
import 'package:save_task/widgets/menu.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      height: 56,
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Center(
        child: Row(
          children: [
            Menu(),
          ],
        ),
      ),
    );
  }
}
