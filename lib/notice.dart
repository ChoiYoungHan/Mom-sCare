import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/edit.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/notice_records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notice extends StatelessWidget {
  const notice({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    print("notice 페이지");
    print(userNum);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notice(UserNum: userNum,),
    );
  }
}

class Notice extends StatefulWidget {
  const Notice({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

  var noticeNum;

  Future<List<dynamic>> notice_() async { // 공지사항 출력 함수
    final uri = Uri.parse('http://182.219.226.49/moms/notice');
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(uri, headers: headers);

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
          title: Text('공지사항', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 회색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum))); // 마이페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 1, // 상단 여백 1 부여
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: notice_(),
              builder: (context, snapshot){
                if(snapshot.hasData){ // 공지사항이 존재할 시
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Container(
                          width: 120,
                          height: 50,
                          child: OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  noticeNum = snapshot.data![index]['NOTICENO']; // 클릭한 공지사항의 번호를 입력 받는다
                                });
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => notice_records(userNum: widget.UserNum, noticeNum: noticeNum,))); // 공지내용으로 이동
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("${index+1}",style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의번호가 적힌 버튼,
                                    flex: 1,), // 공간 1 부여
                                  Expanded(
                                    child: Text('${snapshot.data![index]['TITLE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 제목이 적힌 버튼,
                                    flex: 3,), // 공간 3 부여
                                  Expanded(
                                    child: Container(),flex: 2, // 중간 여백 2 부여
                                  ),
                                  Expanded(
                                    child: Text('${snapshot.data![index]['CONTENT_DATE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 날짜가 적힌 버튼,
                                    flex: 1,), // 공간 1 부여
                                ],
                              )
                          ),
                        ),
                      );
                    },
                  );
                } else if(snapshot.hasError){ // 공지사항이 존재하지 않거나 에러시
                  return Center(child: Text('공지사항이 없습니다',style: TextStyle(color: Colors.black),),);
                }
                return Center(child: const CircularProgressIndicator(),); // 공지사항을 불러오는 동안 보여줄 화면(버퍼링)
              },
            ),
            flex: 15,), // 공간 15 부여
          Expanded(
            child: Container(),flex: 1, // 하단 여백 1 부여
          ),
        ],
      ),
    );
  }
}