import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notice_records extends StatelessWidget {
  const notice_records({Key? key,required this.userNum, required this.noticeNum, this.index}) : super(key: key);

  final userNum, index;
  final noticeNum;

  @override
  Widget build(BuildContext context) {
    print("notice_records 페이지");
    print(userNum);
    print(" noticeNum 는:");
    print(noticeNum);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoticeRecords(UserNum: userNum, NoticeNum: noticeNum, index: index)
    );
  }
}

class NoticeRecords extends StatefulWidget {
  const NoticeRecords({Key? key, this.UserNum, this.NoticeNum, this.index}) : super(key: key);

  final UserNum, index;
  final NoticeNum;

  @override
  State<NoticeRecords> createState() => _NoticeRecordsState();
}

class _NoticeRecordsState extends State<NoticeRecords> {
  var Notice_;
  var Notice_Title;
  var date_;
  late List<dynamic> notice_info;
  Future notice_() async { // 공지사항 내용 출력 함수
    final uri = Uri.parse('http://182.219.226.49/moms/notice-info');
    final headers = {'Content-Type': 'application/json'};

    print(widget.NoticeNum);

    final noticeNum=widget.NoticeNum;

    final body = jsonEncode({'noticeNo': noticeNum});
    final response = await http.post(uri, headers: headers, body: body);

    var Data= jsonDecode(response.body);
    notice_info=Data;
    Notice_ = notice_info[0]['CONTENT'];
    Notice_Title = notice_info[0]['TITLE'];
    date_ = notice_info[0]['CONTENT_DATE'];

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData); // 받아온 값 로그찍기
      return 1;
    }else{
      print(response.statusCode.toString());
      //throw Exception('Fail'); // 오류 발생시 예외발생(return에 null반환이 안되게 해서 해줘야함)
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => notice(userNum: widget.UserNum, index: widget.index)));

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
              backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
              title: Text('공지사항', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
              leading: IconButton(onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => notice(userNum: widget.UserNum, index: widget.index))); // 공지사항 페이지로 이동
              }, icon: Icon(Icons.arrow_back, color: Colors.black),
              )
          ),
          body: FutureBuilder(
            future: notice_(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Column(
                  children: [
                    Expanded(
                      child: Container(), flex: 1
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(), flex: 1
                          ),
                          Expanded(
                            child: Container(
                                child: FittedBox(child: Text('${Notice_Title}',style: TextStyle(fontSize: 30)))
                            ),
                            flex: 1,),
                          Expanded(
                            child: Container(), flex: 2
                          ),
                          Expanded(
                            child: Container(
                                child: FittedBox(child: Text('${date_}'))
                            ),
                            flex: 1,),
                          Expanded(
                            child: Container(), flex: 1
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
                            padding: const EdgeInsets.all(10), // 모든 여백 10 부여
                            child: Text('${Notice_}'),
                          )
                      ),
                      flex: 5,),
                    Expanded(
                      child: Container(), flex: 3,
                    ),
                  ],
                );
              } else if(snapshot.hasError){
                return Center(child: Text('등록된 공지사항이 없습니다.',style: TextStyle(color: Colors.black),));
              }
              return Center(child: const CircularProgressIndicator(color: Colors.grey,),); // 데이터를 불러오는 동안 보여주는 화면 (버퍼링 위젯)
            },
          )
      ),
    );
  }
}