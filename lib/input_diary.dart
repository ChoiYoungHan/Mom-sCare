import 'dart:io';
import 'package:care_application/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class input_diary extends StatelessWidget {
  const input_diary({Key? key, required this.selectedDate}) : super(key: key);

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 우측 상단에 출력되는 Debug 리본을 제거
        home: inputdiary_Page(selectedDate: selectedDate)
    );
  }
}

class inputdiary_Page extends StatefulWidget {
  const inputdiary_Page({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;

  @override
  State<inputdiary_Page> createState() => _inputdiary_PageState();
}

class _inputdiary_PageState extends State<inputdiary_Page> {

  // 다이어리를 작성할 때 사용할 텍스트 필드
  TextEditingController inputDiary = TextEditingController();

  // ImagePicker 객체 선언
  ImagePicker picker = ImagePicker();

  // 갤러리에서 선택한 이미지를 저장할 리스트배열
  List<XFile> imageList = [];

  // 비동기 처리를 통해 갤러리에서 이미지를 가져옴
  Future<void> getImage() async {
    final List<XFile> images = await picker.pickMultiImage();
    if(images != null){
      setState(() {
        imageList = images;
      });
    }
  }

  Future<void> uploadImages() async {
    String url = 'http://182.219.226.49/upload';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    for(var imageFile in imageList){
      request.files.add(await http.MultipartFile.fromPath('images', imageFile.path));
    }

    var response = await request.send();

    if(response.statusCode == 200){
      print('Image Upload');
      imageList.clear(); // 이미지 업로드가 성공하면 배열을 초기화
    } else {
      print('Upload Failed');
    }
  }

  // 비동기 처리를 통해 카메라로 촬영해서 이미지를 가져옴
  Future<void> getCamera() async {
    final XFile? images = await picker.pickImage(source: ImageSource.camera);

    if(images != null){
      setState(() {
        imageList.add(images);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 상 중 하로 나누는 위젯
      resizeToAvoidBottomInset: false, // 화면이 밀려 올라가는 것을 방지
      appBar: AppBar( // 상단바
          backgroundColor: Colors.white, // 배경은 흰색
          leading: IconButton( // 좌측에 정렬 & 아이콘 버튼 위젯
              onPressed: (){ // 수행할 코드를 작성
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar_Page())); // Calendar_Page로 이동
              },
              icon: Icon(Icons.arrow_back, color: Colors.grey) // 아이콘은 뒤로가기 아이콘을 넣으며 색상은 회색
          ),
          title: Text( // 중앙에 제목 작성 & 텍스트 위젯을 사용
              '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일', style: TextStyle(color: Colors.grey) // 받아온 날짜 출력 & 글자 색은 회색
          ),
          actions: [ // 우측에 정렬
            TextButton( // 텍스트버튼
                onPressed: (){ // 수행할 코드를 작성

                }, child: Text('완료', style: TextStyle(color: Colors.orange))) // 텍스트로 '완료' & 주황색
          ]
      ),
      body: SafeArea( // MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시
          child: GestureDetector( // Container와 같이 Gesture를 감지할 수 없는 위젯들에게 Gesture 기능을 부여할 수 있는 위젯
              child: Column( // 세로 정렬
                  mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                  children: [
                    Expanded(child: Container( // 박스 위젯
                      padding: EdgeInsets.all(5), // 네 면의 여백을 5 만큼 줌
                      child: TextField( // 텍스트필드 위젯
                          controller: inputDiary, // 입력받은 값은 변수 inputDiary에 저장
                          maxLines: null, // maxLines를 null로 주어 글의 양에 맞게 세로 길이가 변하도록 함
                          decoration: InputDecoration( // 디자인
                              hintText: '내용을 입력해주세요',
                              border: OutlineInputBorder( // 모서리에 테두리를 줄 것임
                                  borderSide: BorderSide(color: Colors.grey) // 테두리의 색상을 회색
                              )
                          )
                      ),
                    ), flex: 8),
                    Expanded(child: Container( // 상자 위젯
                        child: Row( // 가로 정렬
                            mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                            children: [
                              Container( // 상자 위젯
                                padding: EdgeInsets.all(5), // 네 면의 여백을 5만큼 줌
                                // MediaQuery의 size.width 속성은 디바이스의 화면 가로길이를 가져온다.
                                width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%를 너비로 설정
                                height: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%를 높이로 설정
                                child: ElevatedButton( // 버튼 위젯
                                    onPressed: (){ // 동작을 위해 필요한 코드를 작성
                                      showModalBottomSheet( // 화면의 아래에 모달시트를 보여줌
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container( // 상자 위젯 반환
                                                decoration: BoxDecoration( // 디자인
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10) // 모서리를 10만큼 둥글게
                                                ),
                                                height: MediaQuery.of(context).size.height * 0.25, // 화면 세로 길이의 25%를 높이로 설정
                                                child: Center( // 가운데에 배치하는 위젯
                                                    child: Row( // 가로 정렬
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정한 간격을 두고 배치
                                                        mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
                                                        children: [
                                                          InkWell( // 터치 이벤트를 처리할 수 없는 위젯을 감싸서 터치 이벤트를 처리할 수 있도록 하는 위젯
                                                              onTap: () async { // 한 번 클릭할 경우
                                                                await getCamera(); // getCamera() 메소드 호출
                                                                if(imageList.isNotEmpty){
                                                                  await uploadImages();
                                                                }
                                                              },
                                                              child: Padding( // 여백을 주기 위해 사용하는 위젯
                                                                  padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                                  child: Container( // 상자 위젯
                                                                      width: MediaQuery.of(context).size.width * 0.4, // 화면 가로 길이의 40%를 너비를 줌
                                                                      decoration: BoxDecoration( // 상자 디자인
                                                                          borderRadius: BorderRadius.circular(10), // 네 면의 모서리를 10만큼 둥글게 함
                                                                          border: Border.all(color: Colors.grey, width: 2) // 테두리 색상은 회색, 두께는 2
                                                                      ),
                                                                      child: Column( // 세로 정렬
                                                                          children: [
                                                                            Padding( // 여백을 주기 위해 사용하는 위젯
                                                                                padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                                                child: Image.asset('assets/camera.png', // 사진 이미지 불러오기
                                                                                    width: MediaQuery.of(context).size.width * 0.2, // 화면 가로 길이의 20%만큼 너비를 줌
                                                                                    height: MediaQuery.of(context).size.height * 0.13, // 화면 세로 길이의 13%만큼 높이를 줌
                                                                                    color: Colors.grey // 색상은 회색
                                                                                )
                                                                            ),
                                                                            Text('카메라', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 글자색은 회색, 크기 20, 볼드체
                                                                          ]
                                                                      )
                                                                  )
                                                              )
                                                          ),
                                                          InkWell( // 터치 이벤트를 처리할 수 없는 위젯을 감싸서 터치 이벤트를 처리할 수 있도록 하는 위젯
                                                              onTap: () async { // 한 번 클릭할 경우
                                                                await getImage(); // getImage() 메소드 호출
                                                                if(imageList.isNotEmpty){
                                                                  await uploadImages();
                                                                }
                                                              },
                                                              child: Padding( // 여백을 주기 위해 사용하는 위젯
                                                                  padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                                  child: Container( // 상자 위젯
                                                                      width: MediaQuery.of(context).size.width * 0.4, // 화면 가로 길이의 40%를 너비로 줌
                                                                      decoration: BoxDecoration( // 상자 디자인
                                                                          borderRadius: BorderRadius.circular(10), // 네 면의 모서리를 10만큼 둥글게 함
                                                                          border: Border.all(color: Colors.grey, width: 2) // 테두리는 회색, 두께는 2
                                                                      ),
                                                                      child: Column( // 세로 정렬
                                                                          children: [
                                                                            Padding( // 여백을 주기 위해 사용하는 위젯
                                                                                padding: EdgeInsets.all(10), // 모든 면의 여백을 10만큼 줌
                                                                                child: Image.asset('assets/gallery.png', // 갤러리 이미지 불러오기
                                                                                    width: MediaQuery.of(context).size.width * 0.2, // 화면 가로 길이의 20%만큼 너비를 줌
                                                                                    height: MediaQuery.of(context).size.height * 0.13, // 화면 세로 길이의 13%만큼 높이를 줌줌
                                                                                    color: Colors.grey // 색상은 회색
                                                                                )
                                                                            ),
                                                                            Text('갤러리', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)) // 색상은 회색, 크기 20, 볼드체
                                                                          ]
                                                                      )
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            );
                                          }
                                      );
                                    },
                                    child: Icon(Icons.add_box_outlined) // 아이콘 위젯
                                ),
                              ),
                              Container( // 상자 위젯
                                  padding: EdgeInsets.all(5), // 네 면의 여백을 5만큼 줌
                                  width: MediaQuery.of(context).size.width * 0.7, // 화면 가로 길이의 70%를 너비로 설정
                                  height: MediaQuery.of(context).size.width * 0.7, // 화면 가로 길이의 70%를 높이로 설정
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal, // 리스트뷰를 가로로 함
                                      itemCount: imageList.length, // imageList의 길이만큼 item을 생성
                                      itemBuilder: (context, index){
                                        return Container( // 상자 위젯
                                            margin: EdgeInsets.all(3), // 네 면의 여백을 3만큼 줌
                                            width: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%를 너비로 설정
                                            height: MediaQuery.of(context).size.width * 0.3, // 화면 가로 길이의 30%를 높이로 설정
                                            child: Image.file(File(imageList[index].path), fit: BoxFit.cover) // 갤러리에서 가져온 이미지를 출력한다. 이미지는 꽉 채움
                                        );
                                      })
                              )
                            ]
                        )
                    ), flex: 2)
                  ]
              )
          )
      ),
    );
  }
}
