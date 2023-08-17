import 'package:flutter/material.dart';
import 'package:to_do_list_crud/screen/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    super.key,
  });

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  bool isCanAdd = false;
  TextEditingController todoTx = TextEditingController();

  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');

  void _todoAdd() {
    setState(() {
      isCanAdd = false;
    });
    if (todoTx.text.isEmpty) {
      return;
    }

    _products.add({
      'todo': todoTx.text,
      'isDone': false,
      'isSelected': false,
      'date': DateTime.now(),
    });

    todoTx.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (todoTx.text.trim().isEmpty) {
      setState(() {
        isCanAdd = false;
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Something To Do',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Make sure you on the to do list screen',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.7)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            maxLength: 70,
            onChanged: (value) {
              setState(() {
                isCanAdd = true;
              });
            },
            controller: todoTx,
            autofocus: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  todoTx.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 14),
              IconButton(
                onPressed: isCanAdd ? _todoAdd : null,
                icon: isCanAdd
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
