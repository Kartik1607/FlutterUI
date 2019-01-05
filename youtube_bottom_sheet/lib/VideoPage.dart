import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final AnimationController videoMinimizeAnimationController;
  VideoPage({this.videoMinimizeAnimationController});

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  AnimationController _animationController;
  Animation<double> _totalHeightAnimation;
  Animation<double> _videoHeightAnimation;
  Animation<double> _videoWidthAnimation;
  Animation<double> _closeButtonWidthAnimation;
  Animation<double> _pauseButtonWidthAnimation;
  Animation<double> _videoTitleWidthAnimation;
  Animation<double> _paddingAnimation;
  bool _isPlaying = false;
  double _amountDragged;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4',
    )
      ..addListener(() {
        final bool isPlaying = _videoPlayerController.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _amountDragged = 0;
    _animationController = widget.videoMinimizeAnimationController ??
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double maxHeight = MediaQuery.of(context).size.height;
    double minHeight = 50.0;
    _totalHeightAnimation = Tween(begin: maxHeight, end: minHeight).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    double initialVideoWidth = MediaQuery.of(context).size.width;
    double initialVideoHeight = initialVideoWidth * 9.0 / 16.0;
    _videoHeightAnimation = Tween(begin: initialVideoHeight, end: minHeight)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    double finalVideoWidth = 150.0;
    _videoWidthAnimation = Tween(begin: initialVideoWidth, end: finalVideoWidth)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.65, 1.0, curve: Curves.easeIn)));

    _videoTitleWidthAnimation = Tween(begin: 0.0, end: 100.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.9, 1.0)));

    _closeButtonWidthAnimation = Tween(begin: 0.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.7, 0.8)));

    _pauseButtonWidthAnimation = Tween(begin: 0.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.8, 0.9)));

    _paddingAnimation =
        new Tween(begin: 0.0, end: 8.0).animate(_animationController);
  }

  Widget _fullScreenPage(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.all(_paddingAnimation.value),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Card(
          elevation: 10.0,
          margin: EdgeInsets.all(0.0),
          child: SizedBox(
            height: _totalHeightAnimation.value,
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      switch (_animationController.status) {
                        case AnimationStatus.completed:
                          _animationController.reverse();
                          break;
                        default:
                          _animationController.forward();
                      }
                    },
                    onVerticalDragUpdate: (drag) {
                      _animationController.stop(canceled: true);
                      setState(() {
                        _amountDragged -= drag.delta.dy;
                      });
                    },
                    child: Container(
                      color: Colors.black54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: <Widget>[
                          SizedBox(
                              height: _videoHeightAnimation.value,
                              width: _videoWidthAnimation.value -
                                  2 * _paddingAnimation.value,
                              child: VideoPlayer(_videoPlayerController)),
                          ClipRect(
                            child: SizedBox(
                              width: _videoTitleWidthAnimation.value,
                              height: _videoHeightAnimation.value,
                              child: Center(
                                child: Text(
                                  "Sample Video Title",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white,),
                                ),
                              ),
                            ),
                          ),
                          ClipRect(
                            child: SizedBox(
                              width: _pauseButtonWidthAnimation.value,
                              height: _videoHeightAnimation.value,
                              child: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          ClipRect(
                            child: SizedBox(
                              width: _closeButtonWidthAnimation.value,
                              height: _videoHeightAnimation.value,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.grey),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                        opacity: 1 - _animationController.value, child: child),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerWidth = MediaQuery.of(context).size.width;
    final playerHeight = playerWidth * 9.0 / 16.0;
    return AnimatedBuilder(
      animation: _animationController,
      builder: _fullScreenPage,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
                width: playerWidth, height: playerHeight, color: Colors.green),
            Container(
                width: playerWidth, height: playerHeight, color: Colors.blue),
            Container(
                width: playerWidth, height: playerHeight, color: Colors.amber),
            Container(
                width: playerWidth, height: playerHeight, color: Colors.red)
          ],
        ),
      ),
    );
  }
}
