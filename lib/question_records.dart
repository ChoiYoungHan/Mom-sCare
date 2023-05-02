import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/edit.dart';
import 'package:care_application/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question_records extends StatelessWidget {
  const question_records({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionRecords(UserNum: userNum,)
    );
  }
}

class QuestionRecords extends StatefulWidget {
  const QuestionRecords({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<QuestionRecords> createState() => _QuestionRecordsState();
}

class _QuestionRecordsState extends State<QuestionRecords> {
  var Question_='질문 내용'; // 질문 내용
  var Answer='답변 내용'; // 답변 내용
  var Question_Title='제목';
  var date_='날짜';

  Future<List<dynamic>> inquire_() async{ // 문의사항 -> 위젯에 표시해줘야함
    final uri = Uri.parse('http://182.219.226.49/moms/inquire');
    final header = {'Content-Type': 'application/json'};

    final clientNum=widget.UserNum;

    final body = jsonEncode({'clientNum': '64'});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else{
      print(response.statusCode.toString());
      throw Exception('Fail'); // 오류 발생시 예외발생(return에 null반환이 안되게 해서 해줘야함)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의내역', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => question(userNum: widget.UserNum))); // 문의하기 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(), flex: 1,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(), flex: 1,
                ),
                Expanded(
                  child: Container(
                      child: Text('${Question_Title}',style: TextStyle(fontSize: 30),)
                  ),
                flex: 1,),
                Expanded(
                  child: Container(), flex: 2,
                ),
                Expanded(
                  child: Container(
                      child: Text('${date_}', )
                  ),
                  flex: 1,),
                Expanded(
                  child: Container(), flex: 1,
                ),
              ],
            ),
            flex: 1,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width*0.7, // 위젯의 높이를 화면 너비로 동일설정
              decoration: BoxDecoration(
                border: Border.all(
                    width:1
                )
              ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('${Question_}'),
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(), flex: 1,
          ),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width*0.7, // 위젯의 높이를 화면 너비로 동일설정
                decoration: BoxDecoration(
                    border: Border.all(
                        width:1
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('${Answer}'),
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(), flex: 3,
          ),
        ],
      ),
    );
  }
}
