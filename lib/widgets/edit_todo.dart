import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_task/screen/auth.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({
    super.key,
    required this.documentSnapshot,
    required this.productId,
  });

  final String productId;
  final DocumentSnapshot documentSnapshot;

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');
  String textEdit = '';
  bool isCanEdit = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Your TodoList',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: widget.documentSnapshot['todo'],
            maxLength: 70,
            onChanged: (value) {
              setState(() {
                isCanEdit = true;
              });
              textEdit = value.trim();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 14),
              IconButton(
                onPressed: isCanEdit
                    ? () async {
                        Navigator.of(context).pop();
                        await _products.doc(widget.productId).update({
                          'todo': textEdit,
                        });
                      }
                    : null,
                icon: isCanEdit
                    ? CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.5),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
