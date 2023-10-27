import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

// サーバーの場所を定義
const REGION = "asia-northeast1";

// トピック(全端末に通知を送ることができる機能)でプッシュ通知を送ります。
// pushMessageMapは、home_page.dartの56行目付近で定義しています。Map型になっているので、
// title: pushMessageMap["title"], body: pushMessageMap["body"]のように指定してあげています。
export const sendPushNotificationTopicCustom =
  functions
      .region(REGION).https.onCall(async (pushMessageMap, context) => {
        console.log("pushMessageMap内容:");
        console.log(pushMessageMap);

        // messagingインスタンス内のsendメソッドを使ってメッセージを送信します。
        // topicには今回は"all-devices"という名前(グループ名みたいなもの)をつけています。
        // グループに属している端末全てに通知を送信します。
        const messaging = admin.messaging();
        const res = await messaging
            .send({
              notification: {title: pushMessageMap["title"],
                body: pushMessageMap["body"]},
              topic: "all-devices",
            });
        console.log(res);
      });
