import 'dart:convert';
import 'dart:math';

import 'package:care_application/home_page.dart';
import 'package:care_application/input_diary.dart';
import 'package:care_application/print_diary.dart';
import 'package:care_application/timeline.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userNum});

  final userNum;

  @override
  Widget build(BuildContext context) {

    print('Calendar_Page에서 받은 ' + userNum);

    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본을 제거
        home: Calendar_Page(UserNum: userNum)
    );
  }
}

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {

  late DateTime selectedDate = DateTime.now(); // 현재 날짜를 저장할 변수
  DateTime? beforeselectedDate = null; // 이전에 선택한 날짜를 저장할 변수

  var str;

  void showAddAlarm(BuildContext context) async {
    // 선택한 날짜와 시간, 일정 내용을 저장할 변수
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    String schedule = '';

    // 팝업을 띄운 뒤 캘린더에서 선택한 날짜를 저장한다.
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder( // setState함수가 호출될 때 팝업도 다시 빌드하기 위해 사용
              builder: (BuildContext context, StateSetter setState){
                return Container( // 상자 위젯
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Column( // 세로 정렬
                        children: [
                          Card( // 카드 위젯
                            child: ListTile( // 리스트 타일 위젯
                              title: Text('날짜 선택'), // 텍스트 '날짜 선택' 출력
                              subtitle: Text("${DateFormat('yyyy/MM/dd').format(selectedDate)}"), // 아래에 선택한 날짜 정보를 출력
                              onTap: () async {
                                final DateTime ? pickedDate = await showDatePicker( // showDatePicker 함수를 호출하여 팝업 창을 띄움
                                    context: context,
                                    initialDate: selectedDate, // 팝업이 띄워졌을 때, 초기화하는 날짜 값
                                    firstDate: DateTime.utc(2020, 12, 31), // 선택 가능한 가장 빠른 날짜
                                    lastDate: DateTime.utc(2123, 12, 31) // 선택 가능한 가장 늦은 날짜
                                );

                                // 팝업에서 선택한 날짜가 현재 선택된 날짜와 다르다면, selectedDate를 업데이트함
                                if(pickedDate != null && pickedDate != selectedDate){
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                            ),
                          ),
                          Card(
                              child: ListTile(
                                title: TextField(
                                    decoration: InputDecoration(hintText: '일정을 입력해주세요.'),
                                    onChanged: (value){
                                      setState((){
                                        schedule = value;
                                      });
                                    }
                                ),
                              )
                          ),
                          Card(
                              child: ListTile(
                                title: Text('시간 등록'),
                                subtitle: Text("${selectedTime.hour.toString().padLeft(2, '0')}시${selectedTime.minute.toString().padLeft(2, '0')}분"),
                                onTap: () async {
                                  final TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime
                                  );

                                  if(pickedTime != null && pickedTime != selectedTime){
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ElevatedButton(
                                onPressed: (){

                                },
                                child: Text('완료'),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))
                                ),
                              )
                          )
                        ]
                    )
                );
              }
          );
        }
    );
  }

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

      if(jsonData['success'] == true){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => print_diary(selectedDate: selectedDate, userNum: widget.UserNum)));
      } else if(jsonData['success'] == false) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => input_diary(selectedDate: selectedDate, userNum: widget.UserNum)));
      }

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 상 중 하를 나누는 위젯
        resizeToAvoidBottomInset: false, // 화면 밀림 방지
        appBar: AppBar( // 상단 바
            automaticallyImplyLeading: false, // 뒤로가기 버튼이 자동으로 생성되는 것을 방지
            backgroundColor: Colors.white, // 배경색: 흰색
            title: Text('캘린더', style: TextStyle(color: Colors.grey)), // 제목을 '캘린더'로 한다. 색상은 회색
            actions: [ // 상단바의 우측에 출력
              IconButton( // 아이콘 버튼 위젯
                  onPressed: (){ // 아이콘을 클릭할 경우에 동작할 코드
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Time_Line(userNum: widget.UserNum)));
                  },
                  icon: Icon(Icons.view_timeline_outlined, color: Colors.orange) // 타임라인 아이콘, 색상은 주황
              ),
              IconButton(
                  onPressed: (){
                    showAddAlarm(context);
                  },
                  icon: Icon(Icons.alarm_rounded, color: Colors.orange)
              )
            ]
        ),
        body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
            child: GestureDetector( // Container와 같이 Gesture를 감지할 수 없는 위젯들에게 Gesture 기능을 부여할 수 있는 위젯
              child: TableCalendar( // 캘린더 위젯
                  firstDay: DateTime.utc(2020, 01, 01), // 달력에서 사용할 수 있는 첫 번째 날짜
                  lastDay: DateTime.utc(2123, 12, 31), // 달력에서 사용할 수 있는 마지막 날짜
                  focusedDay: selectedDate ?? DateTime.now(), // 달력에서 현재 표시되어야 하는 월을 결정하는 현재 목표 날짜

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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.UserNum), settings: RouteSettings(arguments: widget.UserNum)));
                          },
                          icon: Icon(Icons.home_outlined) // 홈 아이콘
                      ),
                      IconButton( // 아이콘 버튼 위젯
                          onPressed: (){ // 버튼 클릭 시 동작할 코드 작성

                          },
                          icon: Icon(Icons.event_note_outlined, color: Colors.blue) // 다이어리 아이콘
                      ),
                      IconButton( // 아이콘 버튼 위젯
                          onPressed: (){ // 버튼 클릭 시 동작할 코드 작성

                          },
                          icon: Icon(Icons.chat_outlined) // 채팅 아이콘
                      ),
                      IconButton( // 아이콘 버튼 위젯
                          onPressed: (){ // 버튼 클릭 시 동작할 코드 작성

                          },
                          icon: Icon(Icons.list_alt_outlined) // 리스트 아이콘
                      )
                    ]
                )
            )
        )
    );
  }
}