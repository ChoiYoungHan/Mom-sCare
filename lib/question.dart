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

  late bool _isHovering=true;

  Future<List<dynamic>> inquire() async{ // 문의사항 버튼 눌렀을 때
    final uri = Uri.parse('http://182.219.226.49/moms/inquire');
    final header = {'Content-Type': 'application/json'};

    final clientnum='1'; // 나중에 회원번호 받아와야함

    final body = jsonEncode({'clientNum': '64'});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData); // 받아온 값 로그찍기
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
            child: FutureBuilder<List<dynamic>>(
              future: inquire(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
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
                                    child: Text('${snapshot.data![index]['TITLE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                                    flex: 1,),
                                  Expanded(
                                    child: Container(),flex: 2,
                                  ),
                                  Expanded(
                                    child: Text('${snapshot.data![index]['INQUIRE_DATE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                                    flex: 1,),
                                ],
                              )
                          ),
                        ),
                      );
                    },
                  );
                }else if(snapshot.hasError){

                }
                return const CircularProgressIndicator();
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
            right: 5,
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