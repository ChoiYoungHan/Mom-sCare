import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/change_user_info.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class change_pw extends StatelessWidget {
  const change_pw({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    print("change_pw 페이지");
    print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangePw(UserNum: userNum, index: index)
    );
  }
}

class ChangePw extends StatefulWidget {
  const ChangePw({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

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
      var jsonData = jsonDecode(response.body);

      print('jsonData'+ jsonData.toString());

      if(jsonData['success'] == false){

        return 0;
      } else {
        return 1;
      }

    } else{
      print('실패');
      return 0;
    }
  }

  Future Epopup(String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Text(message),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("확인", style: TextStyle(color: Colors.black)))
          ],
        );
      }
    );
  }

  Future popup(String messages) async {
    var change_check = await change_password();
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(""),
            content: Text(change_check == 1 ? messages : "현재 비밀번호가 일치하지 않습니다"),
            actions: [
              OutlinedButton(
                onPressed:(){
                  if(change_check==1)
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum, index: widget.index))); // 개인정보 변경 페이지로 이동
                  else
                    Navigator.of(context).pop();
                }, child: Text("확인",style: TextStyle(color: Colors.black))
              )
            ],
          );
        }
    );

  }
  var check = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => change_user_info(userNum: widget.UserNum, index: widget.index)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
            backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
            title: Text('비밀번호 변경', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
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
                  padding: EdgeInsets.fromLTRB(0,40,0,20),
                  child: Text("빈칸에 맞게 비밀번호를 입력해주세요",style: TextStyle(color: Colors.black,fontSize: 20)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text("현재 비밀번호를 입력해주세요",style: TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100,5,100,30),
                  child: TextField(
                    obscureText: true,
                    controller: PW1,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "현재 비밀번호",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text("변경할 비밀번호를 입력해주세요",style: TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100,5,100,30),
                  child: TextField(
                    obscureText: true,
                    controller: PW2,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "변경할 비밀번호",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text("변경할 비밀번호를 다시 입력해주세요",style: TextStyle(color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100,5,100,0),
                  child: TextField(
                    obscureText: true,
                    controller: PW3,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "변경할 비밀번호 재입력",
                        border: OutlineInputBorder(
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
                        onPressed: () {
                          check = 0;
                          if(PW1.text!=""&&PW2.text!=""&&PW3.text!="")
                            check = 1;
                          if(check==1&&PW2.text==PW3.text)
                            check = 2;
                          if(check==2&&PW1.text!=PW2.text)
                            check = 3;
                          if(check == 0)
                            Epopup("빈칸 없이 입력해주세요");
                          else if(check == 1)
                            Epopup("변경할 비밀번호와 재입력한 비밀번호가 일치하지 않습니다");
                          else if(check == 2)
                            Epopup("현재 비밀번호와 변경할 비밀번호를 다르게 입력해주세요");
                          else if(check == 3) {
                            popup("비밀변호 변경이 완료되었습니다.");
                          }
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