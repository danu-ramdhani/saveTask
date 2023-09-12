import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:save_task/screen/auth.dart';

class AddTodoInTitle extends StatefulWidget {
  const AddTodoInTitle({super.key, required this.todoId});

  final String todoId;

  @override
  State<AddTodoInTitle> createState() => _AddTodoInTitleState();
}

class _AddTodoInTitleState extends State<AddTodoInTitle> {
  TextEditingController todoTx = TextEditingController();
  bool isCanAdd = false;
  DateTime? selectedDate;

  Future<void> addTodoInTitle() async {
    final CollectionReference todo = FirebaseFirestore.instance
        .collection('users')
        .doc(firebase.currentUser!.uid)
        .collection('todo-title')
        .doc(widget.todoId)
        .collection('todo-list');

    setState(() {
      isCanAdd = false;
    });
    Navigator.of(context).pop();

    if (selectedDate == null) {
      todo.add({
        'todo': todoTx.text,
        'isDone': false,
        'isSelected': false,
        'date': Timestamp.now(),
      });
    } else {
      todo.add({
        'todo': todoTx.text,
        'isDone': false,
        'isSelected': false,
        'todoDate': selectedDate,
        'date': Timestamp.now(),
      });
    }
  }

  void _openPickDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now().subtract(const Duration(days: -1000)),
    ).then((value) {
      setState(() {
        selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Something ToDo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              ),
            ],
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: Icon(
                FontAwesomeIcons.circle,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
              counterText: '',
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              alignLabelWithHint: true,
              labelText: 'todo',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: const TextStyle(
                fontSize: 17,
              ),
            ),
            style: const TextStyle(fontSize: 17),
            maxLength: 70,
            onChanged: (value) {
              setState(() {
                isCanAdd = true;
              });
              if (value.trim().isEmpty) {
                setState(() {
                  isCanAdd = false;
                });
              }
            },
            controller: todoTx,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(selectedDate == null
                  ? 'No selected date'
                  : DateFormat.yMMMEd().format(selectedDate!)),
              IconButton(
                onPressed: _openPickDate,
                icon: const FaIcon(FontAwesomeIcons.calendar),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: isCanAdd ? addTodoInTitle : null,
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
