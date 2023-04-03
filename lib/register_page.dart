import 'package:care_application/login_page.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 상 중 하를 나누는 위젯
      resizeToAvoidBottomInset: false, // 채팅바가 올라올 때 페이지가 밀리는 것을 방지
      appBar: AppBar( // 상단 바
        backgroundColor: Colors.white, // 배경색 흰색
        leading: IconButton( // 아이콘 버튼 위젯
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login_Page()));
          },
          icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 아이콘, 색상은 회색
        ),
        title: Text('회원가입', style: TextStyle(color: Colors.grey)) // 페이지의 제목을 회원가입으로 함, 색상은 회색
      ),
      body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
        child: SingleChildScrollView( // 자식 위젯의 수가 너무 많아 OverFlow가 발생할 경우 스크롤이 가능하도록 하는 위젯
          scrollDirection: Axis.vertical, // 스크롤 방향을 지정: 세로로 스크롤
          child: Padding( // 여백을 주기 위해 사용하는 위젯
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
                  controller: inputPW, // 입력받은 값은 변수 inputPw에 저장
                  decoration: InputDecoration( // 디자인
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
                  controller: inputCheckPW, // 입력받은 값은 변수 inputCheckPw에 저장
                  decoration: InputDecoration( // 디자인
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
                  controller: inputEmail, // 입력받은 값은 변수 inputEmail에 저장
                  decoration: InputDecoration( // 디자인
                    hintText: '이메일을 입력해주세요.',
                    border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                      borderSide: BorderSide(color: Colors.grey) // 테두리의 색상은 회색
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                  )
                ),
                SizedBox(height: 10), // 높이 10만큼의 공간을 줌
                ElevatedButton( // 버튼 위젯
                  onPressed: (){ // 버튼을 누를 시 동작할 코드 작성 
                    
                  },
                  child: Text('인증메일 발송'), // 텍스트로 '인증메일 발송' 출력
                  style: ButtonStyle( // 버튼의 스타일 지정
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50) // 버튼의 가로를 최대, 세로는 50 
                  ))
                ),
                SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                Align(alignment: Alignment.center, // 정렬 위젯, 좌측 정렬
                  child: Text('인증이 완료되었습니다.', // 텍스트 위젯, 인증 완료 문구 출력
                    style: TextStyle(color: Colors.green) // 색상은 초록
                  )
                ),
                SizedBox(height: 5), // 높이 5만큼의 공간을 줌
                ElevatedButton( // 버튼 위젯
                  onPressed: (){
                    
                  }, 
                  child: Text('회원가입 신청'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                  )
                )
              ]
            ),
          )
        )
      )
    );
  }
}
