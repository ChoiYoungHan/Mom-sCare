import 'dart:convert';

import 'package:care_application/chatBot.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/input_diary.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/print_diary.dart';
import 'package:care_application/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userNum, this.index});

  final userNum, index;

  @override
  Widget build(BuildContext context) {

    print('Calendar_Page에서 받은 ' + userNum);

    return MaterialApp(
      locale: const Locale('ko', 'KR'),
      debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본을 제거
      home: Calendar_Page(UserNum: userNum, index: index)
    );
  }
}

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {

  late DateTime selectedDate = DateTime.now(); // 현재 날짜를 저장할 변수
  DateTime? beforeselectedDate = null; // 이전에 선택한 날짜를 저장할 변수

  var str;

  Future<void> receiveData() async {
    final uri = Uri.parse('http://182.219.226.49/moms/diary');
    final headers = {'Content-Type': 'application/json'};

    final ClientNum = widget.UserNum;
    final diary_date = str;

    final body = jsonEncode({'clientNum': ClientNum, 'diary_date': diary_date});
    final response = await http.post(uri, headers: headers, body: body);

    print(widget.UserNum);
    print(str);

    print('clientNum:'+ ClientNum + 'diary_date:'+ diary_date);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      print(jsonData);

      if(jsonData['success'] == true){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => print_diary(selectedDate: selectedDate, userNum: widget.UserNum, index: widget.index)));
      } else if(jsonData['success'] == false) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => input_diary(selectedDate: selectedDate, userNum: widget.UserNum, index: widget.index)));
      }

    } else {

    }
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
      child: Scaffold( // 상 중 하를 나누는 위젯
          resizeToAvoidBottomInset: false, // 화면 밀림 방지
          appBar: AppBar( // 상단 바
              automaticallyImplyLeading: false, // 뒤로가기 버튼이 자동으로 생성되는 것을 방지
              backgroundColor: Colors.white, // 배경색: 흰색
              title: Text('캘린더', style: TextStyle(color: Colors.grey)), // 제목을 '캘린더'로 한다. 색상은 회색
              actions: [ // 상단바의 우측에 출력
                IconButton( // 아이콘 버튼 위젯
                    onPressed: (){ // 아이콘을 클릭할 경우에 동작할 코드
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Time_Line(userNum: widget.UserNum, index: widget.index)));
                    },
                    icon: Icon(Icons.view_timeline_outlined, color: Colors.orange) // 타임라인 아이콘, 색상은 주황
                )
              ]
          ),
          body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
              child: GestureDetector( // Container와 같이 Gesture를 감지할 수 없는 위젯들에게 Gesture 기능을 부여할 수 있는 위젯
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                      child: Text('원하는 날짜를 선택하여 다이어리를 작성해주세요', style: TextStyle(color: Colors.black, fontSize: 17))
                    ),
                    TableCalendar( // 캘린더 위젯
                      locale: 'ko-KR',
                      firstDay: DateTime.utc(2020, 01, 01), // 달력에서 사용할 수 있는 첫 번째 날짜
                      lastDay: DateTime.utc(2123, 12, 31), // 달력에서 사용할 수 있는 마지막 날짜
                      focusedDay: selectedDate ?? DateTime.now(), // 달력에서 현재 표시되어야 하는 월을 결정하는 현재 목표 날짜
                      onFormatChanged: (format){

                      },

                      // 선택한 날짜 정보를 selectedDay 매개변수로 전달받은 뒤, selectedDate 필드에 저장한다.
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          // beforeselectedDate는 이전에 선택한 날짜를 저장하는 변수이다.
                          if(beforeselectedDate == null){
                            // 만약 beforeselectedDate가 null일 경우, 처음으로 날짜를 선택한 경우이므로 선택한 날짜인 selectedDay를 저장한다.
                            beforeselectedDate = selectedDay;
                          } else if(beforeselectedDate == selectedDay){ // beforeselectedDate에 이미 선택한 날짜 정보가 저장되어 있을 경우, 선택한 날짜가 두 번 클릭되었다는 것을 의미한다.
                            beforeselectedDate = null; // beforeselectedDate 변수를 null로 설정한다.

                            str = selectedDate.toString().substring(0, selectedDate.toString().indexOf(' '));
                            receiveData();
                          } else {
                            beforeselectedDate = selectedDay;
                          }
                          selectedDate = selectedDay; // onDaySelected 함수가 호출 될 때마다 선택한 날짜 정보를 selectedDate에 저장한다.
                        });
                      },
                      // 선택한 날짜와 같은 날짜를 강조 표시하도록 하는 속성
                      selectedDayPredicate: (DateTime date){
                        return isSameDay(date, selectedDate);
                      },
                      // 캘린더의 스타일을 지정하는 속성
                      calendarStyle: CalendarStyle(
                        // 오늘 날짜에 대한 강조 스타일을 변경
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.blue, width: 2)
                        ),
                        // 오늘 날짜의 글자 디자인
                        todayTextStyle: TextStyle(
                          color: Colors.black
                        )
                      )
                    ),
                  ],
                ),
              )
          ),
          bottomNavigationBar: BottomAppBar( // 하단 바
              child: Container( // 상자 위젯
                  height: 60, // 높이 60
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
                      children: [
                        IconButton( // 아이콘 버튼 위젯
                            onPressed: (){ // 버튼 클릭 시 동작할 코드 작성
                              Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                        return Home_Page(userNum: widget.UserNum, index: widget.index);
                                      },
                                      transitionDuration: Duration(milliseconds: 0)
                                  )
                              );
                            },
                            icon: Icon(Icons.home_outlined) // 홈 아이콘
                        ),
                        IconButton( // 아이콘 버튼 위젯
                            onPressed: (){ // 버튼 클릭 시 동작할 코드 작성

                            },
                            icon: Icon(Icons.event_note_outlined, color: Colors.blue) // 다이어리 아이콘
                        ),
                        IconButton( // 아이콘 버튼 위젯
                            onPressed: (){ // 버튼 클릭 시 동작할 코드 작성                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => chatBot(userNum: widget.UserNum)));
                              Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                        return chatBot(userNum: widget.UserNum, index: widget.index);
                                      },
                                      transitionDuration: Duration(milliseconds: 0)
                                  )
                              );
                            },
                            icon: Icon(Icons.chat_outlined) // 채팅 아이콘
                        ),
                        IconButton( // 아이콘 버튼 위젯
                            onPressed: (){ // 버튼 클릭 시 동작할 코드 작성
                              Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                        return my_page(userNum: widget.UserNum, index: widget.index);
                                      },
                                      transitionDuration: Duration(milliseconds: 0)
                                  )
                              );
                            },
                            icon: Icon(Icons.list_alt_outlined) // 리스트 아이콘
                        )
                      ]
                  )
              )
          )
      ),
    );
  }
}