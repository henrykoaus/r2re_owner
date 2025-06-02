import 'package:flutter/material.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/screens/auth_screen/components/text_form_field_model.dart';
import 'package:r2reowner/screens/auth_screen/components/signing_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cpwController = TextEditingController();

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
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          right: size.width / 7, left: size.width / 7, bottom: 30),
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
              TextFormFieldModel(
                controller: _cpwController,
                obscureText: true,
                hintText: '비밀번호 확인',
                keyboardType: TextInputType.text,
                inputFormatters: false,
              ),
              const SizedBox(
                height: 20,
              ),
              signUpButton(context),
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

  GestureDetector signUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final isValid = _formKey.currentState!.validate();
        if (!isValid) return;
        if (_emailController.text.isEmpty) {
          generalDialog(context, "이메일주소를 입력해주세요.");
          return;
        } else if (!_emailController.text.contains("@") ||
            _emailController.text.length < 5) {
          generalDialog(context, "이메일을 확인해주세요.");
          return;
        } else if (_pwController.text != _cpwController.text) {
          generalDialog(context, "비밀번호가 일치하지 않습니다.");
          return;
        } else if (_pwController.text.length < 8) {
          generalDialog(context, "비밀번호는 8자리 이상이어야 합니다.");
          return;
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                '알투레사장님 로그인 정보 제공 동의',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              surfaceTintColor: Colors.white,
              content: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '회원가입/입점신청을 위해 아래 내용에 동의해주세요.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '알투레코리아에서 회원님의 개인정보에 접근합니다. 제공된 개인정보(이용자 식별자 기본제공, 그 외 제공 항목이 있을 경우 아래 별도 기재)는 이용자 식별, 통계, 계정 연동 및 CS, 정산 등을 위해 서비스 이용기간 동안 활용/보관 됩니다. 본 제공 동의를 거부할 권리가 있으나, 동의를 거부하실 경우 서비스 이용이 제한될 수 있습니다.',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '필수 제공 항목 (필수)',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text('이메일 주소, 사용자 이름, 계좌번호, 상호명, 주소'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signUpWithEmail(
                        context, _emailController.text, _pwController.text);
                  },
                  style: TextButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    '동의 및 가입',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '회원가입',
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
