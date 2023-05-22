import 'package:care_application/chatBot_page.dart';
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

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key, this.UserNum}) : super(key: key);

  final UserNum;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {

  TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    setState(() {
      String message = _textController.text;

      // 사용자가 입력한 메시지를 오른쪽에 출력
      _messages.add(ChatMessage(sender: "user", message: message));

      // 입력한 메시지 처리
      if (message != null) {
        //다이얼로그 플로우 처리 후 받게될 답변
        _messages.add(ChatMessage(sender: "bot", message: "Yes"));
      }

      _textController.clear();

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chatBot_page(userNum: widget.UserNum)));
                  }, child: Text('채팅내역', style: TextStyle(color: Colors.black, fontSize: 20),)),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatMessage chatMessage = _messages[index];
                  bool isUserMessage = chatMessage.sender == "user";
                  return ListTile(
                    title: Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          chatMessage.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '메시지 입력',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style:
                      ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: _sendMessage,
                    child: Text('전송'),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar( // 하단 바
            height: 60, // 높이 60
            child: Row( // 가로 정렬
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(UserNum: widget.UserNum)));
                      },
                      icon: Icon(Icons.home_outlined)
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum)));
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum)));
                      },
                      icon: Icon(Icons.list_alt_outlined)
                  )
                ]
            )
        )
    );
  }
}