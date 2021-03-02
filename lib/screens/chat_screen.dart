import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  List<Text> dynamicList;
  final messsageTextController = TextEditingController();

  bool isSender = true;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        //currently there are someone logged in
        loggedInUser = user;
      }
    }catch(e){
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs){
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messsageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messsageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      if(messsageTextController.text != '') {
                        _firestore.collection('messages').add({
                          'text': messsageTextController.text,
                          'sender': loggedInUser.email,
                          'createdOn': FieldValue.serverTimestamp(),
                        },
                        );
                        messsageTextController.clear();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('createdOn',descending: false)
          .snapshots(),
      builder: (context,snapshot) {
        if (snapshot.hasData == false) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageWidgets = [];

        for (var message in messages) {
          final messageText = message.data()["text"];
          final messageSender = message.data()['sender'];
          final currentUser = loggedInUser.email;

          final messageWidget = MessageBubble(
            messageSender: messageSender,
            messageText: messageText,
            isSender: messageSender == currentUser,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          ),
        );

      },
    );

  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.messageSender,this.messageText,this.isSender});
  final String messageText;
  final String messageSender;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    return Column(

        crossAxisAlignment: isSender ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10.0,
          ),
          Text(
            messageSender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black45,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isSender ? BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ) : BorderRadius.only(
              bottomRight: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
            color: isSender ? Colors.lightBlueAccent : Colors.black45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(
                '$messageText',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]
    );
  }
}
