import 'dart:io';

class ServerSocket {
  Socket _socket;
  List<Message> chat = [];

  void connect(User _userData, Function receive, ip) async {
    await Socket.connect(ip, 8000).then((Socket sock) {
      this._socket = sock;
      _socket.listen(receive,
          onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      print("Unable to connect: $e");
    });

    _socket.write("1" +
        _userData.nome.toLowerCase() +
        "%/" +
        _userData.cognome.toLowerCase());
  }

  void _errorHandler(error, StackTrace trace) {
    print(error);
  }

  void Destroy() {
    _socket.destroy();
  }

  void _doneHandler() {
    _socket.destroy();
  }

  void send(data) {
    _socket.write(data);
  }
}

class Message { 
  String _name;
  String _surname;
  DateTime _dateTime;
  String _message;

  Message(this._name, this._surname, this._dateTime, this._message);

  String get name => this._name;
  String get surname => this._surname;
  String get time =>
      getTime(this._dateTime.hour.toString()) +
      ":" +
      getTime(this._dateTime.minute.toString());
  String get message => this._message;

  String getTime(String time) {
    return (int.parse(time) < 9) ? "0" + time : time;
  }
}

class User {
  User(this.nome, this.cognome);
  String nome;
  String cognome;
}
