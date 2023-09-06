import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:save_task/screen/auth.dart';

class CancelButton extends StatelessWidget {
  CancelButton({super.key, required this.firstSelectedOnTab});

  final void Function(bool isFirstSelectedOnTab) firstSelectedOnTab;

  final CollectionReference _products = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('todo-list');

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      alignment: const Alignment(-4, 0),
      onPressed: () {
        firstSelectedOnTab(false);

        _products.get().then((querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            await doc.reference.update({'isSelected': false});
          });
        });
      },
      icon: const FaIcon(
        FontAwesomeIcons.arrowLeftLong,
        size: 18,
      ),
    );
  }
}
