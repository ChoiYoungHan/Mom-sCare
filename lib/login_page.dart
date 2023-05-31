import 'dart:convert';

import 'package:care_application/chatBot.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'find_ID.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko_KR', null);
  runApp(const Login_Page());
}

class Login_Page extends StatelessWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본을 제거
        home: LoginPage()
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 로그인 정보를 입력할 때 사용할 텍스트 필드
  TextEditingController inputID = TextEditingController();
  TextEditingController inputPW = TextEditingController();

  Future<void> sendData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
              child: CircularProgressIndicator()
          );
        }
    );

    final uri = Uri.parse('http://182.219.226.49/moms/login');
    final headers = {'Content-Type': 'application/json'};
    final id = inputID.text;
    final pw = inputPW.text;
    final body = jsonEncode({'id': id, 'pw': pw});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      if(jsonData['success'] == true){
        String UserNum = jsonData['cnum'].toString();
        print(UserNum);
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: UserNum, index: 0)));
      } else {
        Popup(context, '회원정보가 일치하지 않습니다.');
      }
      inputID.clear();
      inputPW.clear();
    } else {

    }
  }

  // BuildContext와 String 타입의 매개변수를 받아 팝업을 띄움
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text('어플을 종료하시겠습니까?'),
                actions: [
                  ElevatedButton(
                    child: Text('아니오'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('예'),
                    onPressed: () {
                      Navigator.of(context).pop(true); // 다이얼로그를 닫고 뒤로 이동합니다.
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            }
        );

        return false;
      },
      child: Scaffold( // 상 중 하를 나누는 위젯
          resizeToAvoidBottomInset: false, // 채팅바가 올라올 때 페이지가 밀리는 것을 방지
          body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
              child: Column( // 세로 정렬
                  mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                  mainAxisAlignment: MainAxisAlignment.center, // 자식 위젯들이 수직 방향으로 가운데 정렬하게 함
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Center( // 중앙에 배치하는 위젯
                          child: Text("Mom's Care", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)) // 텍스트 출력 및 폰트 크기 50, 볼드체
                      ),
                    ),
                    Column( // 세로 정렬
                        mainAxisAlignment: MainAxisAlignment.center, // 자식 위젯들이 수직 방향으로 가운데 정렬하게 함
                        mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: TextField( // 텍스트 필드 위젯
                                controller: inputID, // 입력받은 값은 변수 inputID에 저장
                                decoration: InputDecoration( // 디자인
                                    hintText: '아이디를 입력해주세요',
                                    border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                        borderSide: BorderSide(color: Colors.grey) // 테두리의 색상을 회색
                                    )
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: TextField( // 텍스트 필드 위젯
                                obscureText: true,
                                controller: inputPW, // 입력받은 값은 변수 inputPW에 저장
                                decoration: InputDecoration( // 디자인
                                    hintText: '비밀번호를 입력해주세요',
                                    border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                        borderSide: BorderSide(color: Colors.grey) // 테두리의 색상을 회색
                                    )
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: ElevatedButton( // 버튼 위젯
                                onPressed: () async { // 버튼을 누를 시 동작할 코드 작성
                                  if(inputID.text == '' || inputPW.text == ''){
                                    Popup(context, '공백 없이 입력해주세요.');
                                  } else {
                                    sendData();
                                  }
                                },
                                child: Text('로그인'), // 텍스트로 '로그인' 출력
                                style: ButtonStyle( // 버튼의 스타일 지정
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: ElevatedButton( // 버튼 위젯
                                onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register_Page()));
                                },
                                child: Text('회원가입'), // 텍스트로 '회원가입' 출력
                                style: ButtonStyle( // 버튼의 스타일 지정
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: TextButton( // 텍스트 버튼 위젯
                                onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Find_ID()));
                                },
                                child: Text('아이디/비밀번호 찾기', // 텍스트로 '아이디/비밀번호 찾기' 출력
                                    style: TextStyle( // 텍스트 스타일 지정
                                        color: Colors.blue, // 색상은 파랑
                                        decoration: TextDecoration.underline // 아래에 선긋기
                                    )
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0), // 좌 20 상 0 우 20 하 15의 여백을 줌
                            child: TextButton( // 텍스트 버튼 위젯
                                onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatBot()));
                                },
                                child: Text('아이디/비밀번호 찾기', // 텍스트로 '아이디/비밀번호 찾기' 출력
                                    style: TextStyle( // 텍스트 스타일 지정
                                        color: Colors.blue, // 색상은 파랑
                                        decoration: TextDecoration.underline // 아래에 선긋기
                                    )
                                )
                            ),
                          )
                        ]
                    )
                  ]
              )
          )
      ),
    );
  }
}
