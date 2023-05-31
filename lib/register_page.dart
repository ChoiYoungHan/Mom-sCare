import 'package:care_application/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register_Page extends StatelessWidget {
  const Register_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본 제거
        home: RegisterPage()
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // 회원가입 정보를 입력할 때 사용할 텍스트 필드
  TextEditingController inputID = new TextEditingController();
  TextEditingController inputPW = new TextEditingController();
  TextEditingController inputCheckPW = new TextEditingController();
  TextEditingController inputName = new TextEditingController();
  TextEditingController inputPhone = new TextEditingController();
  TextEditingController inputEmail = new TextEditingController();
  TextEditingController inputEmailCheck = new TextEditingController();

  bool _isEnabled = true, _emailField = true, _editCheck = true, _password = true, _passwordCheck = true;

  Future<void> sendData() async {
    final uri = Uri.parse('http://182.219.226.49/moms/register');
    final headers = {'Content-Type': 'application/json'};

    final ID = inputID.text;
    final PW = inputPW.text;
    final Name = inputName.text;
    final Phone = inputPhone.text;
    final Email = inputEmail.text;

    final body = jsonEncode({'id': ID, 'pw': PW, 'name': Name, 'phone': Phone, 'email': Email});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      inputID.clear();
      inputPW.clear();
      inputCheckPW.clear();
      inputName.clear();
      inputPhone.clear();
      inputEmail.clear();
      inputEmailCheck.clear();
    } else {

    }
  }

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

    // 먼저, 다음과 같이 Modal 위젯을 이용하여 화면 전체를 커버합니다.
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다른 영역을 탭하여 Modal 위젯을 닫지 못하도록 합니다.
      builder: (BuildContext context) {
        // Modal 위젯의 child로 CircularProgressIndicator 위젯을 사용합니다.
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final uri = Uri.parse('http://182.219.226.49/moms/sendemail');
    final headers = {'Content-Type': 'application/json'};

    final Id = inputID.text;
    final Phone = inputPhone.text;
    final Email = inputEmail.text;

    final body = jsonEncode({'id': Id, 'phone': Phone, 'email': Email});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);
      Navigator.of(context, rootNavigator: true).pop();

      if(jsonData == null || !jsonData.containsKey('message')){
        setState(() {
          _isEnabled = false;
        });
        return;
      }

      if(utf8.decode(jsonData['message'].runes.toList()) == '아이디 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 아이디 입니다.');
        inputID.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '핸드폰 번호 (이)가 중복 됩니다.') {
        Popup(context, '이미 가입된 핸드폰 번호 입니다.');
        inputPhone.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '이메일 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 이메일 입니다.');
        inputEmail.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '아이디 핸드폰 번호 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 아이디와 핸드폰번호 입니다.');
        inputID.clear();
        inputPhone.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '이메일 아이디 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 아이디와 이메일 입니다.');
        inputID.clear();
        inputEmail.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '이메일 핸드폰 번호 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 핸드폰 번호와 이메일 입니다.');
        inputPhone.clear();
        inputEmail.clear();
      } else if(utf8.decode(jsonData['message'].runes.toList()) == '이메일 아이디 핸드폰 번호 (이)가 중복 됩니다.'){
        Popup(context, '이미 가입된 아이디와 핸드폰 번호, 이메일 입니다.');
        inputID.clear();
        inputPhone.clear();
        inputEmail.clear();
      } else {

      }

    } else {

    }
  }

  Future<void> checkEmail() async {
    final uri = Uri.parse('http://182.219.226.49/moms/sendemail/auth');
    final headers = {'Content-Type': 'application/json'};

    final email = inputEmail.text;
    final checknum = inputEmailCheck.text;

    final body = jsonEncode({'email': email, 'auth': checknum});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      if(jsonData['success'] == true) {
        setState(() {
          _emailField = false;
          _editCheck = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                  content: Container(
                      height: 25,
                      child: Center(child: Text('인증번호가 일치하지 않습니다.', style: TextStyle(color: Colors.grey, fontSize: 17)))
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
      inputEmailCheck.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login_Page()));

        return false;
      },
      child: Scaffold( // 상 중 하를 나누는 위젯
          appBar: AppBar( // 상단 바
              backgroundColor: Colors.white, // 배경색 흰색
              leading: IconButton( // 아이콘 버튼 위젯
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login_Page()));
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 아이콘, 색상은 회색
              ),
              title: Text('회원가입', style: TextStyle(color: Colors.grey)) // 페이지의 제목을 회원가입으로 함, 색상은 회색
          ),
          body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
              child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding( // 여백을 주기 위해 사용하는 위젯
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 5), // 좌 20 상 15 우 20 하 5의 여백을 줌
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 자식 위젯들이 수직 방향으로 가운데 정렬하도록 함
                            mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                            children: [
                              Align(alignment:Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('아이디', // 텍스트 위젯, '아이디' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  controller: inputID, // 입력받은 값은 변수 inputID에 저장
                                  decoration: InputDecoration( // 디자인
                                      hintText: '아이디를 입력해주세요.',
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),
                              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                              Align(alignment: Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('비밀번호', // 텍스트 위젯, '비밀번호' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  obscureText: _password, // 비밀번호 마스킹 처리
                                  controller: inputPW, // 입력받은 값은 변수 inputPw에 저장
                                  decoration: InputDecoration( // 디자인
                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              _password = !_password;
                                            });
                                          },
                                          icon: Icon(Icons.remove_red_eye_outlined)
                                      ),
                                      hintText: '비밀번호를 입력해주세요.',
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),
                              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                              Align(alignment: Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('비밀번호 확인', // 텍스트 위젯, '비밀번호 확인' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  obscureText: _passwordCheck,
                                  controller: inputCheckPW, // 입력받은 값은 변수 inputCheckPw에 저장
                                  decoration: InputDecoration( // 디자인
                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              _passwordCheck = !_passwordCheck;
                                            });
                                          },
                                          icon: Icon(Icons.remove_red_eye_outlined)
                                      ),
                                      hintText: '비밀번호를 입력해주세요.',
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),
                              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                              Align(alignment: Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('이름', // 텍스트 위젯, '이름' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  controller: inputName, // 입력받은 값은 변수 inputName에 저장
                                  decoration: InputDecoration( // 디자인
                                      hintText: '이름을 입력해주세요.',
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),
                              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                              Align(alignment: Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('전화번호', // 텍스트 위젯, '전화번호' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  controller: inputPhone, // 입력받은 값은 변수 inputPhone에 저장
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration( // 디자인
                                      hintText: '전화번호를 입력해주세요.',
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),
                              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                              Align(alignment: Alignment.centerLeft, // 정렬 위젯, 좌측 정렬
                                  child: Text('이메일', // 텍스트 위젯, '이메일' 문구 출력
                                      style: TextStyle(color: Colors.grey) // 색상은 회색
                                  )
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              TextField( // 텍스트 필드 위젯
                                  enabled: _emailField,
                                  controller: inputEmail, // 입력받은 값은 변수 inputEmail에 저장
                                  decoration: InputDecoration( // 디자인
                                      filled: _emailField == false,
                                      fillColor: Colors.grey,
                                      hintText: '이메일을 입력해주세요.',
                                      suffixIcon: _emailField == false ? Icon(Icons.check_circle_outline, color: Colors.lightGreenAccent) : null,
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                      ),
                                      border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                          borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                                  )
                              ),SizedBox(height: 10),
                              _isEnabled == true ?
                              ElevatedButton( // 버튼 위젯
                                  onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                    if(inputID.text == '' || inputPhone.text == '' || inputEmail.text == ''){
                                      Popup(context, '아이디와 전화번호, 이메일은 필수로 입력하셔야 합니다.');
                                    } else if(!inputEmail.text.contains('@') && !inputEmail.text.contains('.')){
                                      Popup(context, '이메일 형식이 올바르지 않습니다.');
                                    } else {
                                      setState(() {
                                        sendEmail();
                                      });
                                    }
                                  },
                                  child: Text('인증메일 발송'), // 텍스트로 '인증메일 발송' 출력
                                  style: ButtonStyle( // 버튼의 스타일 지정
                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 50) // 버튼의 가로를 최대, 세로는 50
                                      )
                                  )
                              ) :
                              Column(
                                  children: [
                                    Visibility(
                                      visible: _editCheck,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
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
                                      visible: _editCheck,
                                      child: ElevatedButton( // 버튼 위젯
                                          onPressed: (){ // 버튼을 누를 시 동작할 코드 작성
                                            if(inputEmailCheck.text == ''){
                                              Popup(context, '인증 번호를 입력해주세요.');
                                            } else {
                                              setState(() {
                                                checkEmail();
                                              });
                                            }
                                          },
                                          child: Text('인증번호 확인'), // 텍스트로 '인증메일 발송' 출력
                                          style: ButtonStyle( // 버튼의 스타일 지정
                                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50) // 버튼의 가로를 최대, 세로는 50
                                              )
                                          )
                                      ),
                                    )
                                  ]
                              ),
                              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                              ElevatedButton( // 버튼 위젯
                                  onPressed: (){
                                    if(inputID.text == '' || inputPW.text == '' || inputCheckPW.text == '' || inputName.text == '' || inputPhone.text == '' || inputEmail.text == ''){
                                      Popup(context, '공백 없이 입력해주세요.');
                                    } else if(inputPW.text != inputCheckPW.text){
                                      Popup(context, '입력한 비밀번호를 확인해주세요.');
                                    } else if (_emailField == false) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              content: Container(
                                                  height: 25,
                                                  child: Center(child: Text('회원가입이 완료되었습니다.', style: TextStyle(color: Colors.grey, fontSize: 17)))
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login_Page()));
                                                    sendData();
                                                  },
                                                  child: Text('확인'),
                                                  style: ButtonStyle(
                                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    } else if(_emailField == true) {
                                      Popup(context, '이메일을 인증해주세요.');
                                    }
                                  },
                                  child: Text('회원가입 신청'),
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                                  ))
                            ]
                        )
                    )
                  ]
              )
          )
      ),
    );
  }
}
