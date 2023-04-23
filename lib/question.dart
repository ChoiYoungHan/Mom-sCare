import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_application/edit.dart';
import 'package:care_application/question_add.dart';
import 'package:care_application/question_records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question extends StatelessWidget {
  const question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Question()
    );
  }
}

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  /*
  Future inquire_print() async{ // 문의사항들 출력
    final uri = Uri.parse('http://182.219.226.49/moms/baby/inqure');
    final header = {'Content-Type': 'application/json'};

    final baby_name = babies;
    final baby_birth = babies_birth;
    final baby_mom = babies_mother;
    final baby_dad = babies_father;

    final body = jsonEncode({'babyName': baby_name, 'expectedDate': baby_birth, 'dadName': baby_dad, 'momName': baby_mom, 'clientNum': 1 });
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      return 0;
    } else{
      print(response.statusCode.toString());
    }
  }
*/
  Future inquire() async{ // 문의사항 버튼 눌렀을 때
    final uri = Uri.parse('http://182.219.226.49/moms/baby/inqure');
    final header = {'Content-Type': 'application/json'};

    final num='1'; // 출력데이터 받아와야함

    final body = jsonEncode({'clientNum': num});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      return 0;
    } else{
      print(response.statusCode.toString());
    }
  }

  final List<String> question = <String>['제목','번호','입력','공간'];
  final List<String> question_date = <String>['0401','0402','0403','0404'];

  late bool _isHovering=true;
  late bool _isHover=true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit())); // 개인정보 변경 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 1, // 상단 여백 1 부여
          ),
          Expanded(
            child: ListView.builder( // 리스트 뷰
              itemCount: question.length, // 받아올 문의사항 길이
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(50,0,50,0), // 문의 버튼 상하단 여백 50 부여
                  child: Container(
                    width: 120, // 너비 120
                    height: 50, // 높이 50
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionRecords())); // 문의내역 페이지로 이동
                      }, // 문의 내용으로 갈 버튼
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('${question[index]}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                          flex: 1,),
                          Expanded(
                            child: Container(),flex: 2,
                          ),
                          Expanded(
                            child: Text('${question_date[index]}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                          flex: 1,),
                        ],
                      )
                    ),
                  ),
                );
              },
            ),
          flex: 15,), // 영역 비율 15 부여
          Expanded(
            child: Container(),flex: 1, // 하단 여백 1 부여
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionAdd())); // 문의내역 페이지로 이동
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isHovering)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,10),
                        child: Text('문의 추가',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                        ),
                      ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _isHovering ? Colors.black : Colors.black54
                      ),
                      child: Icon(Icons.add,color: Colors.white,size: 50,),
                    ),
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
