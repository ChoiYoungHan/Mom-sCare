import 'package:care_application/find_ID.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class Find_PW extends StatelessWidget {
  const Find_PW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본 제거
      home: FindPW()
    );
  }
}

class FindPW extends StatefulWidget {
  const FindPW({Key? key}) : super(key: key);

  @override
  State<FindPW> createState() => _FindPWState();
}

class _FindPWState extends State<FindPW> {

  // 회원정보를 입력할 때 사용할 텍스트 필드
  TextEditingController inputID = new TextEditingController();
  TextEditingController inputPhone = new TextEditingController();
  TextEditingController inputEmail = new TextEditingController();

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
              onPressed: () { // 아이디 찾기 버튼 클릭 시 수행할 코드 작성
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Find_ID()));
              },
              child: Text('아이디 찾기', // 텍스트 위젯, '아이디 찾기' 문구 출력
                style: TextStyle( // 텍스트 디자인 설정
                  color: Colors.grey, // 색상은 회색
                  fontWeight: FontWeight.bold, // 볼드체
                  fontSize: 16 // 크기는 16
                )
              )
            ),
            TextButton( // 텍스트 버튼 위젯
              onPressed: (){ // 비밀번호 찾기 버튼 클릭 시 수행할 코드 작성 ( 기본 페이지이므로 작성 안함 )
                  
              },
              child: Text('비밀번호 찾기', // 텍스트 위젯, '비밀번호 찾기' 문구 출력
                style: TextStyle( // 텍스트 디자인 설정
                  color: Colors.blue, // 색상은 파랑
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
            mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
            mainAxisAlignment: MainAxisAlignment.start, // 자식 위젯들이 영역의 처음부터 순서대로 정렬되게 함
            children: [
              Align( // 정렬하기 위해 사용하는 위젯
                alignment: Alignment.centerLeft, // 좌측 정렬
                child: Text('아이디', // 텍스트 위젯, '아이디' 문구 출력
                  style: TextStyle( // 텍스트 디자인 설정
                     color: Colors.grey // 색상은 회색
                  )
                )
              ),
              SizedBox(height: 5), // 높이 5만큼의 공간을 줌
              TextField( // 텍스트 필드 위젯
                controller: inputID, // 입력받은 값은 변수 inputID에 저장
                decoration: InputDecoration( // 디자인
                  hintText: '아이디를 입력해주세요.',
                  border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                    borderSide: BorderSide(color: Colors.grey) // 색상은 회색
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                )
              ),
              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
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
                controller: inputPhone, // 입력받은 값은 변수 inputPhone에 저장
                decoration: InputDecoration( // 디자인
                  hintText: '전화번호를 입력해주세요.',
                  border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                    borderSide: BorderSide(color: Colors.grey) // 색상은 회색
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
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
                controller: inputEmail, // 입력받은 값은 변수 inputEmail에 저장
                decoration: InputDecoration( // 디자인
                  hintText: '이메일을 입력해주세요.',
                  border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                    borderSide: BorderSide(color: Colors.grey) // 색상은 회색
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10) // 상 하에 10, 좌 우에 10의 여백을 줌
                )
              ),
              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
              ElevatedButton( // 버튼 위젯
                onPressed: (){ // 인증메일 발송 버튼 클릭 시 동작할 코드 작성

                },
                child: Text('인증메일 발송'), // 텍스트 위젯, '인증메일 발송' 출력
                style: ButtonStyle( // 버튼의 스타일 설정
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로를 최대, 세로는 50
                )
              ),
              SizedBox(height: 10), // 높이 10만큼의 공간을 줌
              ElevatedButton( // 버튼 위젯
                onPressed: (){ // 비밀번호 찾기 버튼 클릭 시 동작할 코드 작성

                },
                child: Text('비밀번호 찾기'), // 텍스트 위젯, '비밀번호 찾기' 문구 출력
                style: ButtonStyle( // 버튼의 스타일 설정
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)) // 버튼의 가로는 최대, 세로는 50
                )
              ),
            ] 
          )
        ) 
      )
    );
  }
}
