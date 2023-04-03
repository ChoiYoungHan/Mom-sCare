import 'package:care_application/home_page.dart';
import 'package:care_application/input_diary.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false, // 우측 상단에 출력되는 Debug 리본을 제거
      home: Calendar_Page()
    );
  }
}

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({Key? key}) : super(key: key);

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {

  late DateTime selectedDate = DateTime.now(); // 현재 날짜를 저장할 변수
  DateTime? beforeselectedDate = null; // 이전에 선택한 날짜를 저장할 변수


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 배경색: 흰색
        title: Text('캘린더', style: TextStyle(color: Colors.grey)) // 제목을 '캘린더'로 한다. 색상은 회색
      ),
      body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
        child: GestureDetector( // Container와 같이 Gesture를 감지할 수 없는 위젯들에게 Gesture 기능을 부여할 수 있는 위젯
          child: TableCalendar( // 캘린더 위젯
            firstDay: DateTime.utc(2020, 01, 01), // 달력에서 사용할 수 있는 첫 번째 날짜
            lastDay: DateTime.utc(2123, 12, 31), // 달력에서 사용할 수 있는 마지막 날짜
            focusedDay: DateTime.now(), // 달력에서 현재 표시되어야 하는 월을 결정하는 현재 목표 날짜

            // 선택한 날짜 정보를 selectedDay 매개변수로 전달받은 뒤, selectedDate 필드에 저장한다.
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                // beforeselectedDate는 이전에 선택한 날짜를 저장하는 변수이다.
                if(beforeselectedDate == null){
                  // 만약 beforeselectedDate가 null일 경우, 처음으로 날짜를 선택한 경우이므로 선택한 날짜인 selectedDay를 저장한다.
                  beforeselectedDate = selectedDay;
                } else if(beforeselectedDate == selectedDay){ // beforeselectedDate에 이미 선택한 날짜 정보가 저장되어 있을 경우, 선택한 날짜가 두 번 클릭되었다는 것을 의미한다.
                  beforeselectedDate = null; // beforeselectedDate 변수를 null로 설정한다.
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => input_diary(selectedDate: selectedDate)));
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page()));
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
