import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/screen/auth.dart';

class EditTitle extends StatefulWidget {
  const EditTitle(
      {super.key, required this.titleId, required this.documentSnapshot});

  final String titleId;
  final DocumentSnapshot documentSnapshot;

  @override
  State<EditTitle> createState() => _AddEditTitleState();
}

class _AddEditTitleState extends State<EditTitle> {
  bool isCanAdd = false;
  String titleEdit = '';

  final CollectionReference _title = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-title');

  Future<void> _todoAddEdit() async {
    setState(() {
      isCanAdd = false;
    });
    Navigator.of(context).pop();

    await _title.doc(widget.titleId).update({
      'title': titleEdit,
    });
  }

  Future<void> deleteTitle() async {
    Navigator.of(context).pop();

    await _title.doc(widget.titleId).delete();

    final todoSnapshot =
        await _title.doc(widget.titleId).collection('todo-list').get();

    for (QueryDocumentSnapshot postSnapshot in todoSnapshot.docs) {
      await postSnapshot.reference.delete();
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
                'Edit Your Title',
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
          TextFormField(
            autofocus: true,
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
            initialValue: widget.documentSnapshot['title'],
            maxLength: 20,
            onChanged: (value) {
              setState(() {
                isCanAdd = true;
              });
              if (value.trim().isEmpty) {
                setState(() {
                  isCanAdd = false;
                });
              }
              titleEdit = value.trim();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                label: const Text('Delete'),
                onPressed: deleteTitle,
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 18),
              ),
              IconButton(
                onPressed: isCanAdd ? _todoAddEdit : null,
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
