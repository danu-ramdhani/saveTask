import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.infinite,
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: TabBar(
          splashFactory: NoSplash.splashFactory,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.9),
          tabs: const [
            Tab(
              icon: FaIcon(FontAwesomeIcons.clipboardList),
              height: 54,
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.solidCircleCheck),
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
