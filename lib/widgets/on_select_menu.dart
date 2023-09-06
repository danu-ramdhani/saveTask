import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_task/screen/auth.dart';

class OnSelectMenu extends StatelessWidget {
  OnSelectMenu({super.key, required this.firstSelectedOnTab});

  final void Function(bool isFirstSelectedOnTab) firstSelectedOnTab;

  final int batchSize = 50; // Number of documents to delete in each batch

  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');

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
    firstSelectedOnTab(false);

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
    return PopupMenuButton(
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
    );
  }
}
