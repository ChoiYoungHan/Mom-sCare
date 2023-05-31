import 'dart:convert';

import 'package:care_application/imageScreen.dart';
import 'package:care_application/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class print_diary extends StatelessWidget {
  final DateTime selectedDate;
  final userNum, index;

  const print_diary({Key? key, required this.selectedDate, required this.userNum, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: printdiary_Page(selectedDate: selectedDate, UserNum: userNum, index: index)
    );
  }
}

class printdiary_Page extends StatefulWidget {
  const printdiary_Page({Key? key, required this.selectedDate, required this.UserNum, this.index}) : super(key: key);

  final DateTime selectedDate;
  final UserNum, index;

  @override
  State<printdiary_Page> createState() => _printdiary_PageState();
}

class _printdiary_PageState extends State<printdiary_Page> {

  TextEditingController _controller = TextEditingController();
  String _content = '';

  List<String> imageList = [];

  bool receive = true;

  Future<Response> receiveData() async {
    final uri = Uri.parse('http://182.219.226.49/moms/diary');
    final headers = {'Content-Type': 'application/json'};

    final ClientNum = widget.UserNum;
    final diary_date = '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, "0")}-${widget.selectedDate.day}';

    print(ClientNum + '//' + diary_date);

    final body = jsonEncode({'clientNum': ClientNum, 'diary_date': diary_date});
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        print(utf8.decode(jsonData['content'].runes.toList()));

        _content = utf8.decode(jsonData['content'].runes.toList());
        _controller.text = _content;

        if (jsonData.containsKey('imageURL')) {
          print(utf8.decode(jsonData['imageURL'].runes.toList()));

          imageList.clear();
          imageList.addAll(utf8.decode(jsonData['imageURL'].runes.toList()).split('/'));
          imageList.removeLast();

          print(imageList);

          receive = false;
        } else {

        }
      } else {
        // 처리 실패 시의 동작 추가
      }
    } else {
      // 요청 실패 시의 동작 추가
    }
    return response;
  }


  Future<void> deleteDiary() async {
    final uri = Uri.parse('http://182.219.226.49/moms/diary/delete');
    final headers = {'Content-Type' : 'application/json'};

    final clientNum = widget.UserNum;
    final Date = '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, "0")}-${widget.selectedDate.day}';

    final body = jsonEncode({'clientNum': clientNum, 'diary_date': Date});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
                title: Center(child: FittedBox(child: Text('삭제가 완료되었습니다.', style: TextStyle(color: Colors.grey)))),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Calendar_Page(UserNum: widget.UserNum, index: widget.index)));
                      },
                      child: Text('확인')
                  )
                ]
            );
          }
      );
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(userNum: widget.UserNum, index: widget.index)));

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // 화면이 밀려 올라가는 것을 방지
        appBar: AppBar(
            backgroundColor: Colors.white, // 상단바 배경 흰색
            leading: IconButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Calendar_Page(UserNum: widget.UserNum, index: widget.index)));
                },
                icon: Icon(Icons.arrow_back, color: Colors.grey)
            ),
            title: Text(
                '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일', style: TextStyle(color: Colors.grey) // 받아온 날짜 출력 & 글자 색은 회색
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                              title: Center(child: FittedBox(child: Text('일기를 삭제하시겠습니까?', style: TextStyle(color: Colors.grey)))),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소')
                                ),
                                TextButton(
                                    onPressed: (){
                                      deleteDiary();
                                    },
                                    child: Text('확인')
                                )
                              ]
                          );
                        }
                    );
                  },
                  icon: Icon(Icons.delete_forever_outlined, color: Colors.orange)
              )
            ]
        ),
        body: SafeArea(
            child: GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                          controller: _controller,
                          maxLines: null,
                          enabled: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          )
                      ),
                    ), flex: 8),
                    FutureBuilder<Response>(
                        future: receiveData(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return Expanded(child: Container(
                                padding: EdgeInsets.all(5), // 네 면의 여백을 5만큼 줌
                                width: MediaQuery.of(context).size.width * 0.97,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageList.length,
                                    itemBuilder: (context, index){
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FullscreenImagePage(imageUrl: imageList, Index: index)));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(3),
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: MediaQuery.of(context).size.width * 0.3,
                                            child: Image.network('http://182.219.226.49/image/' + imageList[index], fit: BoxFit.cover)
                                        ),
                                      );
                                    }
                                )
                            ), flex: 2);
                          } else {
                            return receive == false ? Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.97,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: Center(
                                    child: CircularProgressIndicator()
                                ),
                              ),
                              flex: 2,
                            ) : Container() ;
                          }
                        }
                    )
                  ],
                )
            )
        ),
      ),
    );
  }
}
