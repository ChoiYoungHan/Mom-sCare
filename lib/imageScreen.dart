import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullscreenImagePage extends StatefulWidget {
  final List<String> imageUrl;
  final int Index;

  FullscreenImagePage({required this.imageUrl, this.Index = 1});

  @override
  _FullscreenImagePageState createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  late PageController controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.Index;
    controller = PageController(initialPage: widget.Index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.grey)
            ),
          ),
          body: PageView.builder(
            controller: controller,
            itemCount: widget.imageUrl.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: CachedNetworkImage(
                      imageUrl: 'http://182.219.226.49/image/' + widget.imageUrl[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error)
                  )
              );
            },
          )
      ),
    );
  }
}