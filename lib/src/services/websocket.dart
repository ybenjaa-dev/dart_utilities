import 'dart:convert';

import 'package:apollocode_dart_utilities/src/models/ws_data.dart';
import 'package:apollocode_dart_utilities/src/models/ws_user.dart';
// ignore: implementation_imports
import 'package:alfred/src/type_handlers/websocket_type_handler.dart';
import 'package:eventify/eventify.dart';

class WebsocketService {
  static EventEmitter emitter = EventEmitter();
  static List<WsUser> users = [];

  static Future onMessage(ws, dynamic data) async {
    data = data as WSData;
    WebsocketService.emitter.emit(data.event, null, data.data);
  }

  static sendMessageToUser(WSData data, String userUid) {
    WebsocketService.users.where((user) => user.id == userUid).forEach((user) =>
        user.ws.send(jsonEncode({'channel': data.event, 'data': data.data.toString()})));
  }

  static sendMessageToUserRaw(dynamic data, String userUid) {
    WebsocketService.users
        .where((user) => user.id == userUid)
        .forEach((user) => user.ws.send(data));
  }

  static sendAll(WSData data) {
    for (var user in WebsocketService.users) {
      try {
        user.ws.send(jsonEncode({'channel': data.event, 'data': data.data}));
      } catch (_) {}
    }
  }

  static sendAllRaw(dynamic data) {
    for (var user in WebsocketService.users) {
      try {
        user.ws.send(data);
      } catch (_) {}
    }
  }
}
