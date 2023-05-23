import 'dart:convert';

import 'package:care_application/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Week_Info extends StatelessWidget {
  const Week_Info({Key? key, required this.userNum, required this.division, required this.week}) : super(key: key);

  final userNum, division, week;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 debug 리본 제거
        home: WeekInfo(userNum: userNum, division: division, week: week)
    );
  }
}

class WeekInfo extends StatefulWidget {
  const WeekInfo({Key? key, required this.userNum, required this.division, required this.week}) : super(key: key);
  final userNum, division, week;

  @override
  State<WeekInfo> createState() => _WeekInfoState();
}

class _WeekInfoState extends State<WeekInfo> {

  List<String> info = [];
  List<String> info_info = [];
  List<String> evenIndex = [];
  List<String> oddIndex = [];
  List<String> Characteristic = [];

  Future<void> receiveSymptom() async {
    final uri = Uri.parse('http://182.219.226.49/moms/week-info-symptom');
    final headers = {'Content-Type': 'application/json'};

    final week = '1';
    final division = 'moms';

    final body = jsonEncode({'week': week, 'division' : division});

    print(week);

    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      evenIndex.clear();
      oddIndex.clear();

      jsonData.forEach((element){
        String encodedName = element['info'];
        String decodedName = utf8.decode(encodedName.runes.toList());

        // ':'을 구분자로 사용하여 문자열을 분할하여 배열에 저장
        List<String> splitValues = decodedName.split(' : ');

        // 분할된 값들을 원하는 형태로 가공하여 저장하거나 사용
        for (String value in splitValues) {
          info.add(value);
        }
      });

      for (int i = 0; i < info.length; i++) {
        if (i % 2 == 0) {
          evenIndex.add(info[i]);
        } else {
          oddIndex.add(info[i]);
        }
      }

      print(evenIndex);
      print(oddIndex);
      // print(info);
    } else {
    }
  }

  Future<void> receiveCharacteristic() async {
    final uri = Uri.parse('http://182.219.226.49/moms/week-info-characteristic');
    final headers = {'Content-Type': 'application/json'};

    final week = '1';
    final division = 'moms';

    final body = jsonEncode({'week': week, 'division' : division});

    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      await receiveSymptom();
      var jsonData = jsonDecode(response.body);

      Characteristic.add(utf8.decode(jsonData[0]['info'].runes.toList()));

      print('정보 전달 성공');
    } else {
      print('정보 전달 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: receiveCharacteristic(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: CircularProgressIndicator()
            );
          } else {
            return Scaffold( // 상 중 하를 나누는 위젯
                appBar: AppBar( // 상단 바
                    backgroundColor: Colors.white,
                    leading: IconButton( // 아이콘 버튼 위젯
                        onPressed: (){ // 뒤로가기 버튼 클릭 시 수행할 동작
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.userNum)));
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 버튼, 회색
                    ),
                    title: widget.division == 'moms' ? // 삼항 연산자, baby_mom의 값이 1이면
                    Text(widget.week + '주의 엄마는?', style: TextStyle(color: Colors.black)) :
                    Text(widget.week + '주의 아기는?', style: TextStyle(color: Colors.black))
                ),
                body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                        child: Text('특징',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    )
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                                child: Container(
                                    child: Text.rich(
                                        TextSpan(
                                            text: Characteristic[0],
                                            style: TextStyle(color: Colors.black, fontSize: 14)
                                        )
                                    )
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(7, 10, 0, 0),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                        child: Text('나타날 수 있는 증상',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    )
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: evenIndex.length,
                                    itemBuilder: (context, index){
                                      return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                                child: Text(
                                                    evenIndex[index],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                    oddIndex[index],
                                                    style: TextStyle(
                                                        fontSize: 13
                                                    )
                                                )
                                            )
                                          ]
                                      );
                                    }
                                ),
                              )
                            ]
                        )
                    )
                )
            );
          }
        }
    );
  }
}

