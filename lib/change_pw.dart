import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/change_user_info.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class change_pw extends StatelessWidget {
  const change_pw({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    print("change_pw 페이지");
    print(userNum);
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

  Future change_password() async{ //비밀번호 인증+변경
    final uri = Uri.parse('http://182.219.226.49/moms/change-pw/pw/afterlogin'); // 링크 받아와야함
    final headers = {'Content-Type': 'application/json'};

    final user_num = widget.UserNum; // 유저번호
    final pw_now = PW1.text;
    final pw_change = PW2.text;

    final body = jsonEncode({'clientNum': user_num,'pw': pw_now, 'changepw': pw_change}); // 입력값 받아와야함
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum,))); // 개인정보 변경 페이지로 이동
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
                      obscureText: true,
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
                      obscureText: true,
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
                      obscureText: true,
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
                child: PW2.text==PW3.text?
                OutlinedButton(
                  onPressed: () async {
                    await change_password()==1?
                    showDialog(
                        context: context,
                        barrierColor: Colors.grey.withOpacity(0.6),
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text(''),
                            content: Text('삭제가 완료되었습니다'),
                            actions: [
                              OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => edit(userNum: widget.UserNum,)));
                                },child: Text('확인',style: TextStyle(color: Colors.black),),
                              )
                            ],
                          );
                        }
                    )
                        :
                    showDialog(
                        context: context,
                        barrierColor: Colors.grey.withOpacity(0.6),
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text(''),
                            content: Text('서버 통신 오류'),
                            actions: [
                              OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },child: Text('확인',style: TextStyle(color: Colors.black),),
                              )
                            ],
                          );
                        }
                    );
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum))); // 개인정보 변경 페이지로 이동
                  },child: Text('확인',style: TextStyle(color: Colors.black, fontSize: 25),),
                )
                    :
                OutlinedButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        barrierColor: Colors.grey.withOpacity(0.6),
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text(''),
                            content: Text('변경할 비밀번호가 일치하지 않습니다'),
                            actions: [
                              OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },child: Text('확인',style: TextStyle(color: Colors.black),),
                              )
                            ],
                          );
                        }
                    );
                  },child: Text('확인',style: TextStyle(color: Colors.black, fontSize: 25),),
                )
                ,
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