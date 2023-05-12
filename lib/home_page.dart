import 'dart:convert';

import 'package:care_application/chatBot.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/week_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({Key? key, required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단의 debug 리본 제거
        home: HomePage(UserNum: userNum)
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var babyname, week, dday, exist;

  List<String> b_babyname = [];
  List<String> b_expectteddate = [];
  List<String> b_dday = [];
  List<String> b_week = [];


  void initState(){
    super.initState();
    receiveWeek();
  }

  Future<Response> receiveWeek() async {

    final uri = Uri.parse('http://182.219.226.49/moms/pregnancy-week');
    final headers = {'Content-Type' : 'application/json'};

    final clientNum = widget.UserNum;

    final body = jsonEncode({'clientNum': clientNum});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      print('요청 성공');

      if(jsonData != null){

        b_babyname.clear();
        b_expectteddate.clear();
        b_dday.clear();
        b_week.clear();

        jsonData.forEach((element){
          String encodedName = element['babyname'];
          String decodedName = utf8.decode(encodedName.runes.toList());
          b_babyname.add(decodedName);

          b_expectteddate.add(element['expecteddate']);
          b_dday.add(element['dday'].toString());
          b_week.add(element['week'].toString());
        });

        print(b_babyname);

        print('안녕');
        // print(utf8.decode(jsonData[0]['babyname'].runes.toList()));
        // print(utf8.decode(jsonData[0]['expecteddate'].runes.toList()));
        // print(jsonData[0]['dday']);
        // print(jsonData[0]['week']);

        babyname = utf8.decode(jsonData[0]['babyname'].runes.toList());
        dday = jsonData[0]['dday'];
        week = jsonData[0]['week'];
        // print('babyname은' + babyname);

        exist = '1';
      } else {
        print('비어있습니다.');
        exist = '0';
      }

    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: receiveWeek(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator()
          );
        } else {
          return Scaffold( // 상 중 하를 나누는 위젯
              resizeToAvoidBottomInset: false, // 화면 밀림 방지
              body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
                  child: GestureDetector( // Container와 같이 Gesture를 감지할 수 없는 위젯들에게 Gesture 기능을 부여할 수 있는 위젯
                      child: Column( // 세로 정렬
                          children: [
                            babyname != null ?
                            Padding( // 여백을 주기 위해 사용하는 위젯
                              padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                              child: Container( // 상자 위젯
                                  width: MediaQuery.of(context).size.width * 0.95, // 화면 가로 길이의 95%를 너비로 설정
                                  height: MediaQuery.of(context).size.height * 0.3, // 화면 세로 길이의 30%를 높이로 설정
                                  decoration: BoxDecoration( // 상자 위젯 디자인
                                      border: Border.all(color: Colors.grey, width: 2) // 상자의 테두리 회색, 두께 2
                                  ),
                                  child: Row( // 가로 정렬
                                      mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                                      children: [
                                        Padding( // 여백을 주기 위해 사용하는 위젯
                                            padding: EdgeInsets.all(20), // 모든 면의 여백을 20만큼 줌
                                            child: Image.asset('assets/newborn.png', // 이미지 가져오기
                                                width: MediaQuery.of(context).size.width * 0.38, // 화면 가로 길이의 38%를 너비로 설정
                                                height: MediaQuery.of(context).size.height * 0.45 // 화면 세로 길이의 45%를 높이로 설정
                                            )
                                        ),
                                        Padding( // 여백을 주기 위해 사용하는 위젯
                                          padding: EdgeInsets.all(5), // 모든 면의 여백을 5만큼 줌
                                          child: Container( // 상자 위젯
                                              width: MediaQuery.of(context).size.width * 0.422, // 화면 가로 길이의 42%를 너비로 설정
                                              child: Padding( // 여백을 주기 위해 사용하는 위젯
                                                padding: EdgeInsets.all(5), // 모든 면의 여백을 5만큼 줌
                                                child: Column( // 세로 정렬
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      FittedBox(child: Text(b_babyname[0].toString() + '와', style: TextStyle(color: Colors.grey, fontSize: 25))),
                                                      SizedBox(height: 5),
                                                      FittedBox(child: Text('만남을 기다리기까지', style: TextStyle(color: Colors.grey, fontSize: 25))),
                                                      SizedBox(height: 5),
                                                      FittedBox(child: Text(dday.toString() + '일', style: TextStyle(color: Colors.blue, fontSize: 30))),
                                                      SizedBox(height: 5),
                                                      FittedBox(child: Text('남았습니다.', style: TextStyle(color: Colors.grey, fontSize: 25))),
                                                    ]
                                                ),
                                              )
                                          ),
                                        )
                                      ]
                                  )
                              ),
                            ) :
                            Padding( // 여백을 주기 위해 사용하는 위젯
                              padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                              child: Container( // 상자 위젯
                                width: MediaQuery.of(context).size.width * 0.95, // 화면 가로 길이의 95%만큼 너비를 줌
                                height: MediaQuery.of(context).size.width * 0.55, // 화면 세로 길이의 50%만큼 높이를 줌
                                decoration: BoxDecoration( // 박스 디자인
                                    border: Border.all(color: Colors.grey, width: 2) // 박스 테두리 회색, 두께 2
                                ),
                                child: Column( // 세로정렬
                                  children: [
                                    Padding( // 여백을 주기 위해 사용하는 위젯
                                      padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                      child: Image.asset('assets/baby.png', // 이미지를 불러옴
                                          width: MediaQuery.of(context).size.width * 0.38, // 화면 가로 길이의 38%만큼 너비를 줌
                                          height: MediaQuery.of(context).size.height * 0.2, // 화면 세로 길이의 20%만큼 높이를 줌
                                          color: Colors.grey // 색상은 회색
                                      ),
                                    ),
                                    Text('아기 등록하기', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 색상은 회색, 크기 20, 볼드체
                                  ],
                                ),
                              ),
                            ),
                            Row( // 가로 정렬
                                children: [
                                  Padding( // 여백을 주기 위해 사용하는 위젯
                                      padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Week_Info()));
                                        },
                                        child: Container( // 상자 위젯
                                            width: MediaQuery.of(context).size.width * 0.45, // 화면 가로 길이의 45%만큼 너비를 줌
                                            height: MediaQuery.of(context).size.height * 0.25, // 화면 세로 길이의 25%만큼 높이를 줌
                                            decoration: BoxDecoration( // 박스 디자인
                                                border: Border.all(color: Colors.grey, width: 2) // 화면 테두리 회색, 두께 2
                                            ),
                                            child: Column( // 세로 정렬
                                                children: [
                                                  Padding( // 여백을 주기 위해 사용하는 위젯
                                                      padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                      child: Image.asset('assets/week_baby.png', // 이미지를 불러옴
                                                          width: MediaQuery.of(context).size.width * 0.35, // 화면 가로 길이의 35%만큼 너비를 줌
                                                          height: MediaQuery.of(context).size.height * 0.15, // 화면 높이 길이의 15%만큼 높이를 줌
                                                          color: Colors.grey // 색상은 회색
                                                      )
                                                  ),
                                                  Text('이번주 아기는?', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 글자색은 회색, 크기 20, 볼드체
                                                ]
                                            )
                                        ),
                                      )
                                  ),
                                  Padding( // 여백을 주기 위해 사용하는 위젯
                                      padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                      child: Container( // 상자 위젯
                                          width: MediaQuery.of(context).size.width * 0.45, // 화면 가로 길이의 45%만큼 너비를 줌
                                          height: MediaQuery.of(context).size.height * 0.25, // 화면 세로 길이의 25%만큼 높이를 줌
                                          decoration: BoxDecoration( // 박스 디자인
                                              border: Border.all(color: Colors.grey, width: 2) // 테두리 회색, 두께 2
                                          ),
                                          child: Column( // 세로 정렬
                                              children: [
                                                Padding( // 여백을 주기 위해 사용하는 위젯
                                                    padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                    child: Image.asset('assets/week_mother.png', // 이미지 불러오기
                                                        width: MediaQuery.of(context).size.width * 0.35, // 화면 가로 길이의 35%만큼 너비를 줌
                                                        height: MediaQuery.of(context).size.height * 0.15, // 화면 세로 길이의 15%만큼 높이를 줌
                                                        color: Colors.grey // 색상은 회색
                                                    )
                                                ),
                                                Text('이번주 엄마는?', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 글자색 회색, 크기 20, 볼드체
                                              ]
                                          )
                                      )
                                  )
                                ]
                            )
                          ]
                      )
                  )
              ),
              bottomNavigationBar: BottomAppBar( // 하단 바
                  height: 60, // 높이 60
                  child: Row( // 가로 정렬
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
                      children: [
                        IconButton(
                            onPressed: (){

                            },
                            icon: Icon(Icons.home_outlined, color: Colors.blue)
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum)));
                            },
                            icon: Icon(Icons.event_note_outlined)
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chatBot(userNum: widget.UserNum)));
                            },
                            icon: Icon(Icons.chat_outlined)
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum)));
                            },
                            icon: Icon(Icons.list_alt_outlined)
                        )
                      ]
                  )
              )
          );
        }
      },
    );
  }
}