import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:save_task/screen/auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure want to delete your account?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebase.currentUser!.uid)
                    .delete();

                QuerySnapshot todoSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebase.currentUser!.uid)
                    .collection('todo-list')
                    .get();

                QuerySnapshot doneSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebase.currentUser!.uid)
                    .collection('done-list')
                    .get();

                for (QueryDocumentSnapshot postSnapshot in todoSnapshot.docs) {
                  await postSnapshot.reference.delete();
                }

                for (QueryDocumentSnapshot postSnapshot in doneSnapshot.docs) {
                  await postSnapshot.reference.delete();
                }

                await firebase.currentUser!.delete();
              } catch (e) {
                // print("Error deleting user");
              }

              GoogleSignIn().signOut();
              firebase.signOut();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out from this account'),
        content: const Text('Are you sure want to Log out?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              firebase.signOut();
              GoogleSignIn().signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                firebase.currentUser!.photoURL.toString(),
              ),
            ),
            title: Text(firebase.currentUser!.email.toString()),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Can not edit user image right now'),
                ),
              );
            },
            trailing: CircleAvatar(
              backgroundColor: Colors.grey,
              maxRadius: 18,
              backgroundImage: NetworkImage(
                firebase.currentUser!.photoURL.toString(),
              ),
            ),
            title: const Text('User image'),
            subtitle: const Text('Change your user image'),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Can not edit email right now'),
                ),
              );
            },
            title: const Text('Email'),
            subtitle: Text(firebase.currentUser!.email.toString()),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Can not edit password right now'),
                ),
              );
            },
            title: const Text('Password'),
            subtitle: const Text('Change your password'),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: _showLogOutDialog,
            title: const Text('Log out'),
            leading: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 20,
            ),
          ),
          ListTile(
            onTap: _showDeleteDialog,
            leading: const FaIcon(
              FontAwesomeIcons.userXmark,
              size: 20,
            ),
            title: const Text(
              'Delete account',
            ),
            subtitle: const Text(
              'Begin Permanent Account Deletion: All Data Will Be Lost Permanently',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
