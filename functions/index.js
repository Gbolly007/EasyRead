const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp(functions.config().functions);

exports.onComment = functions.firestore.document('post/{id}/comment/{commentId}').onCreate(async (snapshot, context)=>{


    if (snapshot.empty) {
         console.log('No Devices');
         return;
    }

    const commentItem = snapshot.data();

    const userRef = admin.firestore().doc(`users/${commentItem.uidnotify}`);

    const doc = await userRef.get();

    const androidNotificationToken = doc.data().androidNotificationToken;

    if(androidNotificationToken && commentItem.uidnotify != commentItem.uid )
    {
        sendNotification(androidNotificationToken, commentItem);
    }
    else
      {
        console.log("No token for user, can not send notification.")
      }

      function sendNotification(androidNotificationToken, msgItem){
              let body = `${msgItem.name} just replied to your post ${msgItem.postname} `;
              let pages = `PostDetail`;
              let click_actions=`FLUTTER_NOTIFICATION_CLICK`;

               const message =
                      {
                          notification: { body },
                          token: androidNotificationToken,
                          data : {
                             page: pages,
                             click_action: click_actions,
                             postId: msgItem.postId
                          }

                      };


               admin.messaging().send(message)
                       .then(response =>
                       {
                           console.log("Successfully sent message", response);
                       })
                       .catch(error =>
                       {
                           console.log("Error sending message", error);
                       })

            }


});

exports.onUniqueCode = functions.firestore.document('uniquecode/{id}').onCreate(async (snapshot, context)=>{


    if (snapshot.empty) {
         console.log('No Devices');
         return;
    }

    const ucItem = snapshot.data();

    const userRef = admin.firestore().doc(`users/${ucItem.uid}`);

    const doc = await userRef.get();

    const androidNotificationToken = doc.data().androidNotificationToken;

    if(androidNotificationToken)
    {
        sendNotification(androidNotificationToken, ucItem);
    }
    else
      {
        console.log("No token for user, can not send notification.");
      }

      function sendNotification(androidNotificationToken, msgItem){
              let body = `${msgItem.name} signed up using your uniquecode `;
              let pages = `PostDetail`;
              let click_actions=`FLUTTER_NOTIFICATION_CLICK`;

               const message =
                      {
                          notification: { body },
                          token: androidNotificationToken,
                          data : {
                             page: pages,
                             click_action: click_actions
                          }

                      };


               admin.messaging().send(message)
                       .then(response =>
                       {
                           console.log("Successfully sent message", response);
                       })
                       .catch(error =>
                       {
                           console.log("Error sending message", error);
                       })

       }

});

exports.onLike = functions.firestore.document('post/{id}/like/{commentId}').onCreate(async (snapshot, context)=>{


    if (snapshot.empty) {
         console.log('No Devices');
         return;
    }

    const commentItem = snapshot.data();

    const userRef = admin.firestore().doc(`users/${commentItem.uidnotify}`);

    const doc = await userRef.get();

    const androidNotificationToken = doc.data().androidNotificationToken;

    if(androidNotificationToken && commentItem.uidnotify != commentItem.uid )
    {
        sendNotification(androidNotificationToken, commentItem);
    }
    else
      {
        console.log("No token for user, can not send notification.")
      }

      function sendNotification(androidNotificationToken, msgItem){
              let body = `${msgItem.name} liked your post ${msgItem.postname} `;
              let pages = `PostDetail`;
              let click_actions=`FLUTTER_NOTIFICATION_CLICK`;

               const message =
                      {
                          notification: { body },
                          token: androidNotificationToken,
                          data : {
                             page: pages,
                             click_action: click_actions,
                             postId: msgItem.postId
                          }

                      };


               admin.messaging().send(message)
                       .then(response =>
                       {
                           console.log("Successfully sent message", response);
                       })
                       .catch(error =>
                       {
                           console.log("Error sending message", error);
                       })

            }


});


