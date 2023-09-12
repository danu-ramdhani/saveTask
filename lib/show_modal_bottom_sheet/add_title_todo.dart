import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:save_task/screen/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTitleTodo extends StatefulWidget {
  const AddTitleTodo({
    super.key,
  });

  @override
  State<AddTitleTodo> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTitleTodo> {
  bool isCanAdd = false;
  TextEditingController todoTx = TextEditingController();
  TextEditingController titleTx = TextEditingController();
  DateTime? selectedDate;

  final CollectionReference _title = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-title');

  Future<void> _addTitleTodo() async {
    setState(() {
      isCanAdd = false;
    });
    if (todoTx.text.isEmpty || titleTx.text.isEmpty) {
      return;
    }

    Navigator.pop(context);

    final todo = await _title.add({
      'title': titleTx.text,
      'isDone': false,
      'isSelected': false,
      'date': Timestamp.now(),
    });
    if (selectedDate == null) {
      _title.doc(todo.id).collection('todo-list').add({
        'todo': todoTx.text,
        'isDone': false,
        'isSelected': false,
        'date': Timestamp.now(),
      });
    } else {
      _title.doc(todo.id).collection('todo-list').add({
        'todo': todoTx.text,
        'isDone': false,
        'isSelected': false,
        'todoDate': selectedDate,
        'date': Timestamp.now(),
      });
    }

    titleTx.clear();
    todoTx.clear();
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
  void dispose() {
    todoTx.dispose();
    titleTx.dispose();
    super.dispose();
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
                'Add Title and ToDo',
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
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: titleTx,
            maxLength: 20,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              counterText: '',
              border: OutlineInputBorder(borderSide: BorderSide.none),
              alignLabelWithHint: true,
              labelText: 'Title...',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(
                fontSize: 24,
              ),
            ),
            style: const TextStyle(fontSize: 24),
          ),
          TextFormField(
            controller: todoTx,
            maxLength: 70,
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
            // autofocus: true,
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
                onPressed: isCanAdd ? _addTitleTodo : null,
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
