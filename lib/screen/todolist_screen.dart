import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:save_task/screen/auth.dart';
import 'package:save_task/widgets/no_data_content.dart';
import 'package:save_task/widgets/todo_list.dart';
import 'package:save_task/widgets/todo_title.dart';

class TodolistScreen extends StatefulWidget {
  const TodolistScreen({
    super.key,
  });

  @override
  State<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  final CollectionReference _title = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-title');

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: _title.orderBy('date').snapshots(),
      builder: (context, snapshot) {
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
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              height: screenHeight * 0.8,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshotTitle =
                      snapshot.data!.docs[index];
                  return Column(
                    children: [
                      TodoTitle(documentSnapshotTitle: documentSnapshotTitle),
                      TodoList(
                        documentSnapshotTitle: documentSnapshotTitle,
                        title: _title,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
