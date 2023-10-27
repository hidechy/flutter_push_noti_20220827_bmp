import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //メッセージ内容を入れるコントローラー
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.32),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "通知タイトル"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.32),
                child: TextFormField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: "通知内容"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final FirebaseMessaging firebaseMessaging =
                      FirebaseMessaging.instance;

                  // この端末が、どのグループ(all-devices)に属しているかの定義
                  await firebaseMessaging.subscribeToTopic('all-devices');

                  // functionsをインスタンス化して、どの関数を使うかどうかを定義している
                  HttpsCallable callable =
                      FirebaseFunctions.instanceFor(region: "asia-northeast1")
                          .httpsCallable('sendPushNotificationTopicCustom');

                  // 通知のtitleとbodyを入れるmap
                  Map<String, String> pushMessageMap = {
                    'title': titleController.text,
                    'body': bodyController.text,
                  };

                  // functionsの関数を呼び出す!第一引数にメッセージ内容を渡す！
                  // 関数自体はpush_notifier_8_27\functions\src\index.tsに記載して
                  // いますのでご確認ください。
                  await callable(pushMessageMap);

                  print('通知送信しました');
                },
                child: const Text('通知送信'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
