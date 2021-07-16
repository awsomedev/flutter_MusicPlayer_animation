import 'package:flutter/material.dart';
import 'package:musicplayer/first_page.dart';
import 'package:musicplayer/song_model.dart';

class SecondScreen extends StatefulWidget {
  final Song data;
  const SecondScreen({this.data});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * .15,
            ),
            Hero(
              tag: widget.data.name,
              child: Card3D(
                song: widget.data,
                height: 200,
                width: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
