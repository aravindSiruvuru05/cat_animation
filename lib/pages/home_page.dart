import 'package:cat_animation/widgets/cat.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catAnimationController;

  Animation<double> boxAnimation;
  AnimationController boxAnimationController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    catAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catAnimationController,
        curve: Curves.easeIn,
      ),
    );

    boxAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.68).animate(
      CurvedAnimation(
        parent: boxAnimationController,
        curve: Curves.linear,
      ),
    );

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxAnimationController.forward();
      }
    });
  }

  tapHandler() {
    if (catAnimation.isCompleted) {
      catAnimationController.reverse();
      boxAnimationController.forward();
    } else if (catAnimationController.isDismissed) {
      boxAnimationController.stop();
      catAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Cat Animation"),
      ),
      body: GestureDetector(
        onTap: tapHandler,
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              buildAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 10,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10,
          width: 75,
          color: Colors.yellow,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 10,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10,
          width: 75,
          color: Colors.yellow,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: -boxAnimation.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildBox() {
    return Container(
      color: Colors.brown,
      height: 200,
      width: 200,
      child: Center(
        child: Text(
          "Tap on me",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0,
          left: 0,
        );
      },
      child: Cat(),
    );
  }
}
