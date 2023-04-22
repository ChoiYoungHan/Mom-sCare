import 'dart:convert';

import 'package:care_application/find_PW.dart';
import 'package:care_application/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Find_ID extends StatelessWidget {
  const Find_ID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본 제거
        home: FindID()
    );
  }
}

class FindID extends StatefulWidget {
  const FindID({Key? key}) : super(key: key);

  @override
  State<FindID> createState() => _FindIDState();
}

class _FindIDState extends State<FindID> {

  // 회원정보를 입력할 때 사용할 텍스트 필드
  TextEditingController inputName = new TextEditingController();
  TextEditingController inputPhone = new TextEditingController();
  TextEditingController inputEmail = new TextEditingController();
  TextEditingController inputEmailCheck = new TextEditingController();

  bool _emailAuth = true, _findIDBtn = false, _Field = true, _checkField = true;

  Future Popup(BuildContext context, String msg){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: Container(
                  height: 25,
                  child: Center(child: FittedBox(child: Text(msg, style: TextStyle(color: Colors.grey, fontSize: 17))))
              ),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))
                    )
                )
              ]
          );
        }
    );
  }

  Future<void> sendEmail() async {
    final uri = Uri.parse('http://182.219.226.49/moms/find-id');
    final headers = {'Content-Type' : 'application/json'};

    final Name = inputName.text;
    final Phone = inputPhone.text;
    final Email = inputEmail.text;

    final body = jsonEncode({'name': Name, 'phone': Phone, 'email': Email});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      if(jsonData['success'] == true){
        setState(() {
          _emailAuth = false;
        });
      } else {
        Popup(context, '일치하는 회원정보가 없습니다.');
      }

    } else {

    }
  }

  Future<void> sendCheck() async {
    final uri = Uri.parse('http://182.219.226.49/moms/sendemail/auth');
    final headers = {'Content-Type' : 'application/json'};

    final Email = inputEmail.text;
    final checknum = inputEmailCheck.text;

    final body = jsonEncode({'email': Email, 'auth': checknum});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      if(jsonData['success'] == true) {
        setState(() {
          _checkField = false;
          _findIDBtn = true;
          _Field = false;
        });
      } else {
        Popup(context, '인증번호가 일치하지 않습니다.');
        inputEmailCheck.clear();
      }
    } else {

    }
  }

  Future<void> findID() async {
    final uri = Uri.parse('http://182.219.226.49/moms/find-id/id');
    final headers = {'Content-Type' : 'application/json'};

    final Email = inputEmail.text;

    final body = jsonEncode({'email': Email});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      if(jsonData['success'] == true){

        Popup(context, '아이디는 ' + utf8.decode(jsonData['id'].runes.toList()) + '입니다.');

      } else {
        Popup(context, '서버와의 연결에 끊어졌습니다.');
      }

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 상 중 하를 나누는 위젯
        resizeToAvoidBottomInset: false, // 채팅바가 올라올 때 페이지가 밀리는 것을 방지
        appBar: AppBar( // 상단 바
            backgroundColor: Colors.white, // 배경색은 흰색
            leading: IconButton( // 아이콘 버튼 위젯
                onPressed: (){ // 뒤로가기 버튼 클릭 시 동작할 코드 작성
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login_Page()));
                },
                icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 아이콘, 색상은 회색
            ),
            title: Row( // 가로 정렬
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정한 간격을 두고 정렬
                children: [
                  TextButton( // 텍스트 버튼 위젯
                      onPressed: (){ // 아이디 찾기 버튼 클릭 시 수행할 코드 작성 ( 기본 페이지이므로 작성 안함 )

                      },
                      child: Text('아이디 찾기', // 텍스트 위젯, '아이디 찾기' 문구 출력
                          style: TextStyle( // 텍스트 디자인 설정
                              color: Colors.blue, // 색상은 파랑
                              fontWeight: FontWeight.bold, // 볼드체
                              fontSize: 16 // 크기는 16
                          )
                      )
                  ),
                  TextButton( // 텍스트 버튼 위젯
                      onPressed: (){ // 비밀번호 찾기 버튼 클릭 시 수행할 코드 작성
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Find_PW()));
                      },
                      child: Text('비밀번호 찾기', // 텍스트 위젯, '비밀번호 찾기' 문구 출력
                          style: TextStyle( // 텍스트 디자인 설정
                              color: Colors.grey, // 색상은 회색
                              fontWeight: FontWeight.bold, // 볼드체
                              fontSize: 16 // 크기는 16
                          )
                      )
                  ),
                ]
            )
        ),
        body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
            child: Padding( // 여백을 주기 위해 사용하는 위젯
                padding: EdgeInsets.fromLTRB(20, 15, 20, 5), // 좌 20 상 15 우 20 하 5의 여백을 줌
                child: Column( // 세로 정렬
                    mainAxisAlignment: MainAxisAlignment.start, // 자식 위젯들이 영역의 처음부터 순서대로 정렬되게 함
                    mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                    children: [
                      Align( // 정렬하기 위해 사용하는 위젯
                          alignment: Alignment.centerLeft, // 좌측 정렬
                          child: Text('이름', // 텍스트 위젯, '이름' 문구 출력
                              style: TextStyle( // 텍스트 디자인 설정
                                  color: Colors.grey // 색상은 회색
                              )
                          )
                      ),
                      SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                      TextField( // 텍스트 필드 위젯
                          enabled: _Field, // 텍스트 필드 위젯 활성화 여부 결정
                          controller: inputName, // 입력받은 값은 변수 inputName에 저장
                          decoration: InputDecoration( // 디자인
                              hintText: '이름을 입력해주세요.',
                              border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                  borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 상 하에 10, 좌 우에 10의 여백을 줌
                              suffixIcon: _Field == false ? Icon(Icons.check_circle_outline, color: Colors.lightGreenAccent) : null,
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              filled: _Field == false,
                              fillColor: Colors.grey
                          )
                      ),
                      SizedBox(height: 10), // 높이 10만큼의 공간을
                      Align( // 정렬하기 위해 사용하는 위젯
                          alignment: Alignment.centerLeft, // 좌측 정렬
                          child: Text('전화번호', // 텍스트 위젯, '전화번호' 문구 출력
                              style: TextStyle( // 텍스트 디자인 설정
                                  color: Colors.grey // 색상은 회색
                              )
                          )
                      ),
                      SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                      TextField( // 텍스트 필드 위젯
                          enabled: _Field, // 텍스트 필드 위젯 활성화 여부 결정
                          controller: inputPhone, // 입력받은 값은 변수 inputPhone에 저장
                          decoration: InputDecoration( // 디자인
                              hintText: '전화번호를 입력해주세요.',
                              border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                  borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 상 하에 10, 좌 우에 10의 여백을 줌
                              suffixIcon: _Field == false ? Icon(Icons.check_circle_outline, color: Colors.lightGreenAccent) : null,
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              filled: _Field == false,
                              fillColor: Colors.grey
                          )
                      ),
                      SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                      Align( // 정렬하기 위해 사용하는 위젯
                          alignment: Alignment.centerLeft, // 좌측 정렬
                          child: Text('이메일', // 텍스트 위젯, '이메일' 문구 출력
                              style: TextStyle( // 텍스트 디자인 설정
                                  color: Colors.grey // 색상은 회색
                              )
                          )
                      ),
                      SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                      TextField( // 텍스트 필드 위젯
                          enabled: _Field, // 텍스트 필드 위젯 활성화 여부 결정
                          controller: inputEmail, // 입력받은 값은 변수 inputEmail에 저장
                          decoration: InputDecoration( // 디자인
                              hintText: '이메일을 입력해주세요.',
                              border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                  borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 상 하에 10, 좌 우에 10의 여백을 줌
                              suffixIcon: _Field == false ? Icon(Icons.check_circle_outline, color: Colors.lightGreenAccent) : null,
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              filled: _Field == false,
                              fillColor: Colors.grey
                          )
                      ),
                      SizedBox(height: 10),
                      _emailAuth == false ?
                      Column(
                          children: [
                            Visibility(
                              visible: _checkField,
                              child: TextField(
                                controller: inputEmailCheck,
                                decoration: InputDecoration(
                                    hintText: '인증번호를 입력해주세요.',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                                ),
                              ),
                            ),
                            SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                            Visibility(
                                visible: _checkField,
                                child: ElevatedButton( // 버튼 위젯
                                    onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                      if(inputEmailCheck.text == ''){
                                        Popup(context, '공백없이 입력해주세요.');
                                      } else {
                                        sendCheck();
                                      }
                                    },
                                    child: Text('인증번호 확인'), // 텍스트로 '인증메일 발송' 출력
                                    style: ButtonStyle( // 버튼의 스타일 지정
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                                    )
                                )
                            )
                          ]
                      ) :
                      ElevatedButton( // 버튼 위젯
                          onPressed: (){ // 인증메일 발송 버튼 클릭 시 동작할 코드 작성
                            if(inputName.text == '' || inputPhone.text == '' || inputEmail.text == ''){
                              Popup(context, '공백없이 입력해주세요.');
                            } else {
                              sendEmail();
                            }
                          },
                          child: Text('인증메일 발송'), // 텍스트 위젯, '인증메일 발송' 출력
                          style: ButtonStyle( // 버튼의 스타일 설정
                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                          )
                      ),
                      Visibility(
                        visible: _findIDBtn,
                        child: ElevatedButton( // 버튼 위젯
                            onPressed: (){ // 아이디 찾기 버튼 클릭 시 동작할 코드 작성
                              findID();
                            },
                            child: Text('아이디 찾기'), // 텍스트 위젯, '아이디 찾기' 문구 출력
                            style: ButtonStyle( // 버튼의 스타일 설정
                                minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로는 최대, 세로는 50
                            )
                        ),
                      ) // 높이 10만큼의 공간을 줌
                    ]
                )
            )
        )
    );
  }
}
