import 'package:care_application/chatBot_page.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

String? _apiKey;
class _ChatBotState extends State<ChatBot> {

  TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();

  Future<String> _loadApiKey() async {
    final apiKeyPath = 'assets/mom-s-care-hgrt-412b21b7d28b.json';
    final apiKeyFile = await rootBundle.loadString(apiKeyPath);
    final apiKeyJson = jsonDecode(apiKeyFile);
    final apiKey = apiKeyJson['private_key'];

    print('apiKey는 $apiKey');
    return apiKey;
  }

  Future<void> _setupDialogflow() async {
    if (_apiKey == null) {
      _apiKey = await _loadApiKey();
    }
  }

  void _sendMessage() async {
    String message = _textController.text;

    if (message.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(sender: "user", message: message));
      });

      // Dialogflow에 메시지 전송 및 응답 처리
      await _setupDialogflow();

      final projectId = 'mom-s-care-hgrt'; // Dialogflow 에이전트의 프로젝트 ID를 설정해야 합니다.
      final sessionId = widget.UserNum; // 대화 세션의 고유한 ID를 설정해야 합니다.

      print('$_apiKey');

      try {
        final response = await http.post(
          Uri.parse('https://dialogflow.googleapis.com/v3/projects/$projectId/locations/global/agent/sessions/$sessionId:detectIntent'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'queryInput': {
              'text': {
                'text': message,
                'languageCode': 'ko' // 사용자 메시지의 언어 코드를 설정해야 합니다. 예: 'en'은 영어, 'ko'는 한국어입니다.
              }
            }
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final fulfillmentText = jsonResponse['queryResult']['fulfillmentText'];

          setState(() {
            _messages.add(ChatMessage(sender: "bot", message: fulfillmentText));
          });
        } else {
          print('Error communicating with Dialogflow: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception occurred: $e');
      }
    }

    _textController.clear();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }



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