import 'dart:convert';
import 'package:care_application/chatBot.dart';
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage{
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
        home: ChatBotPage(UserNum: userNum, index: index)
    );
  }
}
class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key, this.UserNum, this.index}) : super(key: key);

  final UserNum, index;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _text = TextEditingController();
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();

  bool ButtonEnabled = true;

  final apiKey = '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';
  final apiUrl = 'https://api.openai.com/v1/completions';

  var translate_result = '';
  var gpt_result = '';

  Future<String> generateText(String prompt) async{
    final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type' : 'application/json', 'Authorization' : 'Bearer $apiKey'},
        body: jsonEncode({
          "model": "text-davinci-003",
          'prompt': prompt,
          'max_tokens': 1000,
          'temperature': 0,
          'top_p': 1,
          'frequency_penalty': 0,
          'presence_penalty': 0
        })
    );

    Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));

    return newresponse['choices'][0]['text'];
  }

  // 번역 실행
  Future<void> getTranslation_google_cloud_translation_en(String text) async {
    var _url = 'https://translation.googleapis.com/language/translate/v2';
    var key = 'AIzaSyBfdlPIj2XMV4YINxZMgvnrnILGdoxqMQ0';
    var to = "en";
    var response = await http.post(
        Uri.parse('$_url?target=$to&key=$key&q=$text')
    );

    if(response.statusCode == 200){
      var dataJson = jsonDecode(response.body);
      translate_result = dataJson['data']['translations'][0]['translatedText'];

      String data = await generateText(translate_result);

      await getTranslation_google_cloud_translation_ko(data.toString());

      setState(() {

      });
    } else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }

  // 번역 실행
  Future<void> getTranslation_google_cloud_translation_ko(String text) async {
    var _url = 'https://translation.googleapis.com/language/translate/v2';
    var key = 'AIzaSyBfdlPIj2XMV4YINxZMgvnrnILGdoxqMQ0';
    var to = "ko";
    var response = await http.post(
        Uri.parse('$_url?target=$to&key=$key&q=$text')
    );

    if(response.statusCode == 200){
      var dataJson = jsonDecode(response.body);
      translate_result = dataJson['data']['translations'][0]['translatedText'];

      setState(() {

      });
    } else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }

  void _sendMessage() async {

    await getTranslation_google_cloud_translation_en(_text.text);

    setState(() {
      _messages.add(ChatMessage(sender: 'user', message: _text.text));

      if(_text.text != null){
        _messages.add(ChatMessage(sender: 'bot', message: translate_result));

      }

      _text.clear();

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut
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
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                        child: Text('아니오')
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                          SystemNavigator.pop();
                        },
                        child: Text('예')
                    )
                  ]
              );
            }
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('ChatBot', style: TextStyle(color: Colors.grey)) // 상단 바 글자색을 회색으로 설정
        ),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index){
                      ChatMessage chatMessage = _messages[index];
                      bool isUserMessage = chatMessage.sender == 'user';
                      return ListTile(
                        title: Align(
                            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: isUserMessage ? Colors.blue : Colors.green,
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              child: Text(
                                  chatMessage.message,
                                  style: TextStyle(color: Colors.white)
                              ),
                            )
                        ),
                      );
                    }
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[200],
                  child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                                controller: _text,
                                decoration: InputDecoration(
                                    hintText: '메시지 입력'
                                )
                            )
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                            onPressed: (){
                              if(_text.text.isEmpty){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                          title: Text('오류 메시지'),
                                          content: Text('공백없이 입력해주세요'),
                                          actions: [
                                            TextButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('확인', style: TextStyle(color: Colors.black))
                                            )
                                          ]
                                      );
                                    }
                                );
                              } else if (ButtonEnabled){
                                _sendMessage();
                              }
                            },
                            child: Text('전송'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black)
                            )
                        )
                      ]
                  )
              )
            ]
        ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
                children: [
                  IconButton( // 아이콘 버튼 위젯
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Page(userNum: widget.UserNum, index: widget.index))); // 홈페이지로 화면 이동
                      },
                      icon: Icon(Icons.home_outlined)
                  ),
                  IconButton( // 아이콘 버튼 위젯
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum, index: widget.index))); // 캘린더페이지로 화면 이동
                      },
                      icon: Icon(Icons.event_note_outlined)
                  ),
                  IconButton( // 아이콘 버튼 위젯
                      onPressed: (){

                      },
                      icon: Icon(Icons.chat_outlined, color: Colors.blue)
                  ),
                  IconButton( // 아이콘 버튼 위젯
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum, index: widget.index))); // 마이페이지로 화면 이동
                      }, // 현재 위치한 페이지로 화면설정을 하지 않고 버튼 형태만 유지
                      icon: Icon(Icons.list_alt_outlined)
                  )
                ]
            )
        ),
      ),
    );
  }
}
