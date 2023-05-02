import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:flutter/material.dart';

class chatBot extends StatelessWidget {
  const chatBot({Key? key,required this.userNum}) : super(key: key);

  final userNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatBot(UserNum: userNum)
    );
  }
}

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool isuser = false;
  final List<String> chat = <String>['1','2','3','4','5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('ChatBot', style: TextStyle(color: Colors.grey)), // 상단 바 글자색을 검정색으로 설정
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: (){

                  }, child: Text('채팅내역', style: TextStyle(color: Colors.black, fontSize: 20),)),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  //reverse: false,
                  itemCount: chat.length,
                  itemBuilder: (context, index){
                    return Row(
                      mainAxisAlignment: isuser ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: isuser ? Colors.green[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)
                            ),child: Text('${chat[index]}',style: TextStyle(color: Colors.black),)
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${chat[index]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                                '${chat[index]}'
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              flex: 9,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextField(

                      ),
                    ),
                    flex: 8,),
                  Expanded(
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                          isuser=true;
                          chat.add('new message');
                          print(isuser);
                        });
                      },
                      icon: Icon(Icons.arrow_back),),
                  )
                ],
              ),
              flex: 1,)
          ],
        ),
        bottomNavigationBar: BottomAppBar( // 하단 바
            height: 60, // 높이 60
            child: Row( // 가로 정렬
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(UserNum: widget.UserNum)));
                      },
                      icon: Icon(Icons.home_outlined)
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum)));
                      },
                      icon: Icon(Icons.event_note_outlined)
                  ),
                  IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.chat_outlined, color: Colors.blue)
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum)));
                      },
                      icon: Icon(Icons.list_alt_outlined)
                  )
                ]
            )
        )
    );
  }
}