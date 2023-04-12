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

  var babies='_';
  var babies_birth='_';
  var babies_mother='_';
  var babies_father='_';
  TextEditingController input_babies = TextEditingController(); // 받아올 아이 이름
  TextEditingController input_babies_birth = TextEditingController(); // 받아올 출산 예정일
  TextEditingController input_babies_mother = TextEditingController(); // 받아올 엄마 이름
  TextEditingController input_babies_father = TextEditingController(); // 받아올 아빠 이름

  Future popup(String edit_value){
    TextEditingController edit=TextEditingController();
    return showDialog(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.6),
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(edit_value,style: TextStyle(color: Color(0xFF835529)),),backgroundColor: Color(0xFFFFE7BA),
          content: TextField(
            controller: edit,
            textAlign: TextAlign.right,
            style: TextStyle(color:  Color(0xFF835529)),
            decoration: InputDecoration(
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
                edit.clear(); // 다시 버튼을 눌렀을 때 값 비워두기
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('닫기',style: TextStyle(color: Color(0xFF835529),backgroundColor: Color(0xFFFFE7BA)),)
            ),
            OutlinedButton(
             onPressed: (){
               if(edit_value=='아이 이름'){
                 setState(() {
                   babies=edit.text;
                 });
                 // 데이터베이스에 저장할 코드 작성 예정
               }
               else if(edit_value=='출산 예정일'){
                 setState(() {
                   babies_birth=edit.text;
                 });
                 // 데이터베이스에 저장할 코드 작성 예정
               }
               else if(edit_value=='엄마 이름'){
                 setState(() {
                   babies_mother=edit.text;
                 });
                 // 데이터베이스에 저장할 코드 작성 예정
               }
               else if(edit_value=='아빠 이름'){
                 setState(() {
                   babies_father=edit.text;
                 });
                 // 데이터베이스에 저장할 코드 작성 예정
               }
               Navigator.of(context).pop();
             },
                child: Text('확인',style: TextStyle(color: Color(0xFF835529),backgroundColor: Color(0xFFFFE7BA)),)
            )
          ],
        );
      }
    );
  }

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
                onPressed: (){
                  popup('아이 이름');
                },
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
                          child :Text('${babies}',style: TextStyle(color: Colors.black),)) // 입력받은 아이의 정보 (데이터베이스 연동 후 수정 예정)
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
                    onPressed: (){
                      popup('출산 예정일');
                    },
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
                              child :Text('${babies_birth}',style: TextStyle(color: Colors.black),)) // 입력받은 날짜의 정보 (데이터베이스 연동 후 수정 예정)
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
                    onPressed: (){
                      popup('엄마 이름');
                    },
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
                              child :Text('${babies_mother}',style: TextStyle(color: Colors.black),)) // 입력받은 엄마의 정보 (데이터베이스 연동 후 수정 예정)
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
                    onPressed: (){
                      popup('아빠 이름');
                    },
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
                              child :Text('${babies_father}',style: TextStyle(color: Colors.black),)) // 입력받은 아빠의 정보 (데이터베이스 연동 후 수정 예정)
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
              child: (babies != '_' && babies_birth != '_' && babies_mother != '_' && babies_father != '_') ? 
              OutlinedButton(
                onPressed: () {
                  showDialog( // 팝업 위젯
                      context: context,
                      barrierColor: Colors.grey.withOpacity(0.6),
                      builder: (BuildContext context){
                        return  AlertDialog(
                          title: Text(''), // 상단 여백
                          content: Text('아이의 정보가 추가되었습니다',style: TextStyle(color: Color(0xFF835529)),textAlign: TextAlign.center,),
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
          flex: 4,),
          Expanded(
            child: Container(),flex: 2,
          )
        ],
      ),
    );
  }
}
