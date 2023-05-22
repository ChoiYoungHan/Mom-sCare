import 'dart:convert';
import 'package:care_application/notice.dart';
import 'package:http/http.dart' as http;

import 'package:care_application/edit.dart';
import 'package:care_application/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question_records extends StatelessWidget {
  const question_records({Key? key,required this.userNum, required this.inquireNum}) : super(key: key);

  final userNum;
  final inquireNum;

  @override
  Widget build(BuildContext context) {
    print("question_records 페이지");
    print(userNum);
    print("unquireNum는 ");
    print(inquireNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: QuestionRecords(UserNum: userNum,InquireNum: inquireNum,)
    );
  }
}

class QuestionRecords extends StatefulWidget {
  const QuestionRecords({Key? key, this.UserNum, this.InquireNum}) : super(key: key);
  final InquireNum;
  final UserNum;

  @override
  State<QuestionRecords> createState() => _QuestionRecordsState();
}

class _QuestionRecordsState extends State<QuestionRecords> {
  //보류 변수
  var Question_;
  var Answer;
  var Question_Title;
  var date_;

  late List<dynamic> inquire;
  Future inquire_() async{ // 문의사항 -> 위젯에 표시해줘야함
    final uri = Uri.parse('http://182.219.226.49/moms/inquire-info');
    final header = {'Content-Type': 'application/json'};

    final clientNum=widget.UserNum;
    final inquireNum=widget.InquireNum;

    final body = jsonEncode({'clientNum': clientNum, 'inquireNo': inquireNum});
    final response = await http.post(uri, headers: header, body: body);

    final Data=jsonDecode(response.body);
    inquire=Data;
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return 1;
    } else{
      print(response.statusCode.toString());
      return 0;
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question(userNum: widget.UserNum))); // 문의하기 페이지로 이동
            }, icon: Icon(Icons.arrow_back, color: Colors.black,),
            )
        ),
        body:
        FutureBuilder(
            future: inquire_(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Column(
                  children: [
                    Expanded(
                      child: Container(), flex: 1,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(), flex: 2,
                          ),
                          Expanded(
                            child: Container(
                                child: Align(alignment:Alignment.centerLeft,child: FittedBox(fit: BoxFit.scaleDown,child: Text('${inquire[0]['TITLE']}',style: TextStyle(fontSize: 30),)))
                            ),
                            flex: 5,),
                          Expanded(
                            child: Container(), flex: 1,
                          ),
                          Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(),flex: 1,
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text('${inquire[0]['INQUIRE_DATE']}', )
                                        )
                                    ),flex: 3,
                                  )
                                ],
                              ),
                            flex: 2,),
                          Expanded(
                            child: Container(), flex: 2,
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
                            child: Text('${inquire[0]['CONTENT']}'),
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
                            child: Text('${inquire[0]['REPLY']}'),
                          )
                      ),
                      flex: 2,),
                    Expanded(
                      child: Container(), flex: 3,
                    ),
                  ],
                );
              } else if(snapshot.hasError){ // 데이터가 존재하지 않거나 에러가 발생 시
                return Center(child: Text('공지사항을 등록해주세요',style: TextStyle(color: Colors.black),));
              }
              return Center(child: const CircularProgressIndicator(color: Colors.grey,),); // 데이터를 불러오는 동안 보여주는 화면 (버퍼링 위젯)
            }
        )
    );
  }
}