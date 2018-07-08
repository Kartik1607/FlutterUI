import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int prime;

  _MyHomePageState() {
    prime = 0;
  }

  /// A slow algorithm to test if a number is prime or not.
  static bool isPrime(int n) {
    int count = 0;
    for (int i = 1; i <= n; ++i) {
      if (n % i == 0) {
        ++count;
      }
    }
    return count == 2;
  }

  /// Returns the nth prime number.
  static getnthPrime(SendPort sendPort) async {
    // Port for receiving message from main isolate.
    // We will receive the value of n using this port.
    ReceivePort receivePort = ReceivePort();
    // Sending the send Port of isolate to receive port of main isolate.
    sendPort.send(receivePort.sendPort);
    var msg = await receivePort.first;

    int n = msg[0];
    SendPort replyPort = msg[1];
    int currentPrimeCount = 0;
    int candidate = 1;
    while (currentPrimeCount < n) {
      ++candidate;
      if (isPrime(candidate)) {
        ++currentPrimeCount;
      }
    }
    replyPort.send(candidate);

  }

  void _getPrime() async {
    // Port where we will receive our answer to nth prime.
    // From isolate to main isolate.
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(getnthPrime, receivePort.sendPort);

    // Send port for the prime number isolate. We will send parameter n
    // using this port.
    SendPort sendPort = await receivePort.first;
    int ans = await sendReceive(sendPort, 1000);
    setState(() {
      prime = ans;
    });
  }

  Future sendReceive(SendPort send, message) {
    ReceivePort receivePort = ReceivePort();
    send.send([message, receivePort.sendPort]);
    return receivePort.first;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(prime.toString()),
            LinearProgressIndicator(
              value: null,
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _getPrime,
        tooltip: 'Find Prime',
        child: new Icon(Icons.autorenew),
      ),
    );
  }
}
