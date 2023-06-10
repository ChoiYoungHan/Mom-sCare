import 'dart:convert';

import 'package:care_application/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Week_Info extends StatelessWidget {
  const Week_Info({Key? key, required this.userNum, required this.division, required this.week, this.index}) : super(key: key);

  final userNum, division, week, index;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 debug 리본 제거
        home: WeekInfo(userNum: userNum, division: division, week: week, index: index)
    );
  }
}

class WeekInfo extends StatefulWidget {
  const WeekInfo({Key? key, required this.userNum, required this.division, required this.week, this.index}) : super(key: key);
  final userNum, division, week, index;

  @override
  State<WeekInfo> createState() => _WeekInfoState();
}

class _WeekInfoState extends State<WeekInfo> {
  List<String> baby_info = [];
  List<String> baby_evenIndex = [];
  List<String> baby_oddIndex = [];
  List<String> moms_info = [];
  List<String> moms_evenIndex = [];
  List<String> moms_oddIndex = [];
  List<String> todo_info = [];
  List<String> todo_evenIndex = [];
  List<String> todo_oddIndex = [];

  bool check = true;

  Future<void> receiveBabyInfo() async {
    if(widget.week == null){
      check = false;

      setState(() {

      });
    }

    final uri = Uri.parse('http://182.219.226.49/moms/week-info-baby');
    final headers = {'Content-Type': 'application/json'};

    final week = widget.week;

    final body = jsonEncode({'week': week});

    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      baby_info.clear();
      baby_evenIndex.clear();
      baby_oddIndex.clear();

      jsonData.forEach((element){
        String encodedName = element['info'];
        String decodedName = utf8.decode(encodedName.runes.toList());

        // ':'을 구분자로 사용하여 문자열을 분할하여 배열에 저장
        List<String> splitValues = decodedName.split(' : ');

        // 분할된 값들을 원하는 형태로 가공하여 저장하거나 사용
        for (String value in splitValues) {
          baby_info.add(value);
        }
      });

      for (int i = 0; i < baby_info.length; i++) {
        if (i % 2 == 0) {
          baby_evenIndex.add(baby_info[i]);
        } else {
          baby_oddIndex.add(baby_info[i]);
        }
      }


    } else {

    }
  }

  Future<void> receiveMomInfo() async {
    if(widget.week == null){
      check = false;

      setState(() {

      });
    }
    final uri = Uri.parse('http://182.219.226.49/moms/week-info-moms');
    final headers = {'Content-Type': 'application/json'};

    final week = widget.week;

    final body = jsonEncode({'week': week});

    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      moms_info.clear();
      moms_evenIndex.clear();
      moms_oddIndex.clear();

      jsonData.forEach((element){
        String encodedName = element['info'];
        String decodedName = utf8.decode(encodedName.runes.toList());

        // ':'을 구분자로 사용하여 문자열을 분할하여 배열에 저장
        List<String> splitValues = decodedName.split(' : ');

        // 분할된 값들을 원하는 형태로 가공하여 저장하거나 사용
        for (String value in splitValues) {
          moms_info.add(value);
        }
      });

      for (int i = 0; i < moms_info.length; i++) {
        if (i % 2 == 0) {
          moms_evenIndex.add(moms_info[i]);
        } else {
          moms_oddIndex.add(moms_info[i]);
        }
      }

      await receiveTodo();

    } else {

    }
  }

  Future<void> receiveTodo() async {
    final uri = Uri.parse('http://182.219.226.49/moms/week-info-todo');
    final headers = {'Content-Type': 'application/json'};

    final week = widget.week;

    final body = jsonEncode({'week': week});

    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      todo_info.clear();
      todo_evenIndex.clear();
      todo_oddIndex.clear();

      jsonData.forEach((element){
        String encodedName = element['info'];
        String decodedName = utf8.decode(encodedName.runes.toList());

        // ':'을 구분자로 사용하여 문자열을 분할하여 배열에 저장
        List<String> splitValues = decodedName.split(' : ');

        // 분할된 값들을 원하는 형태로 가공하여 저장하거나 사용
        for (String value in splitValues) {
          todo_info.add(value);
        }
      });

      for (int i = 0; i < todo_info.length; i++) {
        if (i % 2 == 0) {
          todo_evenIndex.add(todo_info[i]);
        } else {
          todo_oddIndex.add(todo_info[i]);
        }
      }

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.userNum, index: widget.index)));

        return false;
      },
      child: FutureBuilder(
          future: widget.division == 'moms' ? receiveMomInfo() : receiveBabyInfo(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator()
              );
            } else {
              return check ? Scaffold( // 상 중 하를 나누는 위젯
                  appBar: AppBar( // 상단 바
                      backgroundColor: Colors.white,
                      leading: IconButton( // 아이콘 버튼 위젯
                          onPressed: (){ // 뒤로가기 버튼 클릭 시 수행할 동작
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.userNum, index: widget.index)));
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 버튼, 회색
                      ),
                      title: widget.division == 'moms' ?
                      Text(widget.week + '주의 엄마는?', style: TextStyle(color: Colors.black)) :
                      Text(widget.week + '주의 아기는?', style: TextStyle(color: Colors.black))
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (widget.week == '1' || widget.week == '2')
                              Center(
                                child: Text(widget.week + '주차의 정보는 표기되지 않습니다.'),
                              )
                            else if (widget.division == 'moms')
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(4, 5, 0, 0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '엄마의 변화',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: moms_evenIndex.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                            child: Text(
                                              moms_evenIndex[index],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              moms_oddIndex[index],
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  if (todo_info.isNotEmpty)
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '엄마와 아빠가 해야할 일',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: todo_evenIndex.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                                  child: Text(
                                                    todo_evenIndex[index],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    todo_oddIndex[index],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            else
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: baby_evenIndex.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                        child: Text(
                                          baby_evenIndex[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          baby_oddIndex[index],
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  )

              ) : Scaffold(
                appBar: AppBar( // 상단 바
                  backgroundColor: Colors.white,
                  leading: IconButton( // 아이콘 버튼 위젯
                    onPressed: (){ // 뒤로가기 버튼 클릭 시 수행할 동작
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.userNum, index: widget.index)));
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 버튼, 회색
                  )
                ),
                body: Center(
                  child: Text(
                    '아기를 먼저 등록해주세요.',
                    style: TextStyle(
                      color: Colors.black
                    )
                  ),
                )
              );
            }
          }
      ),
    );
  }
}

