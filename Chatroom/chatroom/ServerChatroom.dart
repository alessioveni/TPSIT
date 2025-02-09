import 'dart:io';

List<ChatClient> clients = [];

void main() {
  Messaggi = new List();
  ServerSocket server;
  ServerSocket.bind(InternetAddress.anyIPv4, 8000).then((ServerSocket socket) {
    server = socket;
    print('Connection.. --> ' + server.address.address);
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print("\n");
  print("Connected:");
  clients.add(ChatClient(client));
}

void removeClient(ChatClient client) {
  clients.remove(client);
}

List<String> Messaggi;

class ChatClient {
  Socket _socket;
  String get address => _socket.remoteAddress.address;
  int get port => _socket.remotePort;
  User user = new User();

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) {
    String istruzioni = new String.fromCharCodes(data).trim();
    int istruzioniCode = int.parse(istruzioni[0]);
    String istruzioniData = istruzioni.substring(1);

    switch (istruzioniCode) {
      case 1:
        {
          var userData = istruzioniData.split("%/");
          print("Un nuovo Utente si e' appena collegato!");
          print("\n");
          try {
            user.name = userData[0];
            user.surname = userData[1];
          } catch (e) {
          }
          if (user.isNotNull()) {
            String msg = "";
            for (int i = 0; i < Messaggi.length; i++) {
              msg += Messaggi[i] + "|";
            }
            _socket.write("0" + msg);
          }
          break;
        }
      case 2: 
        {
          print("Mex: " + istruzioniData);

          Messaggi.add(istruzioniData);
          clients.forEach((client) {
            client._socket.write("0" + istruzioniData);
          });
          break;
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {}
}

class User {
  String _name;
  String _surname;

  String get name => this._name;
  String get surname => this._surname;

  set name(String name) => this._name = name;
  set surname(String surname) => this._surname = surname;

  bool isNotNull() {
    return this._name != null && this._surname != null ? true : false;
  }

  String toString() {
    return this._name + "|" + this._surname + "|";
  }
}
