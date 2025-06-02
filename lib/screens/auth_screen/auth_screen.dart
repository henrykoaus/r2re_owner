import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/screens/auth_screen/pages/directing_screen.dart';
import 'package:r2reowner/screens/auth_screen/components/fade_stack.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int selectedForm = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const DirectingScreen();
        } else {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Material(
              child: SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            FadeStack(
                              selectedForm: selectedForm,
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 60,
                              child: Container(
                                color: Colors.grey[200],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: (selectedForm == 0)
                                            ? '계정이 없으신가요?'
                                            : '이미 계정이 있으신가요?',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (selectedForm == 0) {
                                            selectedForm = 1;
                                          } else {
                                            selectedForm = 0;
                                          }
                                        });
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text: (selectedForm == 0)
                                              ? '회원가입'
                                              : '로그인',
                                          style: const TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
