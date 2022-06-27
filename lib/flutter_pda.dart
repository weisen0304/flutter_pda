
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPda {
  static const MethodChannel _channel =
      const MethodChannel('flutter_pda/method');

  static const EventChannel _eventChannel = const EventChannel('flutter_pda/event');

  Future<bool> get isSoundPlay async => await _channel.invokeMethod("getSoundPlay");

  Future<void> getSoundPlay() async {
    return await _channel.invokeMethod("getSoundPlay");
  }

  Future<void> setSoundPlay(bool isSound) async {
    await _channel.invokeMethod<void>('setSoundPlay',  <String, dynamic>{'isSound': isSound},);
  }

  Future<bool> get isVibrate async => await _channel.invokeMethod("getVibrate");

  Future<void> getVibrate() async {
    return await _channel.invokeMethod("getVibrate");
  }

  Future<void> setVibrate(bool isVibrate) async {
    await _channel.invokeMethod<void>('setVibrate',  <String, dynamic>{'isVibrate': isVibrate},);
  }

  Future<String> get sendMode async => await _channel.invokeMethod("getSendMode");

  Future<void> getSendMode() async {
    return await _channel.invokeMethod("getSendMode");
  }

  Future<void> setSendMode(sendMode) async {
    await _channel.invokeMethod<void>('setSendMode',  <String, dynamic>{'sendMode': sendMode},);
  }

  Stream _onPdaStateChanged;

  Stream onPdaChanged() {
    if (_onPdaStateChanged == null) {
      _onPdaStateChanged = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => event);
    }
    return _onPdaStateChanged;
  }

  Stream get onPdaStateChanged => onPdaChanged();

}
