import 'dart:convert';
import 'package:care_application/edit.dart';
import 'package:care_application/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class delete_user extends StatelessWidget {
  const delete_user({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    print("delete_user 페이지");
    print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DeleteUser(UserNum: userNum)
    );
  }
}

class DeleteUser extends StatefulWidget {
  const DeleteUser({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {

  TextEditingController password = TextEditingController(); // 비밀번호 입력 변수

  Future delete_User() async{
    final uri = Uri.parse('http://182.219.226.49/moms/register/delete');
    final header = {'Content-Type': 'application/json'};

    final client_num = widget.UserNum; // 아기번호 값도 받아와야함
    final pw = password.text;
    print('회원삭제 시 clientNum은' + client_num);
    print('회원삭제 시 비밀번호는' + pw);
    final body = jsonEncode({'clientNum': client_num, 'pw': pw});
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
        backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
        title: Text('회원 탈퇴', style: TextStyle(color: Colors.black)), // 상단 바 글자색을 검정색으로 설정
        leading: IconButton(onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => edit(userNum: widget.UserNum,))); // 마이페이지로 이동
        }, icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 4, // 상단 여백 4부여
          ),
          Expanded(
            child: Text('비밀번호 입력',style: TextStyle(color: Colors.black),)
            ,flex: 2,), // 여백 2 부여
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: TextField(
                controller: password,
                maxLines: 1, // 한줄만 입력받도록 설정
                textAlign: TextAlign.left, // 좌측 정렬
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    hintText: ('비밀번호를 입력하세요')
                ),
              ),
            ),
            flex: 2,), // 여백 2부여
          Expanded(
            child: Container(), flex: 1, // 여백 1 부여
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: (){
                showDialog(
                    context: context,
                    barrierColor: Colors.grey.withOpacity(0.6),
                    builder: (BuildContext context){
                      print(password.text);
                      return password.text==''?
                      AlertDialog(
                        title: Text(''),
                        content: Text('비밀번호를 입력하세요',textAlign: TextAlign.center,),
                        actions: [
                          OutlinedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }
                              , child: Text('확인',style: TextStyle(color: Colors.black),))
                        ],
                      )
                          :
                      AlertDialog(
                        title: Text(''),
                        content: Text('삭제 후 복구 불가능합니다.\n 삭제하시겠습니까?',style: TextStyle(color: Colors.black),),
                        actions: [
                          OutlinedButton(
                            onPressed: (){
                              Navigator.of(context).pop(); // 팝업 닫기
                            }, child: Text('아니오',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                          ),
                          OutlinedButton(
                            onPressed: () async{
                              await delete_User()==1? // 삭제 요청 성공 여부 판별
                              showDialog(
                                  context: context,
                                  barrierColor: Colors.grey.withOpacity(0.6),
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text(''),
                                      content: Text('유저 정보가 삭제되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login_Page())); // 마이페이지로 이동
                                            },child: Text('확인',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,)
                                        )
                                      ],
                                    );
                                  }
                              ):
                              showDialog(
                                  context: context,
                                  barrierColor: Colors.grey.withOpacity(0.6),
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text(''),
                                      content: Text('비밀번호가 일치하지 않습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },child: Text('확인',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,)
                                        )
                                      ],
                                    );
                                  }
                              );
                            }, child: Text('네',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                          )
                        ],
                      );
                    }
                );
              },
              child: Text('확인',style: TextStyle(color: Colors.black),),
            ),
          ),
          Expanded(child: Container(),flex: 5,)
        ],
      ),
    );
  }
}