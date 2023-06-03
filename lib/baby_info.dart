import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_application/my_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class baby_info extends StatelessWidget {
  const baby_info({Key? key, required this.userNum, this.index, required this.babyNum}) : super(key: key);

  final userNum, index, babyNum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BabyInfo(userNum: userNum, index: index, babyNum: babyNum)
    );
  }
}

class BabyInfo extends StatefulWidget {
  const BabyInfo({Key? key, this.userNum, this.index, this.babyNum}) : super(key: key);

  final userNum, index, babyNum;

  @override
  State<BabyInfo> createState() => _BabyInfoState();
}

List<String> printContent = [];

class _BabyInfoState extends State<BabyInfo> {

  Future<void> _loadData() async {
    // 비동기 함수 실행
    await baby_info(); // 함수 실행이 완료될 때까지 기다림

    // 함수 실행이 완료된 후에 페이지를 빌드
    setState(() {
      // 상태 업데이트 및 페이지 재빌드
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<String> images = ['assets/baby_babyInfo.png', 'assets/due_babyInfo.png', 'assets/mother_babyInfo.png', 'assets/father_babyInfo.png'];
  List<String> title = ['아기 이름', '출산 예정일', '엄마 이름', '아빠 이름'];

  var baby_name, baby_expecttedDate, baby_father, baby_mother;

  TextEditingController edit = TextEditingController();

  Future<List<String>> baby_info() async {
    final uri = Uri.parse('http://182.219.226.49/moms/baby-info');
    final headers = {'Content-Type' : 'application/json'};

    final clientNum = widget.userNum;
    final babyNum = widget.babyNum;

    final body = jsonEncode({'clientNum' : clientNum, 'babyNo' : babyNum});
    final response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      printContent.clear();

      jsonData.forEach((element) {
        printContent.add(element['BABYNAME'].toString()); // 데이터 추가
        printContent.add(element['EXPECTEDDATE'].toString());
        printContent.add(element['MOMNAME'].toString());
        printContent.add(element['DADNAME'].toString());
      });

    } else {

    }

    return printContent;
  }

  Future baby_modify(String babyName, String expectedDate, String momName, String dadName) async {
    final uri = Uri.parse('http://182.219.226.49/moms/baby/modify');
    final header = {'Content-Type': 'application/json'};

    final baby_num = widget.babyNum; // 아기번호
    final user_num = widget.userNum; // 유저번호

    final body = jsonEncode({'babyName': babyName, 'expectedDate': expectedDate, 'dadName': dadName, 'momName': momName, 'clientNum': user_num, 'babyNo': baby_num});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      print('아기 정보 수정 성공');
    }else{
      print('아기 정보 수정 실패');
    }
  }

  Future baby_delete(String babyName) async {
    final uri = Uri.parse('http://182.219.226.49/moms/baby/delete');
    final header = {'Content-Type': 'application/json'};

    final user_num = widget.userNum;

    final body = jsonEncode({'babyName': babyName,'clientNum': user_num});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){

    }else{

    }
  }

  Future popup(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: TextField(
            controller: edit,
            decoration: InputDecoration(hintText: '이름을 입력해주세요.')
          ),
          actions: [
            OutlinedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('취소')
            ),
            OutlinedButton(
              onPressed: (){
                if(edit.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content: Text('공백없이 입력해주세요.'),
                        actions: [
                          ElevatedButton(
                            child: Text('예'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                } else {
                  printContent[index] = edit.text;
                  edit.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('확인')
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.userNum, index: widget.index)));

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('아기 정보', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => my_page(userNum: widget.userNum, index: widget.index)));
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 60, 40, 30),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: images.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                          height: 60,
                          child: OutlinedButton(
                            onPressed: (){
                              if(index == 1){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030)
                                ).then((selectedDate){
                                  var date = selectedDate.toString().split(" ")[0];
                                  setState(() {
                                    printContent[1] = date;
                                  });
                                  print(date);
                                });
                              } else {
                                popup(index);
                              }

                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: Image.asset(images[index])
                                ),
                                FittedBox(
                                  child: Text(title[index], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                ),
                                Spacer(),
                                FittedBox(
                                  child: Text(printContent[index], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(Icons.arrow_outward_outlined, color: Colors.black)
                                )
                              ]
                            )
                          )
                        )
                      );
                    }
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text('아기 정보를 삭제하시겠습니까?'),
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
                                        baby_delete(printContent[0].toString());
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyPage(UserNum: widget.userNum, index: widget.index)));
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          child: Text('삭제', style: TextStyle(color: Colors.black))
                        )
                      ),
                      Container(
                        width: 150,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: (){
                            baby_modify(printContent[0], printContent[1], printContent[2], printContent[3]);
                            print(printContent[0].toString() + printContent.toString());
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text('수정이 완료되었습니다.'),
                                  actions: [
                                    ElevatedButton(
                                      child: Text('예'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyPage(UserNum: widget.userNum, index: widget.index)));
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          child: Text('수정', style: TextStyle(color: Colors.black))
                        )
                      )
                    ]
                  )
                ),
              )
            ]
          )
        )
      )
    );
  }
}
