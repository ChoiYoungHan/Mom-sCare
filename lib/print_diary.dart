import 'package:flutter/material.dart';

class print_diary extends StatelessWidget {
  final DateTime selectedDate;

  const print_diary({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: printdiary_Page(selectedDate: selectedDate)
    );
  }
}

class printdiary_Page extends StatefulWidget {
  const printdiary_Page({Key? key, required this.selectedDate}) : super(key: key);

  final DateTime selectedDate;

  @override
  State<printdiary_Page> createState() => _printdiary_PageState();
}

class _printdiary_PageState extends State<printdiary_Page> {

  TextEditingController _controller = TextEditingController();
  String _content = '위 코드에서는 _controller 변수를 TextEditingController 객체로 초기화하고, _defaultText 변수에 기본값을 할당합니다. 그리고 _controller 객체의 text 속성에 _defaultText 값을 할당하여 기본값을 설정합니다. 이후 TextField 위젯의 controller 속성에 _controller 변수를 할당하여 TextField 위젯과 바인딩합니다.';


  @override
  Widget build(BuildContext context) {

    _controller.text = _content;

    return Scaffold(
      resizeToAvoidBottomInset: false, // 화면이 밀려 올라가는 것을 방지
      appBar: AppBar(
          backgroundColor: Colors.white, // 상단바 배경 흰색
          leading: IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.arrow_back, color: Colors.grey)
          ),
          title: Text(
              '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일', style: TextStyle(color: Colors.grey) // 받아온 날짜 출력 & 글자 색은 회색
          ),
          actions: [
            TextButton(
                onPressed: (){

                },
                child: Text('수정', style: TextStyle(color: Colors.orange)))
          ]
      ),
      body: SafeArea(
          child: GestureDetector(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                        controller: _controller,
                        maxLines: 23,
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            )
                        )
                    ),
                  ), flex: 8),
                  Expanded(child: Container(
                    padding: EdgeInsets.all(5), // 네 면의 여백을 5만큼 줌
                    width: MediaQuery.of(context).size.width * 0.97,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index){
                          return Container(
                              margin: EdgeInsets.all(3),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset('', fit: BoxFit.cover)
                          );
                        }
                    ),

                  ), flex: 2)
                ],
              )
          )
      ),
    );
  }
}

