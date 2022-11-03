import 'dart:io';

class WsUser {
  final WebSocket ws;
  final String id;

  const WsUser(this.ws, this.id);
}