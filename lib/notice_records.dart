import 'package:care_application/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notice_records extends StatelessWidget {
  const notice_records({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoticeRecords(),
    );
  }
}

class NoticeRecords extends StatefulWidget {
  const NoticeRecords({Key? key}) : super(key: key);

  @override
  State<NoticeRecords> createState() => _NoticeRecordsState();
}

class _NoticeRecordsState extends State<NoticeRecords> {
  var Notice_ = "공지 내용";
  var Notice_Title = "제목";
  var date_ = "날짜";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('공지사항', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Notice())); // 공지사항항 이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(), flex: 1,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(), flex: 1,
                ),
                Expanded(
                  child: Container(
                      child: Text('${Notice_Title}',style: TextStyle(fontSize: 30),)
                  ),
                  flex: 1,),
                Expanded(
                  child: Container(), flex: 2,
                ),
                Expanded(
                  child: Container(
                      child: Text('${date_}')
                  ),
                  flex: 1,),
                Expanded(
                  child: Container(), flex: 1,
                ),
              ],
            ),
          flex: 1,),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width*0.7, // 위젯의 높이를 화면 너비로 동일설정
                decoration: BoxDecoration(
                    border: Border.all(
                        width:1
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('${Notice_}'),
                )
            ),
            flex: 5,),
          Expanded(
            child: Container(), flex: 3,
          ),
        ],
      ),
    );
  }
}
