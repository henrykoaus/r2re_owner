import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:r2reowner/screens/auth_screen/components/address_search/document_data.dart';

class PassingData {
  final String address;
  final double x;
  final double y;

  const PassingData(
    this.address,
    this.x,
    this.y,
  );
}

class AddressSearchPage extends StatefulWidget {
  final String? inputAddress;
  final double? inputX;
  final double? inputY;

  const AddressSearchPage({
    super.key,
    this.inputAddress,
    this.inputX,
    this.inputY,
  });

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailsController =
      TextEditingController();
  List<DocumentData> dataList = [];
  String selectedData = '';
  double x = 0.00;
  double y = 0.00;

  Future<void> getJSONData() async {
    final baseUrl =
        'https://dapi.kakao.com/v2/local/search/address.json?query=${_addressController.text}';
    var getResponse = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "KakaoAK 13253d842309aaf2dc74e79b449b1d74",
        "content-type": "application/json;charset=UTF-8",
      },
    );
    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(getResponse.body);
      final List<dynamic> documents = responseData['documents'];
      setState(() {
        dataList =
            documents.map((json) => DocumentData.fromJson(json)).toList();
      });
    } else {
      getResponse.statusCode;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _addressDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            '주소검색 및 입력',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                searchBar(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 500,
                  child: Stack(
                    children: [
                      selectedAddress(),
                      dataList.isNotEmpty
                          ? searchingDataList()
                          : (selectedData != '')
                              ? selectedAddress()
                              : tipSection(),
                    ],
                  ),
                ),
                confirmButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox searchBar() {
    return SizedBox(
      height: 48,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _addressController,
                  onChanged: (value) => getJSONData(),
                  decoration: InputDecoration(
                    hintText: '예) 여의대방로 123, 후평동 456',
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                    suffixIcon: _addressController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _addressController.clear();
                              setState(() {
                                dataList.clear();
                              });
                            },
                          ),
                    suffixIconColor: Colors.grey,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(13)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(13)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  cursorColor: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView tipSection() {
    return ListView(
      children: const [
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Tip',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '아래와 같은 조합으로 검색을 해주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '도로명 + 건물번호',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              '예) 여의대방로 123',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '지역명(동/리) + 번지',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              '예) 후평동 456',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '주소를 선택하신 후 상세 주소를 입력해주세요.',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListView searchingDataList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final DocumentData address = dataList[index];
        final String roadAddress =
            '${address.roadAddress.addressName} ${address.roadAddress.buildingName}';
        final String normalAddress =
            '${address.address.addressName} ${address.roadAddress.buildingName}';
        return ListTile(
          title: (dataList[index].roadAddress.addressName != '' ||
                  dataList[index].roadAddress.addressName.isNotEmpty)
              ? Text(roadAddress)
              : Text(normalAddress),
          subtitle: Text(normalAddress),
          onTap: () {
            setState(() {
              selectedData = (dataList[index].roadAddress.addressName != '' ||
                      dataList[index].roadAddress.addressName.isNotEmpty)
                  ? roadAddress
                  : normalAddress;
              x = double.parse(address.x);
              y = double.parse(address.y);
            });
            _addressController.clear();
            Future.delayed(Duration.zero, () {
              setState(() {
                dataList.clear();
              });
            });
          },
        );
      },
    );
  }

  Visibility selectedAddress() {
    return Visibility(
      visible: dataList.isNotEmpty ? false : true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
        child: Column(
          children: [
            Row(
              children: [
                (selectedData != '')
                    ? const Text(
                        '주소:',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    selectedData,
                    style:
                        const TextStyle(fontSize: 18, color: Colors.deepPurple),
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            (selectedData != '')
                ? Row(
                    children: [
                      const Text(
                        '상세주소:',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _addressDetailsController,
                          minLines: 1,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: '상세주소를 입력해주세요',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Visibility confirmButton(BuildContext context) {
    return Visibility(
      visible: dataList.isNotEmpty ? false : true,
      child: GestureDetector(
        onTap: () {
          final String result =
              '$selectedData ${_addressDetailsController.text}';
          final double xValue = x;
          final double yValue = y;
          Navigator.pop(context, PassingData(result, xValue, yValue));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
