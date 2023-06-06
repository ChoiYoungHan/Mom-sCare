import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:care_application/change_user_info.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class change_phone extends StatelessWidget {
  const change_phone({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    print("change_phone 페이지");
    print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangePhone(UserNum: userNum, index: index)
    );
  }
}

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {

  TextEditingController PH = TextEditingController(); // 전화번호 입력 컨트롤러

  Future change_ph() async { // 전화번호 변경 DB 연동 함수
    final uri = Uri.parse('http://182.219.226.49/moms/change-phone');
    final header = {'Content-Type': 'application/json'};

    final phone_num = PH.text;
    final userNum = widget.UserNum;

    final body = jsonEncode({'phone': phone_num,'clientNum': userNum});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      print('성공');
      return 1;
    }else{
      return 0;
    }
  }

  Future Epopup(String message, int check) async {
    var change_check;
    if(check == 1)
      change_check = await change_ph();
    print(change_check);
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(""),
            content: Text(message),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    if(change_check==1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>change_user_info(userNum: widget.UserNum, index: widget.index))); // 개인정보 변경 페이지로 이동
                      return;
                    }
                    else if(change_check==0){
                      print("오류");
                      Navigator.of(context).pop();
                      return ;
                    }
                     Navigator.of(context).pop();
                  },
                  child: Text("확인",style: TextStyle(color: Colors.black)))
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum, index: widget.index)));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
            backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
            title: Text('전화번호 변경', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
            leading: IconButton(onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum, index: widget.index))); // 개인정보 변경 페이지로 이동
            }, icon: Icon(Icons.arrow_back, color: Colors.black,),
            )
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0,50,0,0),
                    child: Container(
                        width: 150,
                        child: Image.asset(('assets/phone_number.png'),color: Colors.black)
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,30,0,50),
                  child: Text("변경할 전화번호를 입력해주세요",style: TextStyle(color: Colors.black,fontSize: 20)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100,5,100,30),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11), // 최대 11자리까지 입력 가능
                      PhoneNumberFormatter(), // 핸드폰 번호 포맷터 적용
                    ],
                    controller: PH,
                    textAlign: TextAlign.center, // 오른쪽 정렬
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "전화번호 입력",
                        border: OutlineInputBorder( // 테두리 선
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,40,0,0),
                  child: Container(
                    width: 150,
                    height: 50,
                    child: OutlinedButton(
                        onPressed: (){
                          if(PH.text=="")
                            Epopup("빈칸 없이 입력해주세요", 0);
                          else
                            Epopup("변경 완료하였습니다",1);
                        },child: Text("확인",style: TextStyle(color: Colors.black))
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 핸드폰 번호에 하이픈(-) 추가
    if (newValue.text.isNotEmpty && newValue.text.length > 3) {
      final number = newValue.text.replaceAll(RegExp(r'\D'), '');
      final buffer = StringBuffer();
      buffer.write(number.substring(0, 3));
      if (number.length > 3) {
        buffer.write('-');
        buffer.write(number.substring(3, min(number.length, 7)));
      }
      if (number.length > 7) {
        buffer.write('-');
        buffer.write(number.substring(7, min(number.length, 11)));
      }
      return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.length),
      );
    }
    return newValue;
  }
}