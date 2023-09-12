import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:save_task/show_modal_bottom_sheet/edit_todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.documentSnapshotTitle,
    required this.title,
  });

  final DocumentSnapshot documentSnapshotTitle;
  final CollectionReference title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  void _showPageEdit(
      String titleId, String todoId, DocumentSnapshot documentSnapshot) {
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
                titleId: titleId,
                todoId: todoId,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteDatabase(String titleId, String todoId) async {
    await widget.title
        .doc(titleId)
        .collection('todo-list')
        .doc(todoId)
        .delete();
  }

  void _deletePermanent(
      String titleId, String todoId, DocumentSnapshot documentSnapshot) {
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
              _deleteDatabase(titleId, todoId);
            },
          ),
        ),
      );
    });
  }

  Future<void> _done(
      String titleId, String todoId, DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot['isDone'] == false) {
      await widget.title
          .doc(titleId)
          .collection('todo-list')
          .doc(todoId)
          .update({
        'isDone': true,
      });
    }

    if (documentSnapshot['isDone'] == true) {
      await widget.title
          .doc(titleId)
          .collection('todo-list')
          .doc(todoId)
          .update({
        'isDone': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.title
          .doc(widget.documentSnapshotTitle.id)
          .collection('todo-list')
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        if (snapshot.data!.docs.isEmpty) {
          return const ListTile(
            title: Text('Try add todo list'),
          );
        } else {
          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshotTodo =
                    snapshot.data!.docs[index];

                TextDecoration textdec = TextDecoration.none;
                Color colorText = Theme.of(context).colorScheme.onBackground;

                if (documentSnapshotTodo['isDone'] == true) {
                  textdec = TextDecoration.lineThrough;
                  colorText = Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7);
                }

                Widget? dateWidget;

                if ((documentSnapshotTodo.data() as Map<String, dynamic>)
                    .containsKey('todoDate')) {
                  dateWidget = Text(DateFormat.yMMMEd().format(
                      (documentSnapshotTodo['todoDate'] as Timestamp)
                          .toDate()));
                }

                return Column(
                  children: [
                    ListTile(
                      onTap: () => _showPageEdit(
                          widget.documentSnapshotTitle.id,
                          documentSnapshotTodo.id,
                          documentSnapshotTodo),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -2),
                      horizontalTitleGap: 8,
                      title: Text(
                        documentSnapshotTodo['todo'],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              decoration: textdec,
                              height: 1.3,
                              color: colorText,
                            ),
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      subtitle: dateWidget,
                      leading: IconButton(
                        visualDensity: const VisualDensity(horizontal: -4),
                        onPressed: () => _done(widget.documentSnapshotTitle.id,
                            documentSnapshotTodo.id, documentSnapshotTodo),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          key: ValueKey(documentSnapshotTodo['isDone']),
                          child: documentSnapshotTodo['isDone']
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
                          widget.documentSnapshotTitle.id,
                          documentSnapshotTodo.id,
                          documentSnapshotTodo,
                        ),
                        icon: const FaIcon(FontAwesomeIcons.minus),
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
