import 'package:care_application/baby_info.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class my_page extends StatelessWidget {
  const my_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage()
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final List<String> babies = <String>['A','B','C','D','E','F','G','H','I']; // 추후 받아올 아이 정보
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
        title: Text('마이페이지', style: TextStyle(color: Colors.grey)) // 상단 바 글자색을 검정색으로 설정
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로로 스크롤 할 수 있도록 설정
              itemCount: babies.length, // 아이템 개수를 받아온 아이 리스트의 길이로 설정
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40), // 상하단 패딩 40 적용
                  child: Container(
                    width: 120, // 버튼 너비
                    height: 50, // 버튼 높이
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)), // 버튼의 배경색을 흰색으로 적용
                      onPressed: (){},
                      child: Text('${babies[index]}',style: TextStyle(color: Colors.black),) // 버튼의 이름을 아이의 이름으로 설정 + 검정색을 글씨
                    )
                  ),
                );
              })
          ,flex: 2), // 위젯이 차지할 영역 비율 2
          Expanded(
            child: Row( // 가로 위젯
              children: [
                Expanded(
                  child: Container( // 상자 위젯
                    height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                    padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                    child: OutlinedButton( // 테두리만 있는 버튼
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => baby_info())); // 홈페이지로 화면이동
                      }, // 버튼을 눌렀을 때 실행될 함수 지정
                      child: Text('아기 정보', style: TextStyle(color: Colors.black),)
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                    padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                    child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                      onPressed: (){}, // 버튼을 눌렀을 때 실행될 함수 지정
                      child: Text('우리 아기 등록', style: TextStyle(color: Colors.black),)
                    )
                  )
                )
              ],
            )
          ,flex: 2), // 위젯이 차지할 영역 비율 2
          Expanded(
            child: Row( // 가로 위젯
              children: [
                Expanded(
                  child: Container( // 상자 위젯
                    height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                    padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                    child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                      onPressed: (){}, // 버튼을 눌렀을 때 실행될 함수 지정
                      child: Text('설정', style: TextStyle(color: Colors.black),)
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                    padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                    child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                      onPressed: (){}, // 버튼을 눌렀을 때 실행될 함수 지정
                      child: Text('공지사항', style: TextStyle(color: Colors.black),)
                    )
                  )
                )
              ],
            )
          ,flex: 2,), // 위젯이 차지할 영역 비율 2
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
              width: MediaQuery.of(context).size.width*0.5, // 위젯의 너비를 화면 너비의 절반으로 동일설정
              padding: EdgeInsets.all(40), // 네 면의 여백을 40만큼 줌
              child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                onPressed: (){}, // 버튼을 눌렀을 때 실행될 함수 지정
                child: Text('로그아웃', style: TextStyle(color: Colors.black),)
              )
            )
          ,flex: 2) // 위젯이 차지할 영역 비율 2
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
          children: [
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page())); // 홈페이지로 화면이동
              },
              icon: Icon(Icons.home_outlined),
            ),
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp())); // 캘린더페이지로 화면 이동
              },
              icon: Icon(Icons.event_note_outlined),
            ),
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){

              },
              icon: Icon(Icons.chat_outlined),
            ),
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){}, // 현재 위치한 페이지로 화면설정을 하지 않고 버튼 형태만 유지
              icon: Icon(Icons.list_alt_outlined, color: Colors.blue),
            ),
          ],
        )
      ),
    );
  }
}
