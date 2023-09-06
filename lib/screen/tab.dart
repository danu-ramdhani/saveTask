import 'package:flutter/material.dart';

import 'package:save_task/screen/todolist_screen.dart';
import 'package:save_task/screen/done_screen.dart';
import 'package:save_task/widgets/bottom_nav_bar.dart';
import 'package:save_task/widgets/cancel_button.dart';
import 'package:save_task/widgets/floating_add_button.dart';
import 'package:save_task/widgets/menu.dart';
import 'package:save_task/widgets/on_select_menu.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  bool _isFirstSelectedOnTab = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            _isFirstSelectedOnTab
                ? OnSelectMenu(
                    firstSelectedOnTab: (isFirstSelectedOnTab) {
                      setState(() {
                        _isFirstSelectedOnTab = isFirstSelectedOnTab;
                      });
                    },
                  )
                : const Menu(),
          ],
          titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(),
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          title: _isFirstSelectedOnTab
              ? CancelButton(
                  firstSelectedOnTab: (isFirstSelectedOnTab) {
                    setState(() {
                      _isFirstSelectedOnTab = isFirstSelectedOnTab;
                    });
                  },
                )
              : const Text('TO DO LIST'),
          forceMaterialTransparency: true,
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TodolistScreen(
              isSelectedMethod: () {
                setState(() {
                  _isFirstSelectedOnTab = true;
                });
                // tambah metode agar bisa langsung check ketika longpress
              },
              isFirstSelected: _isFirstSelectedOnTab,
            ),
            const DoneScreen(),
          ],
        ),
        floatingActionButton:
            FloatingAddButton(isFirstSelectedOnTab: _isFirstSelectedOnTab),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
