import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/screen/auth.dart';

import 'package:save_task/screen/todolist_screen.dart';
import 'package:save_task/screen/done_screen.dart';
import 'package:save_task/widgets/add_todo.dart';
import 'package:save_task/widgets/menu.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');
  int _selectedPageTitle = 0;
  final int batchSize = 50; // Number of documents to delete in each batch
  bool isFirstSelectedOnTab = false;

  void _selectPage(int index) {
    setState(() {
      _selectedPageTitle = index;
    });
  }

  void openPageAdd() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _selectedPageTitle = 0;
      });
    });

    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(10),
          right: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const Wrap(
            children: [
              AddTodoScreen(),
            ],
          ),
        );
      },
    );
  }

  void _selectAll() async {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    QuerySnapshot querySnapshot = await _products.get();

    List<Future<void>> updateTasks = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      updateTasks.add(docSnapshot.reference.update({'isSelected': true}));
    }

    await Future.wait(updateTasks);
  }

  void _deleteAll() async {
    setState(() {
      isFirstSelectedOnTab = false;
    });

    Query query = _products.where('isSelected', isEqualTo: true);

    QuerySnapshot querySnapshot = await query.get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    int totalDocuments = documents.length;
    int processedDocuments = 0;

    while (processedDocuments < totalDocuments) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (int i = 0;
          i < batchSize && processedDocuments < totalDocuments;
          i++) {
        batch.delete(documents[processedDocuments].reference);
        processedDocuments++;
      }

      await batch.commit();
    }
  }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = 'TO DO LIST';

    if (_selectedPageTitle == 1) {
      setState(() {
        activePageTitle = 'DONE LIST';
      });
    }

    return DefaultTabController(
      initialIndex: _selectedPageTitle,
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            isFirstSelectedOnTab
                ? PopupMenuButton(
                    surfaceTintColor: Theme.of(context).colorScheme.background,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: _selectAll,
                          child: const Text('Select all'),
                        ),
                        PopupMenuItem(
                          onTap: _deleteAll,
                          child: const Text('Delete'),
                        )
                      ];
                    },
                  )
                : const Menu(),
          ],
          titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(),
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          title: isFirstSelectedOnTab
              ? IconButton(
                  visualDensity: const VisualDensity(horizontal: -4),
                  alignment: const Alignment(-4, 0),
                  onPressed: () {
                    setState(() {
                      isFirstSelectedOnTab = false;
                    });

                    _products.get().then((querySnapshot) {
                      // ignore: avoid_function_literals_in_foreach_calls
                      querySnapshot.docs.forEach((doc) async {
                        await doc.reference.update({'isSelected': false});
                      });
                    });
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowLeftLong,
                    size: 18,
                  ),
                )
              : Text(activePageTitle),
          forceMaterialTransparency: true,
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TodolistScreen(
              isSelectedMethod: () {
                setState(() {
                  isFirstSelectedOnTab = true;
                });
                // tambah metode agar bisa langsung check ketika longpress
              },
              isFirstSelected: isFirstSelectedOnTab,
            ),
            const DoneScreen(),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 5,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: isFirstSelectedOnTab ? null : () => openPageAdd(),
            tooltip: 'Add What To Do',
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            child: const FaIcon(FontAwesomeIcons.plus),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.infinite,
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              splashFactory: NoSplash.splashFactory,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              // indicatorColor: Colors.white,
              onTap: _selectPage,
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
        ),
      ),
    );
  }
}
