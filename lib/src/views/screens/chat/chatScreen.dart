import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;


  @override
  Widget build(BuildContext context) {
    return const Scaffold(

    );
  }
}
