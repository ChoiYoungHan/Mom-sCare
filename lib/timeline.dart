import 'package:care_application/main.dart';
import 'package:flutter/material.dart';

class Time_Line extends StatelessWidget {
  const Time_Line({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 debug 리본 제거
        home: TimeLine()
    );
  }
}

class TimeLine extends StatefulWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {

  List<String> image = ['assets/baby.png', 'assets/camera.png', 'assets/gallery.png', 'assets/newborn.png', 'assets/week_baby.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // 화면이 밀려 올라가는 것을 방지
        appBar: AppBar( // 상단 바
            backgroundColor: Colors.white, // 배경은 흰색
            leading: IconButton( // 아이콘 버튼 위젯
                onPressed: (){ // 아이콘 클릭 시 동작할 코드 구현
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 버튼, 회색
            ),
            title: Text('타임라인', style: TextStyle(color: Colors.grey)) // '타임라인' 문구 출력, 회색
        ),
        body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
            child: Padding( // 여백을 주기 위해 사용하는 위젯
              padding: EdgeInsets.all(5), // 모든 면의 여백을 5만큼 줌
              child: Container( // 상자 위젯
                  child: ListView.builder( // 리스트뷰 위젯
                      itemCount: 9, // 리스트아이템 개수
                      itemBuilder: (context, index){
                        return Padding( // 여백을 주기 위해 사용하는 위젯
                          padding: EdgeInsets.symmetric(horizontal: 5), // 좌 우에 5만큼의 여백을 줌
                          child: Container( // 상자 위젯
                              child: Column( // 세로 정렬
                                  children: [
                                    Container( // 상자 위젯
                                        height: 25, // 높이 25
                                        child: Row( // 가로 정렬
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정한 간격을 두고 정렬
                                            children: [
                                              Container( // 상자 위젯
                                                  width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%만큼 너비를 설정
                                                  height: 2, // 높이 2
                                                  decoration: BoxDecoration( // 상자 위젯 디자인
                                                      border: Border(bottom: BorderSide(color: Colors.grey, width: 2)) // 아래 테두리, 회색, 두께 2
                                                  )
                                              ),
                                              Container( // 상자 위젯
                                                  width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%만큼 너비를 설정
                                                  child: Center( // 가운데 정렬 위젯
                                                      child: Text('2023년 04월 06일', style: TextStyle(color: Colors.grey, fontSize: 15) // 회색, 크기 15
                                                      )
                                                  )
                                              ),
                                              Container( // 상자 위젯
                                                  width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%만큼 너비를 설정
                                                  height: 2, // 높이 2
                                                  decoration: BoxDecoration( // 상자 위젯 디자인
                                                      border: Border(bottom: BorderSide(color: Colors.grey, width: 2)) // 아래 테두리, 회색, 두께 2
                                                  )
                                              )
                                            ]
                                        )
                                    ),
                                    Padding( // 여백을 주기 위해 사용하는 위젯
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0), // 아래 5의 여백을 줌
                                      child: Container( // 상자 위젯
                                          width: MediaQuery.of(context).size.width * 0.93, // 화면 가로 길이의 93%만큼 너비를 줌
                                          height: MediaQuery.of(context).size.height * 0.2, // 화면 세로 길이의 20%만큼 높이를 줌
                                          child: ListView.builder( // 리스트뷰 위젯
                                              scrollDirection: Axis.horizontal, // 리스트뷰를 가로로 함
                                              itemCount: 5,
                                              itemBuilder: (context, index){
                                                return Container( // 상자 위젯
                                                    margin: EdgeInsets.all(2), // 모든 면의 마진을 2만큼 줌
                                                    width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%만큼 너비로 설정
                                                    height: MediaQuery.of(context).size.height * 0.2, // 화면 세로 길이의 20%만큼 높이로 설정
                                                    decoration: BoxDecoration( // 상자 위젯 디자인
                                                        border: Border.all(color: Colors.grey, width: 1)
                                                    ),
                                                    child: Image.asset(image[index], fit: BoxFit.cover) // 배열의 크기만큼
                                                );
                                              }
                                          )
                                      ),
                                    )
                                  ]
                              )
                          ),
                        );
                      }
                  )
              ),
            )
        )
    );
  }
}

