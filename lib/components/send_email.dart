import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<void> sendEmail(BuildContext context) async {
  final Email email = Email(
    body: '',
    subject: '[알투레사장님 문의]',
    recipients: ['info@r2rekorea.com'],
    cc: [],
    bcc: [],
    attachmentPaths: [],
    isHTML: false,
  );
  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const SelectableText(
              "기존 메일 앱에 로그인이 되어있지 않아 이메일 팝업이 취소되었습니다.\n\n아래 이메일로 연락주시면 \n답변드리겠습니다.\n\ninfo@r2rekorea.com",
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            scrollable: true,
            actions: [
              Center(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
