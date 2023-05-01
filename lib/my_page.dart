import 'package:care_application/baby_add.dart';
import 'package:care_application/baby_info.dart';
import 'package:care_application/chatBot.dart';
import 'package:care_application/edit.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/login_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class my_page extends StatelessWidget {
  const my_page({Key? key, this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage(UserNum: userNum)
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var baby_num;
  final List<String> babies = <String>['A','B','C','D','E','F','G','H','I']; // 추후 받아올 아이 정보

  Future<List<dynamic>> babies_() async {
    final uri = Uri.parse('http://182.219.226.49/moms/baby');
    final headers = {'Content-Type': 'application/json'};

    final clientnum = widget.UserNum;

    final body = jsonEncode({'clientNum': '64'});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData); // 받아온 값 로그찍기
      return jsonData;
    }else{
      print(response.statusCode.toString());
      throw Exception('Fail'); // 오류 발생시 예외발생(return에 null반환이 안되게 해서 해줘야함)
    }
  }

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
              child: FutureBuilder<List<dynamic>>(
                future: babies_(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,0),
                          child: Container(
                            width: 50, // 너비 120
                            height: 50, // 높이 50
                            child: OutlinedButton(
                                onPressed: (){
                                  setState(() {
                                    baby_num=index;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      //child: Text('${snapshot.data![index]['TITLE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                                      child: Image.asset('assets/baby_babyInfo.png'),
                                      flex: 1,),
                                    Expanded(
                                      child: Container(),flex: 2,
                                    ),
                                    Expanded(
                                      child: Text('${snapshot.data![index]['BABYNAME']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                                      flex: 1,),
                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    );
                  }else if(snapshot.hasError){
                    return Text('아이를 등록해주세요',style: TextStyle(color: Colors.black),);
                  }
                  return const CircularProgressIndicator();
                },
              )
            /*child: ListView.builder(
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
                      onPressed: (){
                        baby_num=index;
                      },
                      child: Text('${babies[index]}',style: TextStyle(color: Colors.black),) // 버튼의 이름을 아이의 이름으로 설정 + 검정색을 글씨
                    )
                  ),
                );
              })*/
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => baby_info(userNum: widget.UserNum, babyNum: baby_num,))); // 홈페이지로 화면이동
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
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => baby_add())); // 홈페이지로 화면이동
                      }, // 버튼을 눌렀을 때 실행될 함수 지정
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
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit())); // 캘린더페이지로 화면 이동
                      }, // 버튼을 눌렀을 때 실행될 함수 지정
                      child: Text('설정', style: TextStyle(color: Colors.black),)
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                    padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                    child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Notice())); // 공지사항 페이지로 이동
                      }, // 버튼을 눌렀을 때 실행될 함수 지정
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
                onPressed: (){
                  showDialog( // 팝업 위젯
                      context: context,
                      barrierColor: Colors.grey.withOpacity(0.6),
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(''), // 상단 여백
                          content: Text('로그아웃 되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                          actions: [
                            OutlinedButton(
                            onPressed:(){
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login_Page()));
                            }, child: Text('확인'))
                          ],
                        );
                      }
                  );
                }, // 버튼을 눌렀을 때 실행될 함수 지정
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.UserNum,))); // 홈페이지로 화면이동
              },
              icon: Icon(Icons.home_outlined),
            ),
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum,))); // 캘린더페이지로 화면 이동
              },
              icon: Icon(Icons.event_note_outlined),
            ),
            IconButton( // 아이콘 버튼 위젯
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBot()));
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
