import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/edit.dart';
import 'package:care_application/my_page.dart';
import 'package:care_application/notice_records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notice extends StatelessWidget {
  const notice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notice(),
    );
  }
}

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

  Future<List<dynamic>> notice_() async {
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
    notice_();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('공지사항', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // 개인정보 변경 페이지로 이동
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
                if(snapshot.hasData){
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoticeRecords())); // 공지내용으로 이동
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('${snapshot.data![index]['NOTICENO']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                                    flex: 1,),
                                  Expanded(
                                    child: Text('${snapshot.data![index]['CONTENT']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                                    flex: 3,),
                                  Expanded(
                                    child: Container(),flex: 2,
                                  ),
                                  Expanded(
                                    child: Text('${snapshot.data![index]['CONTENT_DATE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                                    flex: 1,),
                                ],
                              )
                          ),
                        ),
                      );
                    },
                  );
                } else if(snapshot.hasError){

                }
                return const CircularProgressIndicator();
              },
            ),
            flex: 15,),
          Expanded(
            child: Container(),flex: 1, // 하단 여백 1 부여
          ),
        ],
      ),
    );
  }
}