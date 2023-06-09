import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:care_application/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question_add extends StatelessWidget {
  const question_add({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    print("question_add 페이지");
    print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: QuestionAdd(UserNum: userNum, index: index)
    );
  }
}

class QuestionAdd extends StatefulWidget {
  const QuestionAdd({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<QuestionAdd> createState() => _QuestionAddState();
}

class _QuestionAddState extends State<QuestionAdd> {
  TextEditingController title = TextEditingController(); // 제목
  TextEditingController contents = TextEditingController(); // 내용

  Future inquire_add() async{ // 문의사항 추가 함수
    final uri = Uri.parse('http://182.219.226.49/moms/inquire-request');
    final header = {'Content-Type': 'application/json'};

    final content=contents.text;
    final title_ = title.text;
    final clientNum=widget.UserNum;

    final body = jsonEncode({'title': title_,'content': content, 'clientNum': clientNum});
    final response = await http.post(uri, headers: header, body: body);
    print(response.statusCode);
    if(response.statusCode == 200){

    } else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question(userNum: widget.UserNum, index: widget.index)));

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의하기', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question(userNum: widget.UserNum, index: widget.index))); // 개인정보 변경 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  inquire_add(); // 문의 추가하는 함수
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question(userNum: widget.UserNum, index: widget.index))); // 문의사항 페이지로 이동
                }, child: Text('보내기', style: TextStyle(color: Colors.black, fontSize: 20),))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 30, 0, 10),
                  child: Container(
                    width: 130,
                      height: 100,
                      child: Image.asset(('assets/document.png'))
                  ),  // 상단 여백 1 부여
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(60, 0, 0, 20),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text("문의사항을 내용을 작성해주세요!",style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 0, 0, 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: TextField(
                      controller: title,
                      maxLength: 15,
                      maxLines: 1, // 한줄 만 입력받도록 설정
                      textAlign: TextAlign.left, // 좌측 정렬
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          hintText: ('제목을 입력하세요')
                      ),
                    ),
                  ),
                ), // 여백 1 부여
                Padding(
                    padding: EdgeInsets.fromLTRB(60, 0, 0, 20),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.7,
                      height: MediaQuery.of(context).size.height*0.7,
                      child: TextField(
                        maxLength: 1000,
                        controller: contents,
                        maxLines: 5, // maxLines를 null로 주어 글의 양에 맞게 세로 길이가 변하도록 함
                        textAlign: TextAlign.left, // 좌측 정렬
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            // contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            hintText: ('내용을 입력하세요')
                        ),
                      )
                  )
                 ),//// 여백 5 부여
              ],
            ),
          ),
        ),
      ),
    );
  }
}