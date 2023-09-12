import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/show_modal_bottom_sheet/add_todo_in_tttle.dart';
import 'package:save_task/show_modal_bottom_sheet/edit_title.dart';

class TodoTitle extends StatefulWidget {
  const TodoTitle({super.key, required this.documentSnapshotTitle});

  final DocumentSnapshot documentSnapshotTitle;

  @override
  State<TodoTitle> createState() => _TodoTitleState();
}

class _TodoTitleState extends State<TodoTitle> {
  void showTitleEdit(String titleId, DocumentSnapshot documentSnapshot) {
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
              EditTitle(
                documentSnapshot: documentSnapshot,
                titleId: titleId,
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddTodoInTitle(String titleId) {
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
              AddTodoInTitle(todoId: titleId),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showTitleEdit(
          widget.documentSnapshotTitle.id, widget.documentSnapshotTitle),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
        ),
      ),
      tileColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
      contentPadding: const EdgeInsets.only(left: 12),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
      title: Text(
        widget.documentSnapshotTitle['title'],
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 18,
            ),
      ),
      trailing: IconButton(
        onPressed: () => showAddTodoInTitle(widget.documentSnapshotTitle.id),
        icon: const FaIcon(
          FontAwesomeIcons.plus,
          size: 16,
        ),
      ),
    );
  }
}
