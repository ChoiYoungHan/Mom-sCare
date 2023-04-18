import 'package:care_application/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question_add extends StatelessWidget {
  const question_add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionAdd()
    );
  }
}

class QuestionAdd extends StatefulWidget {
  const QuestionAdd({Key? key}) : super(key: key);

  @override
  State<QuestionAdd> createState() => _QuestionAddState();
}

class _QuestionAddState extends State<QuestionAdd> {
  TextEditingController title = TextEditingController(); // 제목
  TextEditingController contents = TextEditingController(); // 내용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의하기', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Question())); // 개인정보 변경 페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 3, // 상단 여백 1 부여
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(),flex: 2,),
                Expanded(
                  child: Text('제목',style: TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold),),
                flex: 11,)
              ],
            )
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              child: TextField(
                controller: title,
                maxLines: null, // maxLines를 null로 주어 글의 양에 맞게 세로 길이가 변하도록 함
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: ('제목을 입력하세요')
                ),
              ),
            ),
            flex: 2,), // 여백 1 부여
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
                height: MediaQuery.of(context).size.height*0.7,
                child: TextField(
                  controller: contents,
                  maxLines: null, // maxLines를 null로 주어 글의 양에 맞게 세로 길이가 변하도록 함
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      hintText: ('내용을 입력하세요')
                  ),
                )
            )
            ,flex: 5,),// 여백 5 부여
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,40,0,40),
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Question()));
                  },
                  child: Text('보내기',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),flex: 3,
          ),
          Expanded(child: Container(),flex: 3,)
        ],
      ),
    );
  }
}
