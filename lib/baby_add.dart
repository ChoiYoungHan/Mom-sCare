import 'package:care_application/my_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class baby_add extends StatelessWidget {
  const baby_add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BabyAdd()
    );
  }
}

class BabyAdd extends StatefulWidget {
  const BabyAdd({Key? key}) : super(key: key);

  @override
  State<BabyAdd> createState() => _BabyAddState();
}

class _BabyAddState extends State<BabyAdd> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('아이 등록', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // Calendar_Page로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(

      ),
    );
  }
}
