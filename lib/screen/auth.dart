import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:save_task/widgets/form_user.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon.png',
                        height: 48,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SaveTask',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/auth.png',
                      color: Theme.of(context).colorScheme.onBackground,
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FormUser(
                      isLoadingChange: (isLoading) {
                        setState(() {
                          _isLoading = isLoading;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
