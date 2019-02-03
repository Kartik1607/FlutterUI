import 'package:flutter/material.dart';
import 'package:youtube_bottom_sheet/MainPage.dart';
import 'package:youtube_bottom_sheet/VideoPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Youtube());
  }
}

class Youtube extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return YoutubeState();
  }
}

class YoutubeState extends State<Youtube> with TickerProviderStateMixin {
  AnimationController _videoMinimizeAnimationController;
  Tween<double> paddingTween;

  @override
  void initState() {
    super.initState();
    _videoMinimizeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    paddingTween = Tween(begin: 0, end: 56.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MainPage(
          videoMinimizeAnimationController: _videoMinimizeAnimationController,
        ),
        AnimatedBuilder(
          animation: _videoMinimizeAnimationController,
          builder: (BuildContext context, Widget child) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: paddingTween
                        .evaluate(_videoMinimizeAnimationController)),
                child: child);
          },
          child: VideoPage(
            videoMinimizeAnimationController:
                this._videoMinimizeAnimationController,
          ),
        )
      ],
    );
  }
}
