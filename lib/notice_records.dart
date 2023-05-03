import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notice_records extends StatelessWidget {
  const notice_records({Key? key,required this.userNum, required this.noticeNum }) : super(key: key);

  final userNum;
  final noticeNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoticeRecords(UserNum: userNum, NoticeNum: noticeNum,),
    );
  }
}

class NoticeRecords extends StatefulWidget {
  const NoticeRecords({Key? key, this.UserNum, this.NoticeNum}) : super(key: key);

  final UserNum;
  final NoticeNum;

  @override
  State<NoticeRecords> createState() => _NoticeRecordsState();
}

class _NoticeRecordsState extends State<NoticeRecords> {
  var Notice_ = "공지 내용";
  var Notice_Title = "제목";
  var date_ = "날짜";

  Future<List<dynamic>> notice_() async { // 공지사항 -> 위젯에 표시해주기
    final uri = Uri.parse('http://182.219.226.49/moms/notice-info');
    final headers = {'Content-Type': 'application/json'};

    final noticeNum=widget.NoticeNum;

    final body = jsonEncode({'noticeNum': noticeNum});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData); // 받아온 값 로그찍기
      return jsonData;
    }else{
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
          title: Text('공지사항', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => notice(userNum: widget.UserNum))); // 공지사항항 이지로 이동
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
                      child: Text('${Notice_Title}',style: TextStyle(fontSize: 30),)
                  ),
                  flex: 1,),
                Expanded(
                  child: Container(), flex: 2,
                ),
                Expanded(
                  child: Container(
                      child: Text('${date_}')
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
                  child: Text('${Notice_}'),
                )
            ),
            flex: 5,),
          Expanded(
            child: Container(), flex: 3,
          ),
        ],
      ),
    );
  }
}
