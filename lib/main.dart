import 'package:easy_reads/routes/custom_router.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/screens/splashScreen.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  initPlatformState();
  runApp(MyApp());
}

Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("mwlyNYmsttDBEPgOYowplsCIUZfgLWdp");
  // await Purchases.setAllowSharingStoreAccount(true);
//  await Purchases.addPurchaserInfoUpdateListener((purchaserInfo) { })
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          lazy: false,
        ),
        ChangeNotifierProvider.value(value: AuthProvider.initialize()),
      ],
      child: MaterialApp(
        title: 'EasyRead',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: CustomRouter.allRoutes,
        debugShowCheckedModeBanner: false,
        initialRoute: homeRoute,
        home: SplashScreen(),
      ),
    );
  }
}



