import 'package:flutter/material.dart';

import 'package:save_task/screen/todolist_screen.dart';
import 'package:save_task/widgets/bottom_nav_bar.dart';
import 'package:save_task/widgets/floating_add_button.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(),
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('TO DO LIST'),
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        // forceMaterialTransparency: true,
      ),
      body: const TodolistScreen(),
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
