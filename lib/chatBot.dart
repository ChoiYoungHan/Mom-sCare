import 'package:care_application/chatBot_page.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class chatBot extends StatelessWidget {
  const chatBot({Key? key,required this.userNum, this.index}) : super(key: key);

  final userNum, index;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatBot(UserNum: userNum, index: index)
    );
  }
}

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();

  bool ButtonEnabled = true;

  void _sendMessage() async {

    setState(() {
      ButtonEnabled = false;
    });
    String message = _textController.text;

    var receiveMsg = '';

    final uri = Uri.parse('http://182.219.226.49/moms/chat/dialogflow');
    final headers = {'Content-Type' : 'application/json'};

    final clientNum = widget.UserNum;
    final dialog = message;

    final body = jsonEncode({'clientNum': '43', 'dialog': dialog});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      receiveMsg = utf8.decode(jsonData['message'].runes.toList());

      print(receiveMsg);

    } else {

    }

    setState(() {

      // 사용자가 입력한 메시지를 오른쪽에 출력
      _messages.add(ChatMessage(sender: "user", message: message));

      // 입력한 메시지 처리
      if (message != null) {
        //다이얼로그 플로우 처리 후 받게될 답변
        _messages.add(ChatMessage(sender: "bot", message: receiveMsg));
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

    setState(() {
      ButtonEnabled = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text('어플을 종료하시겠습니까?'),
                actions: [
                  ElevatedButton(
                    child: Text('아니오'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('예'),
                    onPressed: () {
                      Navigator.of(context).pop(true); // 다이얼로그를 닫고 뒤로 이동합니다.
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            }
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('ChatBot', style: TextStyle(color: Colors.grey)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ChatBotPage(UserNum: widget.UserNum, index: widget.index))); // 수정: chatBot_page -> ChatBotPage
                },
                child: Text(
                  '채팅내역',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: ButtonEnabled ? _sendMessage : null,
                    child: Text('전송'),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage(UserNum: widget.UserNum, index: widget.index)));
                },
                icon: Icon(Icons.home_outlined),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum, index: widget.index)));
                },
                icon: Icon(Icons.event_note_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chat_outlined, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyPage(UserNum: widget.UserNum, index: widget.index))); // 수정: my_page -> MyPage
                },
                icon: Icon(Icons.list_alt_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
