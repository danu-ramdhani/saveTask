import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/show_modal_bottom_sheet/add_title_todo.dart';

class FloatingAddButton extends StatefulWidget {
  const FloatingAddButton({super.key});

  @override
  State<FloatingAddButton> createState() => _FloatingAddButtonState();
}

class _FloatingAddButtonState extends State<FloatingAddButton> {
  void openPageAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(10),
          right: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const Wrap(
            children: [
              AddTitleTodo(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: openPageAdd,
      tooltip: 'Add What To Do',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      child: const FaIcon(FontAwesomeIcons.plus),
    );
  }
}
