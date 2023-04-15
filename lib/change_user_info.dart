import 'package:care_application/change_pw.dart';
import 'package:care_application/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class change_user_info extends StatelessWidget {
  const change_user_info({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangeUserInfo()
    );
  }
}

class ChangeUserInfo extends StatefulWidget {
  const ChangeUserInfo({Key? key}) : super(key: key);

  @override
  State<ChangeUserInfo> createState() => _ChangeUserInfoState();
}

class _ChangeUserInfoState extends State<ChangeUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
        title: Text('개인정보 변경', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 회색으로 설정
        leading: IconButton(onPressed: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit())); // 설정 페이지로 이동
        }, icon: Icon(Icons.arrow_back, color: Colors.black,),
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 5, // 위 여백을 위해 영역 비율 5
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
              width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
              padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
              child: OutlinedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePw())); // 비밀번호 설정 페이지로 이동
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10), // 네  여백 10 부여
                        child: Image.asset(('password.png'),color: Colors.black,),
                      ),
                    flex: 2,), // 영역 2 부여
                    Expanded(
                      child: Container(),flex: 1, // 아이콘과 텍스트 사이 여백 1부여
                    ),
                    Expanded(
                        child:Text('비밀정보 변경',style: TextStyle(color: Colors.black),)
                    ,flex: 5,), // 영역 5 부여
                    Expanded(
                      child: Container(),flex: 2, // 중간 여백 비율2 부여
                    ),
                    Expanded(
                      child: Icon(Icons.arrow_outward_outlined),
                    )
                  ],
                ),
              ),
            ),
          flex: 3,), // 버튼사이 간격 3부여
          Expanded(
            child: Container(), flex: 2, // 버튼사이 간격 2부여
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
              width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
              padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
              child: OutlinedButton(
                onPressed: (){

                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10), // 네 면의 여백 10 부여
                        child: Image.asset(('phone_number.png'),color: Colors.black,),
                      ),
                      flex: 2,), // 영역 2 부여
                    Expanded(
                      child: Container(),flex: 1, // 아이콘과 텍스트 사이 여백 1부여
                    ),
                    Expanded(
                      child:Text('전화번호 변경',style: TextStyle(color: Colors.black),)
                      ,flex: 5,), // 영역 5 부여
                    Expanded(
                      child: Container(),flex: 2, // 중간 여백 비율2 부여
                    ),
                    Expanded(
                      child: Icon(Icons.arrow_outward_outlined),
                    )
                  ],
                ),
              ),
            ),
          flex: 3,), // 버튼사이 간격 3부여
          Expanded(
            child: Container(),flex: 2, // 버튼사이 여백2 부여
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width*0.1, // 위젯의 높이를 화면 너비*0.1로 설정
              width: MediaQuery.of(context).size.width*0.4, // 위젯의 너비를 화면 너비*0.4로 설정
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20), // 상하20 여백을 줌
              child: OutlinedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit())); // 설정 페이지로 이동
                },child: Text('돌아가기', style: TextStyle(color: Colors.black,),),
              ),
            ),
          flex: 4,), // 영역 비율 4 부여
          Expanded(
            child: Container(),flex: 5, // 하단 여백 5 부여
          )
        ],
      ),
    );
  }
}
