import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_application/change_user_info.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class change_phone extends StatelessWidget {
  const change_phone({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangePhone(UserNum: userNum)
    );
  }
}

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('전화번호 변경', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum,))); // 개인정보 변경 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 4, // 상단 여백 4 부여
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,65,0,0), // 텍스트의 상단 여백 65 부여
                child: Text('전화번호 입력', style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.left, ),
              ),
            flex: 2,), // 영역비율 2 부여
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(100,0,100,0), //텍스트 필드의 상하 여백 100 부여
              child: TextField(
                controller: PH,
                textAlign: TextAlign.right, // 오른쪽 정렬
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: OutlineInputBorder( // 테두리 선
                        borderSide: BorderSide(color: Colors.black)
                    )
                ),
              ),
            ),
            flex: 2,), // 영역 비율 2 부여
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 40), // 위젯의 상하 여백 40 부여
              child: Container(
                height: MediaQuery.of(context).size.width*0.1, // 위젯의 높이를 화면 너비*0.1로 설정
                width: MediaQuery.of(context).size.width*0.4, // 위젯의 너비를 화면 너비*0.4로 설정
                child: OutlinedButton(
                  onPressed: () async {
                    await change_ph()==1? // 전화번호 변경 성공 시
                    showDialog( // 팝업 위젯
                        context: context,
                        barrierColor: Colors.grey.withOpacity(0.6),
                        builder: (BuildContext context){
                          return  AlertDialog(
                            title: Text(''), // 상단 여백
                            content: Text('핸드폰 번호가 변경되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                            actions: [
                              OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop(); // 팝업 닫기
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum,))); // 마이페이지로 이동
                                }, child: Text('확인', style: TextStyle(color: Colors.black),),
                              )
                            ],
                          );
                        }
                    ): // 전화번호 변경 실패 시
                    showDialog( // 팝업 위젯
                        context: context,
                        barrierColor: Colors.grey.withOpacity(0.6),
                        builder: (BuildContext context){
                          return  AlertDialog(
                            title: Text(''), // 상단 여백
                            content: Text('오류 발생',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                            actions: [
                              OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop(); // 팝업 닫기
                                }, child: Text('확인', style: TextStyle(color: Colors.black),),
                              )
                            ],
                          );
                        }
                    );
                  },child: Text('확인', style: TextStyle(color: Colors.black,),),
                ),
              ),
            ),
            flex: 3,), // 영역 비율 3 부여
          Expanded(
            child: Container(),flex: 4, // 하단 여백 4 부여
          ),
        ],
      ),
    );
  }
}
