import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_pda/flutter_pda.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title = ''});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterPda _flutterPda = FlutterPda();
  late StreamSubscription _flutterPdaStateSubscription;

  String _code = 'code';
  bool _isSound = false;
  bool _isVibrate = false;
  String _sendMode = 'BROADCAST';

  @override
  void initState() {
    super.initState();
    // 监听PDA
    _flutterPdaStateSubscription = _flutterPda.onPdaStateChanged.listen((code) {
      setState(() {
        _code = code;
      });
    });
    _initFlutterPda();
  }

  // 初始化PDA
  Future _initFlutterPda() async {
    bool isSound = await _flutterPda.isSoundPlay;
    bool isVibrate = await _flutterPda.isVibrate;
    String sendMode = await _flutterPda.sendMode;
    print('-------------------isSound=$isSound');
    print('-------------------isVibrate=$isVibrate');
    print('-------------------sendMode=$sendMode');
    setState(() {
      _isSound = isSound;
      _isVibrate = isVibrate;
      _sendMode = sendMode;
    });
  }

  // 设置声音
  Future _onSoundPlay(isSound) async {
    setState(() {
      _isSound = isSound;
    });
    await _flutterPda.setSoundPlay(isSound);
  }

  // 设置振动
  Future _onVibrate(isVibrate) async {
    setState(() {
      _isVibrate = isVibrate;
    });
    await _flutterPda.setVibrate(isVibrate);
  }

  // 设置条形码发送方式
  // 参数: sendMode
  //  1、焦点录入(FOCUS)
  //  2、焦点(BROADCAST)
  //  3、模拟按键(EMUKEY)
  //  4、剪切板(CLIPBOARD)
  Future _onSendMode(sendMode) async {
    setState(() {
      _sendMode = sendMode;
    });
    await _flutterPda.setSendMode(sendMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('扫描声音'),
                Container(
                    child: Switch(value: _isSound, onChanged: _onSoundPlay)),
              ],
            ),
            Row(
              children: [
                Text('振动'),
                Container(
                    child: Switch(value: _isVibrate, onChanged: _onVibrate)),
              ],
            ),
            Row(
              children: [
                Text('条码发送方式'),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Radio(
                        value: "FOCUS",
                        groupValue: _sendMode,
                        onChanged: _onSendMode),
                    Text('焦点录入'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "BROADCAST",
                        groupValue: _sendMode,
                        onChanged: _onSendMode),
                    Text('广播'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "EMUKEY",
                        groupValue: _sendMode,
                        onChanged: _onSendMode),
                    Text('模拟按键'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "CLIPBOARD",
                        groupValue: _sendMode,
                        onChanged: _onSendMode),
                    Text('剪切板'),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(_code),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 取消PDA
    if (_flutterPdaStateSubscription != null) {
      _flutterPdaStateSubscription.cancel();
    }
  }
}
