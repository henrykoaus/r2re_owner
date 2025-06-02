import 'package:flutter/material.dart';
import 'package:r2reowner/screens/auth_screen/components/signing_functions.dart';
import 'package:r2reowner/screens/auth_screen/pages/forgot_password.dart';
import 'package:r2reowner/screens/auth_screen/components/text_form_field_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final Uri _url = Uri.parse('https://www.r2rekorea.com/instructions');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: size.width / 7, left: size.width / 7, bottom: 30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 180,
                width: 180,
                child: Wrap(
                  children: [
                    ClipOval(
                        child: Image.asset('assets/icon/launcher_icon.png')),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormFieldModel(
                controller: _emailController,
                obscureText: false,
                hintText: '이메일',
                keyboardType: TextInputType.emailAddress,
                inputFormatters: false,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldModel(
                controller: _pwController,
                obscureText: true,
                hintText: '비밀번호',
                keyboardType: TextInputType.text,
                inputFormatters: false,
              ),
              const SizedBox(
                height: 10,
              ),
              forgottenPw(),
              const SizedBox(
                height: 20,
              ),
              logInButton(context),
              const SizedBox(
                height: 40,
              ),
              const Text(
                '알투레사장님 사용법이 궁금하세요?\n아래 링크로 사용법을 봐주세요',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _launchUrl,
                child: const Text(
                  '알투레사장님 사용법',
                  style: TextStyle(
                      color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row forgottenPw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Colors.pinkAccent,
              textStyle: const TextStyle(
                  fontSize: 17, decoration: TextDecoration.underline)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPassword()),
            );
          },
          child: const Text('비밀번호를 잊어버리셨나요?'),
        ),
      ],
    );
  }

  GestureDetector logInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await signInWithEmail(
            context, _emailController.text, _pwController.text);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
