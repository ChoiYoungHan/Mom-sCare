import 'package:care_application/change_user_info.dart';
import 'package:care_application/delete_user.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class edit extends StatelessWidget {
  const edit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Edit()
    );
  }
}

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('설정', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // 마이페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 3, // 위 여백을 위해 영역 비율 3
          ),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeUserInfo()));
                    },
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                              child: Image.asset(('assets/edit.png')) // 버튼 왼쪽 이미지
                          )
                          ,flex: 2,), // 영역비율 2 부여
                        Expanded(
                          child: Container(),flex: 1, // 아이콘과 텍스트 사이 영역 1부여
                        ),
                        Expanded(
                          child:Text('개인정보 변경',style: TextStyle(color: Colors.black),)
                          ,flex: 5,), // 영역 비율 5 부여
                        Expanded(
                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                        ),
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Question())); // 문의하기 페이지로 이동
                    },
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(10), // 모든 여백 5 부여
                              child: Image.asset(('assets/question-mark.png')) // 버튼 왼쪽 이미지
                          )
                          ,flex: 2,), // 영역비율 2 부여
                        Expanded(
                          child: Container(),flex: 1, // 아이콘과 텍스트 사이 영역 1부여
                        ),
                        Expanded(
                          child:Text('문의 하기',style: TextStyle(color: Colors.black),)
                          ,flex: 5,), // 영역 비율 5 부여
                        Expanded(
                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                        ),
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeleteUser())); // 회원탈퇴 페이지로 이동
                    },
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(15), // 모든 여백 15 부여
                              child: Image.asset(('assets/x.png')) // 버튼 왼쪽 이미지
                          )
                          ,flex: 2,), // 영역비율 2 부여
                        Expanded(
                          child: Container(),flex: 1, // 아이콘과 텍스트 사이 영역 1부여
                        ),
                        Expanded(
                          child:Text('회원 탈퇴',style: TextStyle(color: Colors.black),)
                          ,flex: 5,), // 영역 비율 5 부여
                        Expanded(
                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                        ),
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),// 영역 비율 2 부여
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width*0.1, // 위젯의 높이를 화면 너비*0.1로 설정
              width: MediaQuery.of(context).size.width*0.4,
              padding: EdgeInsets.fromLTRB(0, 70, 0, 70), // 상하80 여백을 줌
              child: OutlinedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // 마이페이지로 이동
                }, child: Text('돌아가기', style: TextStyle(color: Colors.black,),),
              ),
            ),
            flex: 4,),
          Expanded(
            child: Container(),flex: 2,
          )
        ],
      ),
    );
  }
}