import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayer/secondPage.dart';
import 'package:musicplayer/song_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController topAnimation;
  AnimationController movement;
  bool show = false;
  int selectedIndex;

  int getFactor(int index) {
    if (selectedIndex == index || selectedIndex == null) return 0;
    if (selectedIndex < index) return -1;
    return 1;
  }

  _onTapped(index) async {
    setState(() {
      selectedIndex = index;
    });
    movement.forward();
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 750),
        reverseTransitionDuration: Duration(milliseconds: 750),
        pageBuilder: (context, anim, anim2) => FadeTransition(
          opacity: anim,
          child: SecondScreen(
            data: songs[index],
          ),
        ),
      ),
    );
    movement.reverse();
  }

  @override
  void initState() {
    topAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: .07,
      upperBound: .2,
    );
    movement = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Music cards",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
                animation: topAnimation,
                builder: (context, snapshot) {
                  var val = topAnimation.value;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {
                          if (!show) {
                            topAnimation.forward().whenComplete(() {
                              setState(() {
                                show = true;
                              });
                            });
                          } else {
                            topAnimation.reverse().whenComplete(() {
                              setState(() {
                                show = false;
                              });
                            });
                          }
                        },
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, .001)
                            ..rotateX(val),
                          child: AbsorbPointer(
                            absorbing: !show,
                            child: Container(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth * .55,
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  ...List.generate(
                                    4,
                                    (index) => AnimatedBuilder(
                                        animation: movement,
                                        builder: (context, child) {
                                          return TopCard(
                                              height:
                                                  constraints.maxHeight / 2.2,
                                              width: constraints.maxWidth,
                                              song: songs[index],
                                              depth: index,
                                              val: val,
                                              motionFactor: getFactor(index),
                                              movement: movement.value,
                                              onTap: () {
                                                _onTapped(index);
                                              });
                                        }),
                                  ).reversed,
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          SizedBox(height: 15),
          BottomSection(),
        ],
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  Song song;
  double height;
  double width;
  double percent;
  int depth;
  int motionFactor;
  Function onTap;
  double val;
  double movement;
  TopCard({
    this.song,
    this.height,
    this.width,
    this.depth,
    this.val,
    this.motionFactor,
    this.onTap,
    this.movement,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: height + (-depth * 1.5 * (height / 1) * (val)) - height / 4 + 30,
      child: Hero(
        tag: song.name,
        flightShuttleBuilder: (context, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          Widget transitionWidget;

          if (flightDirection == HeroFlightDirection.push) {
            transitionWidget = toHeroContext.widget;
          } else {
            transitionWidget = fromHeroContext.widget;
          }

          return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                var rotationVal = lerpDouble(0.0, 2 * 3.14, animation.value);
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateX(rotationVal),
                  child: transitionWidget,
                );
              });
        },
        child: Opacity(
          opacity: movement == 0 ? 1 : movement,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(
                0.0,
                MediaQuery.of(context).size.height * motionFactor * movement,
              ),
            child: Transform.scale(
              scale: 1 - (val * depth) * .25,
              child: GestureDetector(
                onTap: onTap,
                child: Card3D(
                  song: song,
                  height: height,
                  width: width,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSection extends StatelessWidget {
  const BottomSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Recently played',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) =>
                  SizedBox(width: index == 0 ? 0 : 15),
              itemBuilder: (context, index) => index == 0
                  ? SizedBox(width: 15)
                  : Card3D(
                      song: songs[index - 1],
                      height: 180,
                      width: 180,
                    ),
              itemCount: songs.length + 1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class Card3D extends StatelessWidget {
  Song song;
  double height;
  double width;
  Card3D({this.song, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: PhysicalModel(
        elevation: 5,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: height,
            width: width,
            child: Image.asset(
              song.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
