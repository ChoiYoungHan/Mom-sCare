import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class my_page extends StatelessWidget {
  const my_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage()
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final List<String> babies = <String>['A','B','C','D','E','F','G']; // 추후 받아올 아이 정보
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('마이페이지', style: TextStyle(color: Colors.grey))
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: babies.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Container(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      onPressed: (){},
                      child: Text('${babies[index]}',style: TextStyle(color: Colors.black),)
                    )
                  ),
                );
              })
          ,flex: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(30), // 네 면의 여백을 3만큼 줌
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text('아기 정보', style: TextStyle(color: Colors.black),)
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(30),
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text('우리 아기 등록', style: TextStyle(color: Colors.black),)
                    )
                  )
                )
              ],
            )
          ,flex: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(30),
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text('설정', style: TextStyle(color: Colors.black),)
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(30),
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text('공지사항', style: TextStyle(color: Colors.black),)
                    )
                  )
                )
              ],
            )
          ,flex: 2,),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width*0.5,
              padding: EdgeInsets.all(40),
              child: OutlinedButton(
                onPressed: (){},
                child: Text('로그아웃', style: TextStyle(color: Colors.black),)
              )
            )
          ,flex: 2)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home_Page()));
              },
              icon: Icon(Icons.home_outlined),
            ),
            IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
              },
              icon: Icon(Icons.event_note_outlined),
            ),
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.chat_outlined),
            ),
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.list_alt_outlined, color: Colors.blue),
            ),
          ],
        )
      ),
    );
  }
}
