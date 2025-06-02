import 'package:flutter/material.dart';
import 'package:r2reowner/screens/auth_screen/components/signing_functions.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                '비밀번호 초기화하기',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const Text(
                      '비밀번호 초기화를 위해 \n 이메일을 입력해주세요.',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          emailTextFormField(),
                          const SizedBox(
                            height: 40,
                          ),
                          resetButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.black38,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: '이메일',
        prefixIcon: const Icon(Icons.email),
        prefixIconColor: Colors.purple,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _emailController.clear();
          },
        ),
        suffixIconColor: Colors.grey,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
    );
  }

  ElevatedButton resetButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () async {
        await resetPassword(context, _emailController.text);
      },
      icon: const Icon(
        Icons.lock_reset,
        size: 24,
        color: Colors.white,
      ),
      label: const Text(
        '비밀번호 초기화',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
