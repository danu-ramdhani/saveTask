import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/screen/auth.dart';

import 'package:save_task/widgets/edit_todo.dart';
import 'package:save_task/widgets/no_data_content.dart';

class TodolistScreen extends StatefulWidget {
  const TodolistScreen({
    super.key,
    required this.isFirstSelected,
    required this.isSelectedMethod,
  });

  final bool isFirstSelected;
  final void Function() isSelectedMethod;

  @override
  State<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');
  final CollectionReference _productsDone = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('done-list');
  bool onProgres = false;

  void _openPageEdit(String productId, DocumentSnapshot documentSnapshot) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              EditTodoScreen(
                documentSnapshot: documentSnapshot,
                productId: productId,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteDatabase(String productId) async {
    await _products.doc(productId).delete();
  }

  void _deletePermanent(String productId, DocumentSnapshot documentSnapshot) {
    setState(() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          content: Text(documentSnapshot['todo']),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Delete',
            textColor: Colors.redAccent,
            onPressed: () {
              _deleteDatabase(productId);
            },
          ),
        ),
      );
    });
  }

  void _done(String productId, DocumentSnapshot documentSnapshot) {
    setState(() {
      onProgres = true;
    });
    _productsDone.add({
      'doneList': documentSnapshot['todo'],
      'isDone': true,
      'isSelected': false,
      'date': DateTime.now(),
    });

    _products.doc(productId).update({'isDone': true});

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
          content: Text('\'${documentSnapshot['todo']}\' is done'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: StreamBuilder(
        stream: _products.orderBy('date').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return NoDataContent(
              image: Image.asset(
                'assets/images/todo.png',
                height: 250,
                width: 250,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              firstText: 'Your Todo is empty',
              secondText: 'Try add by prees plus button below',
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
                        onLongPress: widget.isSelectedMethod,
                        onTap: widget.isFirstSelected
                            ? null
                            : () => _openPageEdit(
                                documentSnapshot.id, documentSnapshot),
                        contentPadding: const EdgeInsets.all(0),
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -2),
                        horizontalTitleGap: 8,
                        title: Text(
                          documentSnapshot['todo'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                height: 1.3,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                        leading: IconButton(
                          visualDensity: const VisualDensity(horizontal: -4),
                          onPressed: widget.isFirstSelected || onProgres
                              ? null
                              : () =>
                                  _done(documentSnapshot.id, documentSnapshot),
                          iconSize: 24,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            key: ValueKey(documentSnapshot['isDone']),
                            child: documentSnapshot['isDone']
                                ? FaIcon(
                                    FontAwesomeIcons.solidCircleCheck,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                        trailing: widget.isFirstSelected
                            ? Checkbox(
                                value: documentSnapshot['isSelected'],
                                onChanged: (value) {
                                  setState(() {
                                    _products.doc(documentSnapshot.id).update({
                                      'isSelected': value,
                                    });
                                  });
                                },
                              )
                            : IconButton(
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
      ),
    );
  }
}
