import 'dart:convert';
import 'package:care_application/notice.dart';
import 'package:http/http.dart' as http;
import 'package:care_application/edit.dart';
import 'package:care_application/question_add.dart';
import 'package:care_application/question_records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class question extends StatelessWidget {
  const question({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    print("question 페이지");
    print(userNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Question(UserNum: userNum, index: index)
    );
  }
}

class Question extends StatefulWidget {
  const Question({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  var inquireNum;
  late bool _isHovering=true;

  Future<List<dynamic>> inquire() async{ // 문의사항 버튼 눌렀을 때
    final uri = Uri.parse('http://182.219.226.49/moms/inquire');
    final header = {'Content-Type': 'application/json'};

    final clientnum=widget.UserNum;
    final body = jsonEncode({'clientNum': clientnum});
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => edit(userNum: widget.UserNum, index: widget.index)));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('문의', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => edit(userNum: widget.UserNum, index: widget.index))); // 설정 페이지로 이동
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
                  if(snapshot.hasData){ // 문의 내용이 존재 할 시
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
                                  setState(() {
                                    inquireNum=snapshot.data![index]['INQUIRENO']; // 버튼 클릭 시 해당하는 문의사항의 번호를 입력받는다
                                    print(inquireNum);
                                  });
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question_records(userNum: widget.UserNum, inquireNum: inquireNum, index: widget.index))); // 문의내역 페이지로 이동
                                }, // 문의 내용으로 갈 버튼
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("${index+1}",style: TextStyle(color: Colors.black),),
                                      flex: 1,),
                                    Expanded(
                                      child: SizedBox(child: Text('${snapshot.data![index]['TITLE']}',maxLines: 1,
                                          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),textAlign: TextAlign.left)), // 문의 내용이 적힌 버튼,
                                      flex: 2,),
                                    // Expanded(
                                    //   child: Container(),flex: 1,
                                    // ),
                                    Expanded(
                                      child: Text('${snapshot.data![index]['INQUIRE_DATE']}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                                      flex: 4,),
                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    );
                  }else if(snapshot.hasError){ // 문의내용이 없거나 에러시
                    return Text('문의 없음',style: TextStyle(color: Colors.black),);
                  }
                  return Center(child: const CircularProgressIndicator(),); // 데이터 로드 하는 동안 버퍼링 화면 출력
                },
              ),
              flex: 15,), // 영역 비율 15 부여
            Expanded(
              child: Container(),flex: 1, // 하단 여백 1 부여
            ),
          ],
        ),
        floatingActionButton: Stack( // 화면 위에 씌워주는 위젯
          children: [
            Positioned(
              bottom: 20,
              right: 5,
              child: MouseRegion(
                  cursor: SystemMouseCursors.click, // 사용안함
                  onEnter: (_) {
                    setState(() {
                      _isHovering = false; // 사용안함
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = true; // 사용안함
                    });
                  },
                  child: InkWell( // 클릭 활성화 위젯
                    onTap: (){ // 한번 클릭 시
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => question_add(userNum: widget.UserNum, index: widget.index))); // 문의추가 페이지로 이동
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isHovering)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0,0,0,10), // 텍스트의 하단 여백 10 부여
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
      ),
    );
  }
}