import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_list_crud/screen/auth.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({
    super.key,
  });

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');
  final CollectionReference _productsDone = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('done-list');
  bool onProgres = false;

  Future<void> _deleteDatabase(String productId) async {
    await _productsDone.doc(productId).delete();
  }

  void _deletePermanent(String productId, DocumentSnapshot documentSnapshot) {
    _deleteDatabase(documentSnapshot.id);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        content: Text('\'${documentSnapshot['doneList']}\' is deleted'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _undone(String productId, DocumentSnapshot documentSnapshot) {
    setState(() {
      onProgres = true;
    });

    _products.add({
      'todo': documentSnapshot['doneList'],
      'isDone': false,
      'isSelected': false,
      'date': DateTime.now(),
    });

    _productsDone.doc(productId).update({'isDone': false});

    Timer(const Duration(milliseconds: 200), () {
      _deleteDatabase(productId);
      setState(() {
        onProgres = false;
      });
    });

    setState(() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          content: Text(
              '\'${documentSnapshot['doneList']}\' is replace to todo list'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _productsDone.orderBy('date').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/done.png',
                  height: 260,
                  width: 260,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                Text(
                  'You dont have todo list done',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your todo list and prees check button',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                      ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -2),
                      horizontalTitleGap: 8,
                      title: Text(
                        documentSnapshot['doneList'],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              height: 1.3,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      leading: IconButton(
                        visualDensity: const VisualDensity(horizontal: -4),
                        onPressed: onProgres == true
                            ? null
                            : () =>
                                _undone(documentSnapshot.id, documentSnapshot),
                        iconSize: 24,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          key: ValueKey(documentSnapshot['isDone']),
                          child: documentSnapshot['isDone']
                              ? FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : FaIcon(
                                  FontAwesomeIcons.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                                ),
                        ),
                      ),
                      trailing: IconButton(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                        iconSize: 16,
                        onPressed: () => _deletePermanent(
                          documentSnapshot.id,
                          documentSnapshot,
                        ),
                        icon: const FaIcon(FontAwesomeIcons.minus),
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
