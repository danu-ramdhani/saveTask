import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:to_do_list_crud/screen/tab.dart';
import 'package:to_do_list_crud/screen/auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool canResendEmail = false;
  bool isEmailVerified = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = firebase.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerification();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        firebase.currentUser!.reload();
        setState(() {
          isEmailVerified = firebase.currentUser!.emailVerified;
        });
      });

      if (isEmailVerified) {
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerification() async {
    try {
      await firebase.currentUser!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const TabScreen()
        : Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A verification email has been send to your email.',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'If you dont get an email, cancel and make sure put your exist and right email!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: canResendEmail ? sendVerification : null,
                        icon: const Icon(Icons.email),
                        label: const Text('Resent Email'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(firebase.currentUser!.uid)
                              .delete();
                          firebase.currentUser!.delete();
                          FirebaseAuth.instance.signOut();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
