import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_list_crud/screen/account.dart';
import 'package:to_do_list_crud/screen/setting.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _openAcountScreen() {
    Timer(const Duration(milliseconds: 150), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const AccountScreen();
        },
      ));
    });
  }

  void _openSettingScreen() {
    Timer(const Duration(milliseconds: 150), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const SettingScreen();
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      surfaceTintColor: Theme.of(context).colorScheme.background,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: _openAcountScreen,
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              leading: const FaIcon(
                FontAwesomeIcons.user,
                size: 20,
              ),
              title: Text(
                'Acount',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
          PopupMenuItem(
            onTap: _openSettingScreen,
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              leading: const FaIcon(
                FontAwesomeIcons.gear,
                size: 20,
              ),
              title: Text(
                'Setting',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
