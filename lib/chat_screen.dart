import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  static const String id = "CHATWINDOW";
  final FirebaseUser user;

  const ChatWindow({Key key, this.user}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection("message").add({
        "text": messageController.text,
        "from": widget.user.email,
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
            tag: "logo",
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40.0,
                child: Image.asset("assets/images/face.png"),
              ),
            )),
        title: Text("My Chat"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              })
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection("messages").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                    child: CircularProgressIndicator()
                );

              List<DocumentSnapshot> docs = snapshot.data.documents;

              List<Widget> messages = docs.map((doc) => Message(
                from: doc.data["from"],
                text: doc.data["text"],
                me: widget.user.email == doc.data["from"],
              )).toList();

              return ListView(
                controller: scrollController,
                children: <Widget>[
                  ...messages,
                ],
              );
            },
          )),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter your message...",
                    border: const OutlineInputBorder(),
                  ),
                )),
                SendButton(
                  text: "Send",
                  callback: callback,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
        color: Colors.orange, onPressed: callback, child: Text(text));
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}