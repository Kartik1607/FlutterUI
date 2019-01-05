import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final AnimationController videoMinimizeAnimationController;
  MainPage({this.videoMinimizeAnimationController});

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _bottomNavigationIndex = 0;
  Tween<double> bottomNavigationBarTween;

  @override
  void initState() {
    super.initState();
    if (widget.videoMinimizeAnimationController != null) {
      widget.videoMinimizeAnimationController.addListener(() {
        setState(() {});
      });
      bottomNavigationBarTween = Tween(begin: 0.0, end: 56.0);
    }
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      onTap: (idx) {
        setState(() {
          _bottomNavigationIndex = idx;
        });
      },
      currentIndex: _bottomNavigationIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
        BottomNavigationBarItem(
            icon: Icon(Icons.whatshot), title: Text('Trending')),
        BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions), title: Text('Subscriptions')),
        BottomNavigationBarItem(
            icon: Icon(Icons.folder), title: Text('Library'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = bottomNavigationBarTween != null
        ? bottomNavigationBarTween
            .evaluate(widget.videoMinimizeAnimationController)
        : 56.0;
    return Scaffold(
        bottomNavigationBar:
            SizedBox(height: bottomHeight, child: _bottomNavBar()),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text("YouTube"),
              forceElevated: true,
              floating: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {},
                ),
              ],
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                color: Colors.orange,
                child: SizedBox(
                  height: 150,
                ),
              ),
              Container(
                color: Colors.green,
                child: SizedBox(
                  height: 150,
                ),
              ),
              Container(
                color: Colors.blue,
                child: SizedBox(
                  height: 150,
                ),
              ),
              Container(
                color: Colors.amber,
                child: SizedBox(
                  height: 150,
                ),
              ),
              Container(
                color: Colors.purple,
                child: SizedBox(
                  height: 150,
                ),
              ),
            ]))
          ],
        ));
  }
}
