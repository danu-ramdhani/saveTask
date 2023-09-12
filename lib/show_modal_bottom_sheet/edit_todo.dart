import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:save_task/screen/auth.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({
    super.key,
    required this.documentSnapshot,
    required this.todoId,
    required this.titleId,
  });

  final String todoId;
  final String titleId;
  final DocumentSnapshot documentSnapshot;

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  String textEdit = '';
  bool isCanEdit = false;
  DateTime? selectedDate;

  Future<void> editTodo() async {
    final CollectionReference todo = FirebaseFirestore.instance
        .collection('users')
        .doc(firebase.currentUser!.uid)
        .collection('todo-title')
        .doc(widget.titleId)
        .collection('todo-list');

    Navigator.of(context).pop();
    if (selectedDate == null) {
      await todo.doc(widget.todoId).update({
        'todo': textEdit,
      });
    } else {
      await todo.doc(widget.todoId).update({
        'todo': widget.documentSnapshot['todo'] + textEdit,
        'todoDate': selectedDate,
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
        isCanEdit = true;
        selectedDate = value;
      });
    });
  }

  Future<void> deleteField() async {
    try {
      Navigator.of(context).pop();
      final documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(firebase.currentUser!.uid)
          .collection('todo-title')
          .doc(widget.titleId)
          .collection('todo-list')
          .doc(widget.todoId);
      final Map<String, dynamic> updatedData = {
        'todoDate': FieldValue.delete()
      };
      await documentReference.update(updatedData);
      // print('Field "$fieldName" has been deleted from the document.');
    } catch (e) {
      print('Error deleting field: $e');
    }
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
                'Edit Your TodoList',
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
            initialValue: widget.documentSnapshot['todo'],
            maxLength: 70,
            onChanged: (value) {
              setState(() {
                isCanEdit = true;
                textEdit = value.trim();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (widget.documentSnapshot.data() as Map<String, dynamic>)
                      .containsKey('todoDate')
                  ? TextButton.icon(
                      onPressed: deleteField,
                      icon: const FaIcon(FontAwesomeIcons.x, size: 14),
                      label: Text(selectedDate == null
                          ? DateFormat.yMMMEd().format(
                              (widget.documentSnapshot['todoDate'] as Timestamp)
                                  .toDate())
                          : DateFormat.yMMMEd().format(selectedDate!)),
                    )
                  : Text(selectedDate == null
                      ? 'No selected date'
                      : DateFormat.yMMMEd().format(selectedDate!)),
              IconButton(
                onPressed: _openPickDate,
                icon: const FaIcon(FontAwesomeIcons.calendar),
              ),
              const SizedBox(width: 14),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: isCanEdit ? editTodo : null,
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
