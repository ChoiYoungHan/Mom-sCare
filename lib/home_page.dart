import 'dart:convert';

import 'package:care_application/baby_add.dart';
import 'package:care_application/chatBot.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/week_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({Key? key, required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단의 debug 리본 제거
        home: HomePage(UserNum: userNum, index: index)
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var babyname, week, dday, exist, currentIndex, currentWeek;

  List<String> b_babyname = [];
  List<String> b_expectteddate = [];
  List<String> b_dday = [];
  List<String> b_week = [];

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
      child: FutureBuilder(
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
                              SizedBox(height: 70),
                              b_babyname.isNotEmpty ?
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 2)
                                      ),
                                      child: PageView.builder(
                                        physics: PageScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: b_babyname.length,
                                        controller: PageController(initialPage: widget.index),
                                        itemBuilder: (context, index){
                                          currentWeek = b_week[index];
                                          currentIndex = index;
                                          return Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                width: double.infinity, height: 28,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Color(0xFF3366FF).withOpacity(0.3), Color(0xFF00CCFF).withOpacity(0.3)],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                child: FittedBox(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: '이번주는 임신 ',
                                                      style: TextStyle(color: Colors.grey, fontSize: 18),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: '$currentWeek주차',
                                                          style: TextStyle(color: Colors.blue, fontSize: 20)
                                                        ),
                                                        TextSpan(
                                                          text: ' 입니다.',
                                                          style: TextStyle(color: Colors.grey, fontSize: 18)
                                                        )
                                                      ]
                                                    )
                                                  ),
                                                )
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: Image.asset('assets/newborn.png',
                                                        width: MediaQuery.of(context).size.width * 0.37,
                                                        height: MediaQuery.of(context).size.height * 0.45
                                                      )
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              FittedBox(child: Text(b_babyname[index].toString() + '님과', style: TextStyle(color: Colors.grey, fontSize: 34))),
                                                              SizedBox(height: 5),
                                                              FittedBox(child: Text('만남까지', style: TextStyle(color: Colors.grey, fontSize: 34))),
                                                              SizedBox(height: 5),
                                                              FittedBox(child: Text(b_dday[index].toString() + '일', style: TextStyle(color: Colors.blue, fontSize: 38))),
                                                              SizedBox(height: 5),
                                                              FittedBox(child: Text('남았습니다.', style: TextStyle(color: Colors.grey, fontSize: 34))),
                                                            ]
                                                          )
                                                        )
                                                      )
                                                    )
                                                  ]
                                                )
                                              )
                                            ]
                                          );
                                        }
                                      )
                                  )
                              )
                                  :
                              Padding( // 여백을 주기 위해 사용하는 위젯
                                padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => baby_add(userNum: widget.UserNum, index: currentIndex)));
                                  },
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
                                          child: FittedBox(
                                            fit: BoxFit.contain, // 이미지를 부모 위젯에 맞게 조절
                                            child: Image.asset('assets/baby.png', // 이미지를 불러옴
                                                width: MediaQuery.of(context).size.width * 0.38, // 화면 가로 길이의 38%만큼 너비를 줌
                                                height: MediaQuery.of(context).size.height * 0.18, // 화면 세로 길이의 20%만큼 높이를 줌
                                                color: Colors.grey // 색상은 회색
                                            ),
                                          ),
                                        ),
                                        Text('아기 등록하기', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 색상은 회색, 크기 20, 볼드체
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row( // 가로 정렬
                                  children: [
                                    Padding( // 여백을 주기 위해 사용하는 위젯
                                        padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Week_Info(userNum: widget.UserNum, division: 'baby', week: currentWeek, index: currentIndex)));
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
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Week_Info(userNum: widget.UserNum, division: 'moms', week: currentWeek, index: currentIndex)));
                                          },
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
                                          ),
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
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                      return MyApp(userNum: widget.UserNum, index: widget.index);
                                    },
                                    transitionDuration: Duration(milliseconds: 0)
                                  )
                                );
                              },
                              icon: Icon(Icons.event_note_outlined)
                          ),
                          IconButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                      return chatBot(userNum: widget.UserNum, index: widget.index);
                                    },
                                    transitionDuration: Duration(milliseconds: 0)
                                  )
                                );
                              },
                              icon: Icon(Icons.chat_outlined)
                          ),
                          IconButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                      return my_page(userNum: widget.UserNum, index: widget.index);
                                    },
                                    transitionDuration: Duration(milliseconds: 0)
                                  )
                                );
                              },
                              icon: Icon(Icons.list_alt_outlined)
                          )
                        ]
                    )
                )
            );
          }
        },
      ),
    );
  }
}