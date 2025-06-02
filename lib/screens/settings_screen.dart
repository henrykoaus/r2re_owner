import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/components/send_email.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _feedbackEditor = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  final Uri _url =
      Uri.parse('https://www.r2rekorea.com/r2reowner-privacy-policy');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final Uri _instructionUrl =
      Uri.parse('https://www.r2rekorea.com/instructions');

  Future<void> _launchInstructionsUrl() async {
    if (!await launchUrl(_instructionUrl)) {
      throw Exception('Could not launch $_instructionUrl');
    }
  }

  Future requestAccountDeletion() async {
    await FirebaseFirestore.instance
        .collection('restaurantData')
        .doc(currentUser!.uid)
        .update({"accountDeletionRequested": true});
  }

  @override
  void dispose() {
    _feedbackEditor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '세팅',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            instructions(),
            customerService(context),
            giveFeedback(),
            accountDeletionRequest(context),
            termsOfService(),
            signOut(),
          ],
        ),
      ),
    );
  }

  ListTile instructions() {
    return ListTile(
      leading: const Icon(
        Icons.library_books,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '알투레사장님 사용법',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: _launchInstructionsUrl,
    );
  }

  ListTile customerService(BuildContext context) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.bubble_left_bubble_right_fill,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '문의하기',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: () {
        sendEmail(context);
      },
    );
  }

  ListTile giveFeedback() {
    final CollectionReference<Map<String, dynamic>> feedbackOwnerCollection =
        FirebaseFirestore.instance.collection('ownersFeedback');
    return ListTile(
      leading: const Icon(
        Icons.feedback_rounded,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '피드백 주기',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: AlertDialog(
                title: const Text(
                  '피드백 작성하기',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                scrollable: true,
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white60),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextFormField(
                                controller: _feedbackEditor,
                                minLines: 40,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    hintText: '피드백을 작성해주세요'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (_feedbackEditor.text.isNotEmpty) {
                                dialogIndicator(context);
                                Map<String, dynamic> feedbackData = {
                                  'feedback': _feedbackEditor.text,
                                  'uid': currentUser!.uid,
                                  'email': currentUser!.email,
                                  'displayName': currentUser!.displayName ?? '',
                                };
                                await feedbackOwnerCollection.add(feedbackData);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    if (context.mounted) {
                                      generalDialog(context,
                                          '피드백이 전송되었습니다.\n\n 더 나은 서비스로 개선하겠습니다.');
                                    }
                                  }
                                }
                              } else {
                                generalDialog(context, '피드백을 작성해주세요.');
                              }
                              _feedbackEditor.clear();
                            },
                            style: TextButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text(
                              '확인',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              _feedbackEditor.clear();
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text(
                              '취소',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListTile accountDeletionRequest(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.manage_accounts,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '퇴점/계정삭제 요청',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            title: const Text(
              '\n퇴점 요청시 판매와 거래내역 등\n확인 시간이 요청됩니다.\n퇴점 절차를 위해 본사에서\n연락을 드립니다.\n \n퇴점 요청을 하시겠습니까?\n',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            scrollable: true,
            actions: [
              Center(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () async {
                        dialogIndicator(context);
                        await requestAccountDeletion();
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (context.mounted) {
                            Navigator.pop(context);
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  title: const Text(
                                    '퇴점이 요청되었습니다.\n빠른 시일 내에 퇴점절차를 위해\n연락을 드리겠습니다.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  scrollable: true,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        elevation: 3,
                                        backgroundColor: Colors.purple,
                                      ),
                                      child: const Text(
                                        '확인',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text(
                        '퇴점요청',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile termsOfService() {
    return ListTile(
      leading: const Icon(
        Icons.policy,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '약관 및 정책',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: _launchUrl,
    );
  }

  ListTile signOut() {
    return ListTile(
      leading: const Icon(
        Icons.exit_to_app,
        color: Colors.deepPurple,
        size: 22,
      ),
      title: const Text(
        '로그아웃',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
      },
    );
  }
}
