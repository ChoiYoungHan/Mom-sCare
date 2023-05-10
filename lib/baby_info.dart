import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_application/home_page.dart';
import 'package:care_application/main.dart';
import 'package:care_application/my_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class baby_info extends StatelessWidget {
  const baby_info({Key? key,required this.userNum,required this.babyNum}) : super(key: key);

  final userNum;
  final babyNum;

  @override
  Widget build(BuildContext context) {
    print("baby_info 페이지");
    print(userNum);
    print("베이비넘");
    print(babyNum);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BabyInfo(UserNum: userNum, BabyNum: babyNum)
    );
  }
}

class BabyInfo extends StatefulWidget {
  const BabyInfo({Key? key, this.UserNum, this.BabyNum}) : super(key: key);

  final UserNum;
  final BabyNum;

  @override
  State<BabyInfo> createState() => _BabyInfoState();
}

class _BabyInfoState extends State<BabyInfo> {

  var num;
  var babies='_';
  var babies_birth='_';
  var babies_mother='_';
  var babies_father='_';
  TextEditingController input_babies = TextEditingController(); // 받아올 아이 이름
  TextEditingController input_babies_birth = TextEditingController(); // 받아올 출산 예정일
  TextEditingController input_babies_mother = TextEditingController(); // 받아올 엄마 이름
  TextEditingController input_babies_father = TextEditingController(); // 받아올 아빠 이름

