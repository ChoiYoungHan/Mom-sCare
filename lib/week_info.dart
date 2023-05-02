import 'package:care_application/home_page.dart';
import 'package:flutter/material.dart';

class Week_Info extends StatelessWidget {
  const Week_Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 debug 리본 제거
        home: WeekInfo()
    );
  }
}

class WeekInfo extends StatefulWidget {
  const WeekInfo({Key? key}) : super(key: key);

  @override
  State<WeekInfo> createState() => _WeekInfoState();
}

class _WeekInfoState extends State<WeekInfo> {

  int baby_mom = 1;

  String baby = '20', mom = '20';

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 상 중 하를 나누는 위젯
        appBar: AppBar( // 상단 바
            backgroundColor: Colors.white,
            leading: IconButton( // 아이콘 버튼 위젯
                onPressed: (){ // 뒤로가기 버튼 클릭 시 수행할 동작
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page()));
                },
                icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 버튼, 회색
            ),
            title: baby_mom == 0 ? // 삼항 연산자, baby_mom의 값이 1이면
            Text(baby + '주의 아기는?', style: TextStyle(color: Colors.grey)) :
            Text(mom + '주의 엄마는?', style: TextStyle(color: Colors.grey))
        ),
        body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
            child: Column( // 세로 정렬
                children: [
                  Padding(
                    padding: EdgeInsets.all(5), // 모든 면의 여백을 5만큼 줌
                    child: Center( // 가운데 정렬
                        child: Text('"' + '배가 눈에 띄게 된다' + '"', style: TextStyle(color: Colors.grey, fontSize: 25)) // 텍스트 색상은 회색, 크기 25
                    ),
                  ),
                  Padding( // 여백을 주기 위해 사용하는 위젯
                      padding: EdgeInsets.all(5), // 모든 면의 여백을 5만큼 줌
                      child: Text('임신 20주차가 되면 배가 눈에 띄게 커지게 됩니다. \n임신 20주 즈음의 자궁 크기는 어른의 머리보다 조금 큰 정도입니다. 신 전과 같은 옷을 입고 있던 엄마도 배를 조이지 않도록 ',
                          style: TextStyle(fontSize: 15, color: Colors.grey) // 텍스트 색상은 회색, 크기 15
                      )
                  )
                ]
            )
        )
    );
  }
}

