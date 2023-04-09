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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // 마이페이지로 이동
          }, icon: Icon(Icons.arrow_back, color: Colors.black,),
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),flex: 3, // 위 여백을 위해 영역 비율 3
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
              width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
              padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
              child: OutlinedButton(
                onPressed: (){},
                child: Row(
                  children: [
                    Expanded( // 상자 위젯
                      child: Padding(
                          padding: EdgeInsets.all(5), // 모든 여백 5 부여
                          child: Image.asset(('baby_babyInfo.png')) // 버튼 왼쪽 이미지
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
                          fit: BoxFit.scaleDown, // 작아지게
                          child :Text('아이',style: TextStyle(color: Colors.black),)) // 설정된 아기의 정보 (데이터베이스 연동 후 수정 예정)
                      ,flex: 1,), // 영역 비율 1 부여
                    Expanded(
                        child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                    )
                  ],
                )
              )
            ),
          flex: 2,),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){},
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                              child: Image.asset(('due_babyInfo.png')) // 버튼 왼쪽 이미지
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
                              fit: BoxFit.scaleDown, // 작아지게
                              child :Text('날짜',style: TextStyle(color: Colors.black),)) // 설정된 출산 예정일의 정보 (데이터베이스 연동 후 수정 예정)
                          ,flex: 1,), // 영역 비율 1 부여
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){},
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                              child: Image.asset(('mother_babyInfo.png')) // 버튼 왼쪽 이미지
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
                              fit: BoxFit.scaleDown, // 작아지게
                              child :Text('엄마',style: TextStyle(color: Colors.black),)) // 설정된 엄마의 정보 (데이터베이스 연동 후 수정 예정)
                          ,flex: 1,), // 영역 비율 1 부여
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.width, // 위젯의 높이를 화면 너비로 동일설정
                width: MediaQuery.of(context).size.width*0.77, // 위젯의 너비를 화면 너비*0.77로 동일설정
                padding: EdgeInsets.all(10), // 네 면의 여백을 10만큼 줌
                child: OutlinedButton(
                    onPressed: (){},
                    child: Row(
                      children: [
                        Expanded( // 상자 위젯
                          child: Padding(
                              padding: EdgeInsets.all(5), // 모든 여백 5 부여
                              child: Image.asset(('father_babyInfo.png')) // 버튼 왼쪽 이미지
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
                              fit: BoxFit.scaleDown, // 작아지게
                              child :Text('아빠',style: TextStyle(color: Colors.black),)) // 설정된 아빠의 정보 (데이터베이스 연동 후 수정 예정)
                          ,flex: 1,), // 영역 비율 1 부여
                        Expanded(
                            child: Icon(Icons.arrow_outward_outlined, color: (Colors.black),)
                        )
                      ],
                    )
                )
            ),
            flex: 2,),// 영역 비율 2 부여
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width*0.1, // 위젯의 높이를 화면 너비*0.1로 설정
              width: MediaQuery.of(context).size.width*0.4,
              padding: EdgeInsets.fromLTRB(0, 70, 0, 70), // 상하80 여백을 줌
              child: OutlinedButton(
                onPressed: (){
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
                                //데이터베이스에서 아이정보가 저장될 코드 추가 예정
                                Navigator.of(context).pop(); // 팝업 닫기
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage())); // 마이페이지로 이동
                              }, child: Text('확인'),
                            )
                          ],
                        );
                      }
                  );
                }, child: Text('확인', style: TextStyle(color: Colors.black),),
              ),
            ),
          flex: 4,),
          Expanded(
            child: Container(),flex: 2,
          )
        ],
      ),
    );
  }
}
