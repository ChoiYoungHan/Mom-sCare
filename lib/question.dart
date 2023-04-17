import 'package:care_application/edit.dart';
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

  final List<String> question = <String>['제목','번호','입력','공간']; // 추후 받을 문의목록 대체
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의하기', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit())); // 개인정보 변경 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: question.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(50,0,50,0),
                  child: Container(
                    width: 120,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: (){}, // 문의 내용으로 갈 버튼
                      child: Text('${question[index]}',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                );
              },
            ),
          flex: 15,),
          Expanded(
            child: Container(),flex: 1,
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: (){
                // 문의 추가 페이지로 이동
              },child: Icon(Icons.add,color: Colors.white,),
            ),
          ),
        ],
      )
    );
  }
}
