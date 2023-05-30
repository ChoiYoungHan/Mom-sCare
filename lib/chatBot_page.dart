import 'dart:convert';
import 'package:care_application/chatBot.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatBot_page extends StatelessWidget {
  const chatBot_page({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatBotPage(UserNum: userNum, index: index)
    );
  }
}
class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  var chatbotNum;

  Future<List<dynamic>> ChatBot_() async { // 채팅내역 출력 함수
    final uri = Uri.parse('http://182.219.226.49/moms/ChatBot'); // 데이터베이스 추가필요
    final headers = {'Content-Type': 'application/json'};

    final userNum= widget.UserNum;
    final body = jsonEncode({'clientNum': userNum});
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
          title: Text('채팅 내역', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 회색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chatBot(userNum: widget.UserNum, index: widget.index))); // 마이페이지로 이동
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
              future: ChatBot_(),
              builder: (context, snapshot){
                if(snapshot.hasData){ // 채팅내역이 존재할 시
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
                                  chatbotNum = snapshot.data![index]['CHATBOTNO']; // 클릭한 채팅내역의 번호를 입력 받는다
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    //보류
                                    child: Text('${snapshot.data![index]['CHATBOTNO']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 채팅내역 번호가 적힌 버튼,
                                    flex: 1,), // 공간 1 부여
                                  Expanded(
                                    //보류
                                    child: Text('${snapshot.data![index]['DETAIL']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 마지막 채팅 내용이 적힌 버튼,
                                    flex: 3,), // 공간 3 부여
                                  Expanded(
                                    //보류
                                    child: Container(),flex: 2, // 중간 여백 2 부여
                                  ),
                                  Expanded(
                                    child: Text('${snapshot.data![index]['CONTENT_DATE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 채팅 날짜가 적힌 버튼,
                                    flex: 1,), // 공간 1 부여
                                ],
                              )
                          ),
                        ),
                      );
                    },
                  );
                } else if(snapshot.hasError){ // 채팅 내역이 존재하지 않거나 에러시
                  return Center(child: Text('채팅 내역이 없습니다',style: TextStyle(color: Colors.black),),);
                }
                return Center(child: const CircularProgressIndicator(),); // 채팅내역을 불러오는 동안 보여줄 화면(버퍼링)
              },
            ),
            flex: 15,), // 공간 15 부여
          Expanded(
            child: Container(),flex: 1, // 하단 여백 1 부여
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
            children: [
              IconButton( // 아이콘 버튼 위젯
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.UserNum, index: widget.index))); // 홈페이지로 화면 이동
                },
                icon: Icon(Icons.home_outlined),
              ),
              IconButton( // 아이콘 버튼 위젯
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum, index: widget.index))); // 캘린더페이지로 화면 이동
                },
                icon: Icon(Icons.event_note_outlined),
              ),
              IconButton( // 아이콘 버튼 위젯
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chatBot(userNum: widget.UserNum, index: widget.index))); // 캘린더페이지로 화면 이동
                },
                icon: Icon(Icons.chat_outlined, color: Colors.blue),
              ),
              IconButton( // 아이콘 버튼 위젯
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum, index: widget.index))); // 마이페이지로 화면 이동
                }, // 현재 위치한 페이지로 화면설정을 하지 않고 버튼 형태만 유지
                icon: Icon(Icons.list_alt_outlined),
              ),
            ],
          )
      ),
    );
  }
}
