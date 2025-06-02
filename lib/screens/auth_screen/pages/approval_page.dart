import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/screens/auth_screen/components/amendments_in_approval_page/address_amendment.dart';
import 'package:r2reowner/screens/auth_screen/components/amendments_in_approval_page/bank_details_amendment.dart';
import 'package:r2reowner/screens/auth_screen/components/amendments_in_approval_page/drop_down_amendment.dart';
import 'package:r2reowner/screens/auth_screen/components/amendments_in_approval_page/input_text_amendment.dart';
import 'package:r2reowner/state_management/entry_input_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({Key? key}) : super(key: key);

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool? isApproved;
  String selectedRegion = '지역 선택';
  String selectedCategory = '카테고리 선택';
  String selectedBank = '은행 선택';

  List<String> regionItems = [
    '지역 선택',
    '서울',
    '경기/인천',
    '강원',
    '충북',
    '충남/대전',
    '경북/대구',
    '전북',
    '경남/부산',
    '전남/광주',
    '제주',
  ];

  List<String> categoryItems = [
    '카테고리 선택',
    '카페/브런치',
    '고기/구이',
    '피자/햄버거',
    '회/초밥',
    '한식',
    '중식',
    '일식',
    '양식',
    '분식',
    '아시안',
    '다양한 음식',
  ];

  List<String> bankItems = [
    '은행 선택',
    '신한',
    '국민',
    '농협',
    '수협',
    '신협',
    '하나',
    '기업',
    '산업',
    '카카오뱅크',
    '토스뱅크',
    '우체국',
    '우리',
    '한국씨티',
    '케이뱅크',
    '경남',
    '대구',
    '전북',
    '제주',
    '광주',
    '부산',
    '새마을',
    '저축은행',
    '지역농.축협',
    '도이치',
    '중국건설',
    '중국공상',
    'BNP파리바',
    'BOA',
    'HSBC',
    'JP모간',
    'SC',
    '산립조합',
    '국세',
    '지방세',
    '국고금',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _snsUrlController = TextEditingController();

  final Uri _url =
      Uri.parse('https://www.youtube.com/channel/UCYf2RjJttFVFjzZXhqYzOkQ');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    checkApproval();
  }

  Future<void> checkApproval() async {
    final docRef = FirebaseFirestore.instance
        .collection("restaurantData")
        .doc(currentUser!.uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        isApproved = data["isApproved"];
      });
      if (isApproved == true) {
        redirectToRestaurantInfoPage();
      }
    }
  }

  void redirectToRestaurantInfoPage() {
    GoRouter.of(context).go('/feed/restaurant_info');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _registrationController.dispose();
    _telephoneController.dispose();
    _bankAccountController.dispose();
    _snsUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryInputProvider = Provider.of<EntryInputProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                '알투레코리아가 입점 요청을 확인중입니다.',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                '입력된 가게정보',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputTextAmendment(
                        unique: currentUser!.uid,
                        title: '가게이름',
                        actionTitle: 'name',
                        subTitle: entryInputProvider.name ?? '',
                        textEditingController: _nameController,
                        inputFormatters: false,
                        keyboardType: TextInputType.text,
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                        color: Colors.purple,
                      ),
                      DropDownAmendment(
                        unique: currentUser!.uid,
                        title: '카테고리',
                        actionTitle: 'category',
                        subTitle: entryInputProvider.category ?? '',
                        dropdownValue: selectedCategory,
                        items: categoryItems,
                        onChanged: (String? selectedValue) {
                          setState(
                            () {
                              selectedCategory = selectedValue!;
                            },
                          );
                        },
                        onPressed: () async {
                          if (selectedCategory != '카테고리 선택') {
                            dialogIndicator(context);
                            final docRef = FirebaseFirestore.instance
                                .collection("restaurantData")
                                .doc(currentUser!.uid);
                            await docRef.update({'category': selectedCategory});
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          } else {
                            generalDialog(context, '카테고리를 선택해주세요.');
                          }
                        },
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                      ),
                      InputTextAmendment(
                        unique: currentUser!.uid,
                        title: '대표자이름',
                        actionTitle: 'ownerName',
                        subTitle: entryInputProvider.ownerName ?? '',
                        textEditingController: _ownerNameController,
                        inputFormatters: false,
                        keyboardType: TextInputType.text,
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                        color: Colors.purple,
                      ),
                      DropDownAmendment(
                        unique: currentUser!.uid,
                        title: '지역',
                        actionTitle: 'region',
                        subTitle: entryInputProvider.region ?? '',
                        dropdownValue: selectedRegion,
                        items: regionItems,
                        onChanged: (String? selectedValue) {
                          setState(
                            () {
                              selectedRegion = selectedValue!;
                            },
                          );
                        },
                        onPressed: () async {
                          if (selectedRegion != '지역 선택') {
                            dialogIndicator(context);
                            final docRef = FirebaseFirestore.instance
                                .collection("restaurantData")
                                .doc(currentUser!.uid);
                            await docRef.update({'region': selectedRegion});
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          } else {
                            generalDialog(context, '지역을 선택해주세요.');
                          }
                        },
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                      ),
                      AddressAmendment(
                          title: '주소',
                          subTitle: entryInputProvider.address ?? ''),
                      InputTextAmendment(
                        unique: currentUser!.uid,
                        title: '전화번호',
                        actionTitle: 'telephone',
                        subTitle: entryInputProvider.telephone ?? '',
                        textEditingController: _telephoneController,
                        inputFormatters: true,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                        color: Colors.purple,
                      ),
                      InputTextAmendment(
                        unique: currentUser!.uid,
                        title: '사업자번호',
                        actionTitle: 'registration',
                        subTitle: entryInputProvider.registration ?? '',
                        textEditingController: _registrationController,
                        inputFormatters: true,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                        color: Colors.purple,
                      ),
                      BankDetailsAmendment(
                        bankTitle: (entryInputProvider.bankDetails != null)
                            ? entryInputProvider.bankDetails!["bank"]
                            : '',
                        bankAccount: (entryInputProvider.bankDetails != null)
                            ? entryInputProvider.bankDetails!["bankAccount"]
                            : '',
                        dropdownValue: selectedBank,
                        items: bankItems,
                        onChanged: (String? selectedValue) {
                          setState(
                            () {
                              selectedBank = selectedValue!;
                            },
                          );
                        },
                        onPressed: () async {
                          if (selectedBank != '은행 선택' &&
                              _bankAccountController.text.isNotEmpty) {
                            dialogIndicator(context);
                            final docRef = FirebaseFirestore.instance
                                .collection("restaurantData")
                                .doc(currentUser!.uid);
                            await docRef.update({
                              'bankDetails': {
                                "bank": selectedBank,
                                "bankAccount": _bankAccountController.text,
                              }
                            });
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          } else if (selectedBank == '은행 선택') {
                            generalDialog(context, '은행을 선택해주세요.');
                          } else if (_bankAccountController.text.isEmpty ||
                              _bankAccountController.text.length <= 5) {
                            generalDialog(context, '정확한 계좌번호를 입력해주세요.');
                          }
                          _bankAccountController.clear();
                        },
                        textEditingController: _bankAccountController,
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                      ),
                      InputTextAmendment(
                        unique: currentUser!.uid,
                        title: 'SNS게시url',
                        actionTitle: 'snsUrl',
                        subTitle: entryInputProvider.snsUrl ??
                            'sns 게시물이 확인되지 않았습니다.\n아래 링크에서 알투레코리아 동영상 중 하나의 url 링크를 회원님이 게시할 홍보물에 태그해주세요',
                        textEditingController: _snsUrlController,
                        inputFormatters: false,
                        keyboardType: TextInputType.text,
                        fetchFunction: () {
                          return entryInputProvider
                              .fetchEntryInputData(currentUser!.uid);
                        },
                        color: Colors.pinkAccent,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _launchUrl,
                        child: const Text(
                          '알투레코리아 유튜브',
                          style: TextStyle(color: Colors.pinkAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
