import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/change_pw_certification.dart';
import 'package:care_application/change_user_info.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class change_pw extends StatelessWidget {
  const change_pw({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangePw(UserNum: userNum)
    );
  }
}

class ChangePw extends StatefulWidget {
  const ChangePw({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<ChangePw> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {

  TextEditingController PW1 = TextEditingController(); // 비밀번호 입력 컨트롤러
  TextEditingController PW2 = TextEditingController();
  TextEditingController PW3 = TextEditingController();
  var Pw1; // 비밀번호
  var Pw2;
  var Pw3;

  Future change_password() async{
    final uri = Uri.parse('http://182.219.226.49/'); // 링크 받아와야함
    final headers = {'Content-Type': 'application/json'};

    final user_num = widget.UserNum; // 유저번호

    final body = jsonEncode({'clientNum': '64'}); // 입력값 받아와야함
    final response = await http.post(uri, headers: headers, body: body);
    if(response.statusCode == 200){
      print('성공');
      return 1;
    } else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
        title: Text('비밀번호 변경', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
        leading: IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => change_pw_certification(userNum: widget.UserNum,))); // 개인정보 변경 페이지로 이동
        }, icon: Icon(Icons.arrow_back, color: Colors.black,),
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 2,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text('현재 비밀번호', style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.left, ),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(100,0,100,0),
                    child: TextField(
                      controller: PW1,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                       border: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.black)
                       )
                      ),
                    ),
                  ),
                )
              ],
            ),
          flex: 3,),
          Expanded(
            child: Container(),flex: 2,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('비밀번호 입력', style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.left, ),
                    )
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(100,0,100,0),
                    child: TextField(
                      controller: PW2,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),
          flex: 3,),
          Expanded(
            child: Container(),flex: 2,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('비밀번호 재입력', style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.left, ),
                    )
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(100,0,100,0),
                    child: TextField(
                      controller: PW3,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),
          flex: 3,),
          Expanded(
            child: Container(),flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.width*0.1, // 위젯의 높이를 화면 너비*0.1로 설정
                width: MediaQuery.of(context).size.width*0.4,
                child: OutlinedButton(
                  onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum))); // 개인정보 변경 페이지로 이동
                  },child: Text('확인',style: TextStyle(color: Colors.black, fontSize: 25),),
                ),
              ),
            ),
          flex: 2,),
          Expanded(
            child: Container(),flex: 4,
          )
        ],
      ),
    );
  }
}
