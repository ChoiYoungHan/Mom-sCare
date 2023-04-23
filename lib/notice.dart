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

  final List<String> notice = <String>['제목','번호','입력','공간'];
  final List<String> notice_num = <String>['1','2','3','4'];
  final List<String> notice_date = <String>['0501','0502','0503','0504'];

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: notice.length,
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
                            child: Text('${notice_num[index]}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                            flex: 1,),
                          Expanded(
                            child: Text('${notice[index]}',style: TextStyle(color: Colors.black),textAlign: TextAlign.left), // 문의 내용이 적힌 버튼,
                            flex: 3,),
                          Expanded(
                            child: Container(),flex: 2,
                          ),
                          Expanded(
                            child: Text('${notice_date[index]}',style: TextStyle(color: Colors.black),textAlign: TextAlign.right), // 문의 내용이 적힌 버튼,
                            flex: 1,),
                        ],
                      )
                    ),
                  ),
                );
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
