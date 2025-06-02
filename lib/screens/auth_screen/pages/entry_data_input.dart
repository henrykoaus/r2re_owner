import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/screens/auth_screen/components/address_search/address_search_page.dart';
import 'package:r2reowner/screens/auth_screen/components/drop_down_model.dart';
import 'package:r2reowner/screens/auth_screen/components/signing_functions.dart';
import 'package:r2reowner/screens/auth_screen/components/text_form_field_row.dart';
import 'package:url_launcher/url_launcher.dart';

class EntryDataInput extends StatefulWidget {
  const EntryDataInput({super.key});

  @override
  State<EntryDataInput> createState() => _EntryDataInputState();
}

class _EntryDataInputState extends State<EntryDataInput> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? name;
  String? ownerName;
  String? registration;
  String? telephone;
  String? address;
  double? x;
  double? y;
  GeoPoint? geoPoint;
  String? region;
  String? category;
  Map<String, dynamic>? bankDetails;
  String selectedRegion = '지역 선택';
  String selectedCategory = '카테고리 선택';
  String selectedBank = '은행 선택';

  //String? snsUrl;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
    checkInputData();
  }

  Future<void> checkInputData() async {
    final docRef = FirebaseFirestore.instance
        .collection("restaurantData")
        .doc(currentUser!.uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        ownerName = data["ownerName"];
        registration = data["registration"];
        telephone = data["telephone"];
        address = data["address"];
        geoPoint = data["geo"];
        region = data["region"];
        category = data["category"];
        bankDetails = data["bankDetails"];
      });
      if (name != '' &&
          ownerName != '' &&
          registration != '' &&
          telephone != '' &&
          address != '' &&
          region != '' &&
          category != '' &&
          bankDetails!["bank"] != '' &&
          bankDetails!["bankAccount"] != '') {
        redirectToApprovalPage();
      }
    }
  }

  void redirectToApprovalPage() {
    GoRouter.of(context).go('/auth/approval');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _registrationController.dispose();
    _telephoneController.dispose();
    _addressController.dispose();
    _bankAccountController.dispose();
    _snsUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '입점신청',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                            child:
                                Image.asset('assets/icon/launcher_icon.png')),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormFieldRow(
                    title: '가게이름:',
                    controller: _nameController,
                    obscureText: false,
                    hintText: '가게이름',
                    keyboardType: TextInputType.text,
                    inputFormatters: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropDownModel(
                    title: '카테고리:',
                    dropdownValue: selectedCategory,
                    items: categoryItems,
                    onChanged: (String? selectedValue) {
                      setState(
                        () {
                          selectedCategory = selectedValue!;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropDownModel(
                    title: '지역:',
                    dropdownValue: selectedRegion,
                    items: regionItems,
                    onChanged: (String? selectedValue) {
                      setState(
                        () {
                          selectedRegion = selectedValue!;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  addressSection(context),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldRow(
                    title: '대표자이름:',
                    controller: _ownerNameController,
                    obscureText: false,
                    hintText: '대표자이름',
                    keyboardType: TextInputType.text,
                    inputFormatters: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldRow(
                    title: '전화번호:',
                    controller: _telephoneController,
                    obscureText: false,
                    hintText: '전화번호',
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldRow(
                    title: '사업자번호:',
                    controller: _registrationController,
                    obscureText: false,
                    hintText: '사업자번호',
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropDownModel(
                    title: '정산계좌:',
                    dropdownValue: selectedBank,
                    items: bankItems,
                    onChanged: (String? selectedValue) {
                      setState(
                        () {
                          selectedBank = selectedValue!;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldRow(
                    title: '',
                    controller: _bankAccountController,
                    obscureText: false,
                    hintText: '계좌번호',
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '*회원님의 SNS에 알투레 홍보를 부탁드려요*',
                    style: TextStyle(color: Colors.pinkAccent),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    '아래 링크에서 알투레코리아 홍보영상을\n회원님 SNS에 공유해주세요',
                    style: TextStyle(color: Colors.pinkAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: _launchUrl,
                    child: const Text(
                      '알투레코리아 유튜브',
                      style: TextStyle(color: Colors.purple),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //    const SizedBox(
                  //      height: 20,
                  //    ),
                  //    TextFormFieldRow(
                  //      title: 'SNS게시url:',
                  //      controller: _snsUrlController,
                  //      obscureText: false,
                  //      hintText: '회원님이 올린 SNS 게시 url',
                  //      keyboardType: TextInputType.text,
                  //      inputFormatters: false,
                  //    ),
                  const SizedBox(
                    height: 50,
                  ),
                  inputCompleteButton(context),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox addressSection(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          const SizedBox(
              width: 120,
              child: Text(
                "주소:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<PassingData>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressSearchPage(
                      inputAddress: address,
                      inputX: x,
                      inputY: y,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    address = result.address;
                    x = result.x;
                    y = result.y;
                    geoPoint = GeoPoint(result.y, result.x);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                surfaceTintColor: Colors.grey[100],
                elevation: 0,
                fixedSize: const Size(50, 55),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: (address != null && address != '')
                        ? AutoSizeText(
                            address!,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            minFontSize: 10,
                            maxFontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        : const Text(
                            '주소검색',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                  ),
                  const SizedBox(
                    width: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector inputCompleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final isValid = _formKey.currentState!.validate();
        if (!isValid) return;
        if (_nameController.text.isEmpty ||
            _ownerNameController.text.isEmpty ||
            _registrationController.text.isEmpty ||
            _telephoneController.text.isEmpty ||
            _bankAccountController.text.isEmpty) {
          generalDialog(context, "모든 항목이 입력되지 않았습니다.\n \n각 항목들을 모두 입력해주세요.");
          return;
        }
        if (_nameController.text.isEmpty) {
          generalDialog(context, "정확한 가게 이름을 입력해주세요.");
          return;
        } else if (_ownerNameController.text.length <= 1) {
          generalDialog(context, "정확한 대표자 성함을 입력해주세요.");
          return;
        } else if (_registrationController.text.length <= 5) {
          generalDialog(context, "정확한 사업자번호를 입력해주세요.");
          return;
        } else if (_telephoneController.text.length <= 4) {
          generalDialog(context, "정확한 전화번호를 입력해주세요.");
          return;
        } else if (address == null) {
          generalDialog(context, "주소를 입력해주세요.");
          return;
        } else if (selectedRegion == '지역 선택') {
          generalDialog(context, "지역을 선택해주세요.");
          return;
        } else if (selectedCategory == '카테고리 선택') {
          generalDialog(context, "카테고리를 선택해주세요.");
          return;
        } else if (selectedBank == '은행 선택') {
          generalDialog(context, "은행을 선택해주세요.");
          return;
        } else if (_bankAccountController.text.length <= 5) {
          generalDialog(context, "정확한 계좌번호를 입력해주세요.");
          return;
        }
        await inputData(
          context,
          currentUser!.uid,
          _nameController.text,
          _ownerNameController.text,
          _registrationController.text,
          _telephoneController.text,
          selectedRegion,
          address!,
          geoPoint!,
          selectedCategory,
          selectedBank,
          _bankAccountController.text,
          _snsUrlController.text,
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
            '입점신청',
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