  late List<dynamic> baby;
  Future baby_info_() async {
    final uri = Uri.parse('http://182.219.226.49/moms/baby-info');
    final header = {'Content-Type': 'application/json'};

    final clientNum=widget.UserNum;
    final babynum=widget.BabyNum;

    final body = jsonEncode({'clientNum': clientNum, 'babyNo': babynum});
    final response = await http.post(uri, headers: header, body: body);

    final Data=jsonDecode(response.body);
    baby=Data;
    babies=baby[0]['BABYNAME'];
    babies_birth=baby[0]['EXPECTEDDATE'];
    babies_mother=baby[0]['MOMNAME'];
    babies_father=baby[0]['DADNAME'];
    print(babies);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return 1;
    } else{
      print(response.statusCode.toString());
      print("응애");
      return 0;
      throw Exception('Fail'); // 오류 발생시 예외발생(return에 null반환이 안되게 해서 해줘야함)
    }
  }

  Future baby_modify() async{ // 아이 정보 수정 함수
    final uri = Uri.parse('http://182.219.226.49/moms/baby/modify');
    final header = {'Content-Type': 'application/json'};

    final baby_num = widget.BabyNum; // 아기번호
    final user_num = widget.UserNum; // 유저번호

    final body = jsonEncode({'babyName': babies, 'expectedDate': babies_birth, 'dadName': babies_father, 'momName': babies_mother, 'clientNum': user_num, 'babyNo': baby_num});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      print('성공');
      return 1;
    }else{
      return 0;
    }
  }

  Future baby_delete() async { // 아이 삭제 함수
    final uri = Uri.parse('http://182.219.226.49/moms/baby/delete');
    final header = {'Content-Type': 'application/json'};

    final user_num = widget.UserNum; // 유저번호

    final body = jsonEncode({'babyName': babies,'clientNum': user_num});
    final response = await http.post(uri, headers: header, body: body);

    if(response.statusCode == 200){
      print('성공');
      return 1;
    }else{
      return 0;
    }
  }

  Future popup(String edit_value, TextEditingController value){
    return showDialog(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.6), // 팝업창 투명도
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(edit_value,style: TextStyle(color: Color(0xFF835529)),),backgroundColor: Color(0xFFFFE7BA),
            content: TextField( // 텍스트 필드 위젯
              controller: value, // 컨트롤되는 변수
              maxLines: 1, // maxLines를 null로 주어 글의 양에 맞게 세로 길이가 변하도록 함
              textAlign: TextAlign.right, // 텍스트 우측 정렬
              style: TextStyle(color: Color(0xFF835529)),
              decoration: InputDecoration( // 텍스트 필드 디자인
                  hintText: '${edit_value}을 입력 해주세요',
                  hintStyle: TextStyle(color: Color(0xFF835529).withOpacity(0.8)),
                  border: OutlineInputBorder( // 테두리 색상 입히기
                      borderSide: BorderSide(color: Color(0xFF835529)),
                      borderRadius: BorderRadius.circular(10) // 각 모서리 둥글게
                  ),
                  focusedBorder: OutlineInputBorder( // 텍스트 필드 포커스 시 색변환
                      borderRadius: BorderRadius.circular(10), // 포커스 시 각 모서리 둥글게
                      borderSide: BorderSide(color: Color(0xFF835529))
                  )
              ),
            ),
            actions: [
              OutlinedButton(
                  onPressed: (){
                    value.clear(); // 다시 버튼을 눌렀을 때 값 비워두기
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                  child: Text('닫기',style: TextStyle(color: Color(0xFF835529),backgroundColor: Color(0xFFFFE7BA)),)
              ),
              OutlinedButton(
                  onPressed: (){ // 4가지 정보중 어떤 위젯인지 판별
                    if(value == input_babies)
                      babies=value.text;
                    else if(value == input_babies_birth)
                      babies_birth=value.text;
                    else if(value == input_babies_mother)
                      babies_mother=value.text;
                    else if(value == input_babies_father)
                      babies_father=value.text;
                    Navigator.of(context).pop();
                    value.clear();// 다시 버튼을 눌렀을 때 값 비워두기
                  },
                  child: Text('확인',style: TextStyle(color: Color(0xFF835529),backgroundColor: Color(0xFFFFE7BA)),)
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // 상단 바 배경색을 흰색으로 설정
          title: Text('아기 정보', style: TextStyle(color: Colors.black)), // 상단 바 글자색을 검정색으로 설정
          leading: IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum,))); // 마이페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
        body: FutureBuilder(
          future: baby_info_(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Column(
                children: [
                  Expanded(
                      child: Column( // 가로 위젯
                        children: [
                          Expanded(
                            child: Container(),flex: 3, // 위 여백을 위해 영역 비율 3
                          ),
                          Expanded(
                            child: Container( // 상자 위젯
                                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                                child: OutlinedButton( // 테두리만 있는 버튼
                                    onPressed: (){
                                      popup('아기 이름',input_babies);
                                    }, // 버튼을 눌렀을 때 실행될 함수 지정
                                    child: Row(
                                      children: [
                                        Expanded( // 상자 위젯
                                          child: Padding(
                                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                                              child: Image.asset(('assets/baby_babyInfo.png')) // 버튼 왼쪽 이미지
                                          )
                                          ,flex: 1,), // 영역비율 1 부여
                                        Expanded(
                                          child:Text('아기 이름',style: TextStyle(color: Colors.black),)
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                                        ),
                                        Expanded(
                                          child: FittedBox( // 위젯 크기에 따라 텍스트의 크기 자동 조절
                                              fit: BoxFit.scaleDown, // 텍스트가 위젯 크기를 넘어가면 텍스트의 크기를 줄이는 방식
                                              child :Text('${babies}',style: TextStyle(color: Colors.black),)) // 설정된 아기의 정보
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                                        )
                                      ],
                                    )
                                )
                            )
                            ,flex: 2,), // 영역 비율 2 부여
                          Expanded(
                            child: Container(
                                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                                child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                                    onPressed: (){
                                      popup('출산 예정일', input_babies_birth);
                                    }, // 버튼을 눌렀을 때 실행될 함수 지정
                                    child: Row(
                                      children: [
                                        Expanded( // 상자 위젯
                                          child: Padding(
                                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                                              child: Image.asset(('assets/due_babyInfo.png')) // 버튼 왼쪽 이미지
                                          )
                                          ,flex: 1,), // 영역비율 1 부여
                                        Expanded(
                                          child:Text('출산 예정일',style: TextStyle(color: Colors.black),)
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                                        ),
                                        Expanded(
                                          child: FittedBox( // 위젯 크기에 따라 텍스트의 크기 자동 조절
                                              fit: BoxFit.scaleDown, // 텍스트가 위젯 크기를 넘어가면 텍스트의 크기를 줄이는 방식
                                              child :Text('${babies_birth}',style: TextStyle(color: Colors.black),)) // 설정된 출산 예정일의 정보
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                                        )
                                      ],
                                    )
                                )
                            )
                            ,flex: 2,), // 영역 비율 2 부여
                          Expanded(
                            child: Container(
                                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                                child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                                    onPressed: (){
                                      popup('엄마 이름', input_babies_mother);
                                    }, // 버튼을 눌렀을 때 실행될 함수 지정
                                    child: Row(
                                      children: [
                                        Expanded( // 상자 위젯
                                          child: Padding(
                                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                                              child: Image.asset(('assets/mother_babyInfo.png')) // 버튼 왼쪽 이미지
                                          )
                                          ,flex: 1,), // 영역비율 1 부여
                                        Expanded(
                                          child:Text('엄마 이름',style: TextStyle(color: Colors.black),)
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                                        ),
                                        Expanded(
                                          child: FittedBox( // 위젯 크기에 따라 텍스트의 크기 자동 조절
                                              fit: BoxFit.scaleDown, // 텍스트가 위젯 크기를 넘어가면 텍스트의 크기를 줄이는 방식
                                              child :Text('${babies_mother}',style: TextStyle(color: Colors.black),)) // 설정된 엄마의 정보
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                                        )
                                      ],
                                    )
                                )
                            )
                            ,flex: 2,), // 영역 비율 2 부여
                          Expanded(
                            child: Container(
                                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                                child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                                    onPressed: (){
                                      setState(() {
                                        popup('아빠 이름', input_babies_father);
                                      });
                                    }, // 버튼을 눌렀을 때 실행될 함수 지정
                                    child: Row(
                                      children: [
                                        Expanded( // 상자 위젯
                                          child: Padding(
                                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                                              child: Image.asset(('assets/father_babyInfo.png')) // 버튼 왼쪽 이미지
                                          )
                                          ,flex: 1,), // 영역비율 1 부여
                                        Expanded(
                                          child:Text('아빠 이름',style: TextStyle(color: Colors.black),)
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Container(),flex:2 // 중간 공백 비율 2 부여
                                        ),
                                        Expanded(
                                          child: FittedBox( // 위젯 크기에 따라 텍스트의 크기 자동 조절
                                              fit: BoxFit.scaleDown, // 텍스트가 위젯 크기를 넘어가면 텍스트의 크기를 줄이는 방식
                                              child :Text('${babies_father}',style: TextStyle(color: Colors.black),)) // 설정된 아빠의 정보
                                          ,flex: 2,), // 영역 비율 2 부여
                                        Expanded(
                                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                                        )
                                      ],
                                    )
                                )
                            )
                            ,flex: 2,) // 영역 비율 2 부여
                        ],
                      )
                      ,flex: 10),// 위젯이 차지할 영역 비율 10
                  Expanded(
                      child: Row( // 로우 위젯
                        children: [
                          Expanded(
                            child: Container(),flex: 1, // 좌측 여백을 위해 영역 비율 1 부여
                          ),
                          Expanded(
                              child: Container(
                                  height: MediaQuery.of(context).size.width*0.8, // 위젯의 높이를 화면 너비*0.8로 설정
                                  padding: EdgeInsets.fromLTRB(0, 60, 40, 60), // 우측40 상하60 여백을 줌
                                  child: OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            barrierColor: Colors.grey.withOpacity(0.6),
                                            builder: (BuildContext context){
                                              return  AlertDialog(
                                                title: Text(''), // 상단 여백
                                                content: Text('정말로 삭제하시겠습니까?',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                                actions: [
                                                  OutlinedButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop(); // 팝업 닫기
                                                    }, child: Text('아니오',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () async{
                                                      await baby_delete()==1?
                                                      showDialog(
                                                          context: context,
                                                          barrierColor: Colors.grey.withOpacity(0.6),
                                                          builder: (BuildContext context){
                                                            return AlertDialog(
                                                              title: Text(''),
                                                              content: Text('아이가 삭제되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                                              actions: [
                                                                OutlinedButton(
                                                                    onPressed: (){
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum,))); // 마이페이지로 이동
                                                                    },child: Text('확인',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,)
                                                                )
                                                              ],
                                                            );
                                                          }
                                                      ):
                                                      showDialog(
                                                          context: context,
                                                          barrierColor: Colors.grey.withOpacity(0.6),
                                                          builder: (BuildContext context){
                                                            return AlertDialog(
                                                              title: Text(''),
                                                              content: Text('오류 발생',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                                              actions: [
                                                                OutlinedButton(
                                                                    onPressed: (){
                                                                      Navigator.of(context).pop();
                                                                    },child: Text('확인',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,)
                                                                )
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    }, child: Text('네',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                                  )
                                                ],
                                              );
                                            }
                                        );
                                      }, // 버튼을 눌렀을 때 실행될 함수 지정
                                      child: Text('삭제', style: TextStyle(color: Colors.black),)
                                  )
                              ),
                              flex:3), // 영역 비율 3 부여
                          Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.width*0.8, // 위젯의 높이를 화면 너비*0.8로 설정
                                padding: EdgeInsets.fromLTRB(40, 60, 0, 60), // 좌측40 상하60 여백을 줌
                                child: (babies != baby[0]['BABYNAME'] && babies_birth != baby[0]['EXPECTEDDATE'] && babies_mother != baby[0]['MOMNAME'] && babies_father != baby[0]['DADNAME']) ? // 기존 정보와 같은지 다른지 판별
                                OutlinedButton( // 버튼을 눌렀을 때 실행될 함수 지정
                                    onPressed: () async {
                                      await baby_modify()==1? // 아이 정보를 수정할 때 나오는 팝업이 return이 느려 await 할당
                                      showDialog( // 팝업 위젯
                                          context: context,
                                          barrierColor: Colors.grey.withOpacity(0.6),
                                          builder: (BuildContext context){
                                            return  AlertDialog(
                                              title: Text(''), // 상단 여백
                                              content: Text('아이가 정보가 저장되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop(); // 팝업 닫기
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => my_page(userNum: widget.UserNum,))); // 마이페이지로 이동
                                                  }, child: Text('확인', style: TextStyle(color: Colors.black),),
                                                )
                                              ],
                                            );
                                          }
                                      ):
                                      showDialog( // 팝업 위젯
                                          context: context,
                                          barrierColor: Colors.grey.withOpacity(0.6),
                                          builder: (BuildContext context){
                                            return  AlertDialog(
                                              title: Text(''), // 상단 여백
                                              content: Text('오류 발생',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop(); // 팝업 닫기
                                                  }, child: Text('확인', style: TextStyle(color: Colors.black),),
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    }, // 버튼을 눌렀을 때 실행될 함수 지정
                                    child: Text('확인', style: TextStyle(color: Colors.black),)
                                ):
                                OutlinedButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        barrierColor: Colors.grey.withOpacity(0.6),
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(''),
                                            content: Text('등록 정보를 전부 입력해 주세요',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, child: Text('확인',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,)
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  }, child: Text('확인', style: TextStyle(color: Colors.black),),
                                ),
                              ),
                              flex:3), // 영역 비율 3 부여
                          Expanded(
                            child: Container(),flex: 1, // 아래 여백을 위해 영역 비율 1 부여
                          )
                        ],
                      )
                      ,flex: 5), // Column 에서 위젯이 차지할 영역 비율 5
                  Expanded(
                    child: Container(),flex: 2, // Column 에서 아래 여백을 위해 영역 비율 2 부여
                  )
                ],
              );
            }else if(snapshot.hasError){
              return Center(child: Text('아이를 선택하지 않았습니다!',style: TextStyle(color: Colors.black),));
            }
            return Center(child: const CircularProgressIndicator(color: Colors.grey,),); // 데이터를 불러오는 동안 보여주는 화면 (버퍼링 위젯)
          },
        )
    );
  }
}