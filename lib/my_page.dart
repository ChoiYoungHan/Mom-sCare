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
  const my_page({Key? key,required this.userNum, this.babyNum, this.index}) : super(key: key);

  final userNum;
  final babyNum, index;
  @override
  Widget build(BuildContext context) {
    // print("my_page 페이지");
    // print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyPage(UserNum: userNum, index: index)
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {



  var baby_name;
  var baby_num;
  var baby_index;

  var info_babynum;

  bool selectedButton = false;

  final List<String> babies = <String>['A','B','C','D','E','F','G','H','I']; // 추후 받아올 아이 정보
  late Future<List<dynamic>> babiesFuture;

  void initState(){
    super.initState();
    babiesFuture = babies_();
  }

  Future<List<dynamic>> babies_() async { // 아이 목록 출력 함수
    final uri = Uri.parse('http://182.219.226.49/moms/baby');
    final headers = {'Content-Type': 'application/json'};

    final clientnum = widget.UserNum;

    final body = jsonEncode({'clientNum': clientnum});
    print('아이 정보 호출 1');
    final response = await http.post(uri, headers: headers, body: body);
    print('아이 정보 호출 2');

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      return jsonData;
    }else{
      print('myPage에서 아기 정보 불러오는 것에 대한 실패' + response.statusCode.toString());
      throw Exception('Fail'); // 오류 발생시 예외발생(return에 null반환이 안되게 해서 해줘야함)
    }
  }

  @override
  Widget build(BuildContext context) {
    print('my페이지에서 받아온 index는 ' + widget.index.toString() + ' 입니다.');
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
      child: Scaffold(
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
                    if(snapshot.hasData){ // 받아온 데이터가 존재 할 시
                      return ListView.builder(
                        scrollDirection: Axis.horizontal, // 리스트뷰를 가로로 함
                        itemCount: snapshot.data!.length, // 데이터의 길이만큼을 카운트함
                        itemBuilder: (context, index){
                          (index == widget.index) && !selectedButton ? info_babynum = snapshot.data![index]['BABYNO'] : null;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5,10,5,0),
                            child: Container(
                              width: 100, // 너비 120
                              height: 40, // 높이 50
                              child: OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      baby_num=snapshot.data![index]['BABYNO']; // 버튼이 눌렸을 시 아이 번호를 입력 받음
                                      baby_name = snapshot.data![index]['BABYNAME'];
                                      baby_index=index;
                                      selectedButton = true;
                                    });
                                  },
                                  style: (index == widget.index) && !selectedButton ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)) : (baby_index == index ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)) : null),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        //child: Text('${snapshot.data![index]['TITLE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Image.asset('assets/baby_babyInfo.png'),
                                        ),
                                        flex: 2),
                                      Expanded(
                                        //child: Container(),
                                        child: Text('${snapshot.data![index]['BABYNAME']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 아이의 이름
                                        flex: 1
                                      )
                                    ],
                                  )
                              ),
                            ),
                          );
                        },
                      );
                    }else if(snapshot.hasError){ // 데이터가 존재하지 않거나 에러가 발생 시
                      return Center(child: Text('아이를 등록해주세요',style: TextStyle(color: Colors.black),));
                    }
                    return Center(child: const CircularProgressIndicator(color: Colors.grey,),); // 데이터를 불러오는 동안 보여주는 화면 (버퍼링 위젯)
                  },
                )
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
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => baby_info(userNum: widget.UserNum, babyNum: selectedButton ? baby_num : info_babynum, index: selectedButton == true ? baby_index : widget.index),
                                    ),
                                  );                              }, // 버튼을 눌렀을 때 실행될 함수 지정
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
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => baby_add(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index),
                                    ),
                                  );
                                }, // 버튼을 눌렀을 때 실행될 함수 지정
                                child: Text('우리 아기 등록', style: TextStyle(color: Colors.black),)
                            )
                        )
                    )
                  ],
                )
                ,flex: 3), // 위젯이 차지할 영역 비율 2
            Expanded(
              child: Row( // 가로 위젯
                children: [
                  Expanded(
                      child: Container( // 상자 위젯
                          height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                          padding: EdgeInsets.all(30), // 네 면의 여백을 30만큼 줌
                          child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                              onPressed: (){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => edit(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index),
                                  ),
                                );                             }, // 버튼을 눌렀을 때 실행될 함수 지정
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
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => notice(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index))); // 공지사항 페이지로 이동
                              }, // 버튼을 눌렀을 때 실행될 함수 지정
                              child: Text('공지사항', style: TextStyle(color: Colors.black),)
                          )
                      )
                  )
                ],
              )
              ,flex: 3,), // 위젯이 차지할 영역 비율 2
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
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login_Page()));
                                        }, child: Text('확인'))
                                  ],
                                );
                              }
                          );
                        }, // 버튼을 눌렀을 때 실행될 함수 지정
                        child: Text('로그아웃', style: TextStyle(color: Colors.black),)
                    )
                )
                ,flex: 3) // 위젯이 차지할 영역 비율 2
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
              children: [
                IconButton( // 아이콘 버튼 위젯
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index))); // 홈페이지로 화면 이동
                  },
                  icon: Icon(Icons.home_outlined),
                ),
                IconButton( // 아이콘 버튼 위젯
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index))); // 캘린더페이지로 화면 이동
                  },
                  icon: Icon(Icons.event_note_outlined),
                ),
                IconButton( // 아이콘 버튼 위젯
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chatBot(userNum: widget.UserNum, index: selectedButton == true ? baby_index : widget.index))); // 챗봇페이지로 화면 이동
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
      ),
    );
  }
}